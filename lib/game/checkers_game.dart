import 'dart:math';

import '../models/move.dart';
import '../models/piece.dart';
import '../utils/board_utils.dart';

/// Core game engine for checkers. Keeps track of the board state and is able to
/// evaluate legal moves, apply them and determine the match outcome.
class CheckersGame {
  CheckersGame() {
    reset();
  }

  late List<List<Piece?>> _board;
  PieceColor _currentTurn = PieceColor.red;
  PieceColor? _winner;

  /// Resets the board to its initial configuration.
  void reset() {
    _board = BoardUtils.initialBoard();
    _currentTurn = PieceColor.red;
    _winner = null;
  }

  /// Returns a defensive copy of the board to avoid exposing internal state.
  List<List<Piece?>> get board => BoardUtils.cloneBoard(_board);

  /// Color of the player whose turn it currently is.
  PieceColor get currentTurn => _currentTurn;

  /// Returns the winner if the game has ended, otherwise null.
  PieceColor? get winner => _winner;

  /// Returns true if the game is currently over.
  bool get isGameOver => _winner != null;

  /// Returns the piece located at the given position, or null if the square is
  /// empty or outside the board.
  Piece? pieceAt(int row, int col) {
    if (!BoardUtils.isInsideBoard(row, col)) {
      return null;
    }
    return _board[row][col];
  }

  /// Evaluates all legal moves for the provided [color].
  List<Move> legalMovesFor(PieceColor color) {
    final captures = <Move>[];
    final simpleMoves = <Move>[];
    for (var row = 0; row < BoardUtils.boardSize; row++) {
      for (var col = 0; col < BoardUtils.boardSize; col++) {
        final piece = _board[row][col];
        if (piece == null || piece.color != color) {
          continue;
        }
        final pieceMoves = _legalMovesForPiece(piece);
        for (final move in pieceMoves) {
          if (move.isCapture) {
            captures.add(move);
          } else {
            simpleMoves.add(move);
          }
        }
      }
    }
    return captures.isNotEmpty ? captures : simpleMoves;
  }

  /// Attempts to execute the provided [move]. Returns `true` when the move was
  /// legal and successfully applied.
  bool makeMove(Move move) {
    if (isGameOver) {
      return false;
    }
    final legalMoves = legalMovesFor(_currentTurn);
    final normalized = _findMatchingMove(move, legalMoves);
    if (normalized == null) {
      return false;
    }
    _applyMove(normalized);
    _updateWinner();
    if (!isGameOver) {
      _currentTurn = _opponentOf(_currentTurn);
    }
    return true;
  }

  /// Creates a deep clone of the current game state. Useful for simulations.
  CheckersGame clone() {
    final cloned = CheckersGame._internal(
      board: BoardUtils.cloneBoard(_board),
      currentTurn: _currentTurn,
      winner: _winner,
    );
    return cloned;
  }

  CheckersGame._internal({
    required List<List<Piece?>> board,
    required PieceColor currentTurn,
    required PieceColor? winner,
  }) {
    _board = board;
    _currentTurn = currentTurn;
    _winner = winner;
  }

  Move? _findMatchingMove(Move input, List<Move> candidates) {
    for (final move in candidates) {
      if (move == input) {
        return move;
      }
    }
    return null;
  }

  void _applyMove(Move move) {
    final piece = _board[move.fromRow][move.fromCol];
    if (piece == null) {
      return;
    }
    _board[move.fromRow][move.fromCol] = null;
    for (final captured in move.capturedPieces) {
      _board[captured.x][captured.y] = null;
    }
    final bool promoted = move.promotesToKing ||
        (!piece.isKing && _shouldPromote(piece.color, move.toRow));
    final updatedPiece = piece.copyWith(
      row: move.toRow,
      col: move.toCol,
      isKing: piece.isKing || promoted,
    );
    _board[move.toRow][move.toCol] = updatedPiece;
  }

  List<Move> _legalMovesForPiece(Piece piece) {
    final captureMoves = _captureMovesForPiece(piece);
    if (captureMoves.isNotEmpty) {
      return captureMoves;
    }
    return _simpleMovesForPiece(piece);
  }

  List<Move> _simpleMovesForPiece(Piece piece) {
    final moves = <Move>[];
    for (final direction in _movementDirections(piece)) {
      final targetRow = piece.row + direction.x;
      final targetCol = piece.col + direction.y;
      if (!BoardUtils.isInsideBoard(targetRow, targetCol)) {
        continue;
      }
      if (_board[targetRow][targetCol] != null) {
        continue;
      }
      final promotes = !piece.isKing && _shouldPromote(piece.color, targetRow);
      moves.add(Move(
        fromRow: piece.row,
        fromCol: piece.col,
        toRow: targetRow,
        toCol: targetCol,
        promotesToKing: promotes,
      ));
    }
    return moves;
  }

