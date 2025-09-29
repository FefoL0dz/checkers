import 'dart:math';

import '../models/piece.dart';

/// Utility helpers for handling board coordinates and initial state.
class BoardUtils {
  const BoardUtils._();

  /// Standard size for a checkers board.
  static const int boardSize = 8;

  /// Returns true if the provided coordinate lies inside the playable area.
  static bool isInsideBoard(int row, int col) {
    return row >= 0 &&
        row < boardSize &&
        col >= 0 &&
        col < boardSize;
  }

  /// Returns true if the board square at [row], [col] is dark.
  /// Pieces can only occupy dark squares on a checkers board.
  static bool isDarkSquare(int row, int col) {
    return (row + col).isOdd;
  }

  /// Creates a new board with pieces positioned in the traditional setup.
  static List<List<Piece?>> initialBoard() {
    final board = List<List<Piece?>>.generate(
      boardSize,
      (row) => List<Piece?>.filled(boardSize, null, growable: false),
      growable: false,
    );
    for (var row = 0; row < 3; row++) {
      for (var col = 0; col < boardSize; col++) {
        if (isDarkSquare(row, col)) {
          board[row][col] = Piece(row: row, col: col, color: PieceColor.black);
        }
      }
    }
    for (var row = boardSize - 3; row < boardSize; row++) {
      for (var col = 0; col < boardSize; col++) {
        if (isDarkSquare(row, col)) {
          board[row][col] = Piece(row: row, col: col, color: PieceColor.red);
        }
      }
    }
    return board;
  }

  /// Deep copies a board state to avoid mutating the original.
  static List<List<Piece?>> cloneBoard(List<List<Piece?>> source) {
    return List<List<Piece?>>.generate(
      boardSize,
      (row) =>
          List<Piece?>.generate(boardSize, (col) => source[row][col], growable: false),
      growable: false,
    );
  }

  /// Helper for building a [Point] from coordinates.
  static Point<int> point(int row, int col) => Point<int>(row, col);
}