  List<Move> _captureMovesForPiece(Piece piece) {
    final boardSnapshot = BoardUtils.cloneBoard(_board);
    return _searchCaptures(
      color: piece.color,
      board: boardSnapshot,
      originRow: piece.row,
      originCol: piece.col,
      currentRow: piece.row,
      currentCol: piece.col,
      accumulatedCaptures: const [],
      isKing: piece.isKing,
      hasPromoted: false,
    );
  }

  List<Move> _searchCaptures({
    required PieceColor color,
    required List<List<Piece?>> board,
    required int originRow,
    required int originCol,
    required int currentRow,
    required int currentCol,
    required List<Point<int>> accumulatedCaptures,
    required bool isKing,
    required bool hasPromoted,
  }) {
    var foundCapture = false;
    final moves = <Move>[];
    for (final direction in _movementDirectionsForColor(color, isKingOverride: isKing)) {
      final midRow = currentRow + direction.x;
      final midCol = currentCol + direction.y;
      final landingRow = currentRow + direction.x * 2;
      final landingCol = currentCol + direction.y * 2;
      if (!BoardUtils.isInsideBoard(landingRow, landingCol)) {
        continue;
      }
      final midPiece = board[midRow][midCol];
      if (midPiece == null || midPiece.color == color) {
        continue;
      }
      if (board[landingRow][landingCol] != null) {
        continue;
      }
      foundCapture = true;
      final simulatedBoard = BoardUtils.cloneBoard(board);
      simulatedBoard[currentRow][currentCol] = null;
      simulatedBoard[midRow][midCol] = null;
      final promotes = !isKing && _shouldPromote(color, landingRow);
      final nextIsKing = isKing || promotes;
      final nextHasPromoted = hasPromoted || promotes;
      simulatedBoard[landingRow][landingCol] = Piece(
        row: landingRow,
        col: landingCol,
        color: color,
        isKing: nextIsKing,
      );
      final capturePoint = BoardUtils.point(midRow, midCol);
      final nextCaptures = List<Point<int>>.from(accumulatedCaptures)..add(capturePoint);
      final tailMoves = _searchCaptures(
        color: color,
        board: simulatedBoard,
        originRow: originRow,
        originCol: originCol,
        currentRow: landingRow,
        currentCol: landingCol,
        accumulatedCaptures: nextCaptures,
        isKing: nextIsKing,
        hasPromoted: nextHasPromoted,
      );
      if (tailMoves.isEmpty) {
        moves.add(Move(
          fromRow: originRow,
          fromCol: originCol,
          toRow: landingRow,
          toCol: landingCol,
          capturedPieces: nextCaptures,
          promotesToKing: nextHasPromoted,
        ));
      } else {
        moves.addAll(tailMoves);
      }
    }
    if (!foundCapture && accumulatedCaptures.isNotEmpty) {
      moves.add(Move(
        fromRow: originRow,
        fromCol: originCol,
        toRow: currentRow,
        toCol: currentCol,
        capturedPieces: accumulatedCaptures,
        promotesToKing: hasPromoted,
      ));
    }
    return moves;
  }

  List<Point<int>> _movementDirections(Piece piece) {
    return _movementDirectionsForColor(
      piece.color,
      isKingOverride: piece.isKing,
    );
  }

  List<Point<int>> _movementDirectionsForColor(
    PieceColor color, {
    required bool isKingOverride,
  }) {
    final deltas = <Point<int>>[];
    if (isKingOverride || color == PieceColor.red) {
      deltas.add(const Point<int>(-1, -1));
      deltas.add(const Point<int>(-1, 1));
    }
    if (isKingOverride || color == PieceColor.black) {
      deltas.add(const Point<int>(1, -1));
      deltas.add(const Point<int>(1, 1));
    }
    return deltas;
  }

  bool _shouldPromote(PieceColor color, int row) {
    if (color == PieceColor.red) {
      return row == 0;
    }
    return row == BoardUtils.boardSize - 1;
  }

  void _updateWinner() {
    final redPieces = _countPieces(PieceColor.red);
    final blackPieces = _countPieces(PieceColor.black);
    if (redPieces == 0) {
      _winner = PieceColor.black;
      return;
    }
    if (blackPieces == 0) {
      _winner = PieceColor.red;
      return;
    }
    final redMoves = legalMovesFor(PieceColor.red);
    if (redMoves.isEmpty) {
      _winner = PieceColor.black;
      return;
    }
    final blackMoves = legalMovesFor(PieceColor.black);
    if (blackMoves.isEmpty) {
      _winner = PieceColor.red;
      return;
    }
    _winner = null;
  }

  int _countPieces(PieceColor color) {
    var count = 0;
    for (final row in _board) {
      for (final piece in row) {
        if (piece?.color == color) {
          count++;
        }
      }
    }
    return count;
  }

  PieceColor _opponentOf(PieceColor color) {
    return color == PieceColor.red ? PieceColor.black : PieceColor.red;
  }
}
