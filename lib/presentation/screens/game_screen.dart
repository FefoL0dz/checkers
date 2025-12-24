import 'dart:math';

import 'package:flutter/material.dart';

import '../../ai/ai_player.dart';
import '../../app.dart';
import '../../game/checkers_game.dart';
import '../../models/move.dart';
import '../../models/piece.dart';
import '../../settings/settings_scope.dart';
import '../widgets/checkers_board.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key, required this.args});

  static const String routeName = '/game';

  final GameArguments args;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late CheckersGame _game;
  final AiPlayer _ai = AiPlayer();
  Piece? _selected;
  List<Move> _legalMoves = const [];

  @override
  void initState() {
    super.initState();
    _game = CheckersGame();
  }

  bool get _isVsAi => widget.args.vsAi;

  bool get _humanPlaysRed => widget.args.humanPlaysRed;

  bool _isHumanTurn() {
    if (!_isVsAi) {
      return true;
    }
    return _game.currentTurn ==
        (_humanPlaysRed ? PieceColor.red : PieceColor.black);
  }

  void _handleSquareTap(int row, int col) {
    if (_game.isGameOver || !_isHumanTurn()) {
      return;
    }
    final tappedPiece = _game.pieceAt(row, col);
    final currentTurn = _game.currentTurn;
    if (tappedPiece != null && tappedPiece.color == currentTurn) {
      setState(() {
        _selected = tappedPiece;
        _legalMoves = _game
            .legalMovesFor(currentTurn)
            .where((move) => move.fromRow == row && move.fromCol == col)
            .toList();
      });
      return;
    }
    if (_selected == null) {
      return;
    }
    final selectedMove = _legalMoves.firstWhere(
      (move) => move.toRow == row && move.toCol == col,
      orElse: () => Move(
        fromRow: -1,
        fromCol: -1,
        toRow: -1,
        toCol: -1,
      ),
    );
    if (selectedMove.fromRow == -1) {
      return;
    }
    final moved = _game.makeMove(selectedMove);
    if (moved) {
      setState(() {
        _selected = null;
        _legalMoves = const [];
      });
      _maybeTriggerAiTurn();
    }
  }

  Future<void> _maybeTriggerAiTurn() async {
    if (!_isVsAi || _game.isGameOver) {
      return;
    }
    if (_isHumanTurn()) {
      return;
    }
    await Future<void>.delayed(const Duration(milliseconds: 350));
    final aiMove = _ai.chooseMove(_game, _game.currentTurn);
    if (aiMove == null) {
      return;
    }
    setState(() {
      _game.makeMove(aiMove);
      _selected = null;
      _legalMoves = const [];
    });
  }

  void _resetGame() {
    setState(() {
      _game.reset();
      _selected = null;
      _legalMoves = const [];
    });
  }

  Set<Point<int>> _highlightTargets() {
    return _legalMoves
        .map((move) => Point<int>(move.toRow, move.toCol))
        .toSet();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settings = SettingsScope.of(context);
    final pieceTheme = settings.pieceThemeData;
    final board = _game.board;
    final remainingRed = _countPieces(board, PieceColor.red);
    final remainingBlack = _countPieces(board, PieceColor.black);
    return Scaffold(
      appBar: AppBar(
        title: Text(_game.isGameOver
            ? 'Game Over'
            : _game.currentTurn == PieceColor.red
                ? 'Red\'s Turn'
                : 'Black\'s Turn'),
        actions: [
          IconButton(
            tooltip: 'Restart',
            onPressed: _resetGame,
            icon: const Icon(Icons.restart_alt),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _PieceCountChip(
                    label: 'Red',
                    count: remainingRed,
                    color: pieceTheme.redColor,
                  ),
                  _PieceCountChip(
                    label: 'Black',
                    count: remainingBlack,
                    color: pieceTheme.blackColor,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: CheckersBoard(
                board: board,
                selected: _selected,
                highlightedTargets: _highlightTargets(),
                onSquareTap: _handleSquareTap,
              ),
            ),
            const SizedBox(height: 16),
            if (_game.isGameOver)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.emoji_events, size: 32),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _game.winner == PieceColor.red
                              ? 'Red wins!'
                              : 'Black wins!',
                          style: theme.textTheme.titleMedium,
                        ),
                      ),
                      FilledButton(
                        onPressed: _resetGame,
                        child: const Text('Play again'),
                      ),
                    ],
                  ),
                ),
              ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Text(
                _isVsAi
                    ? (_isHumanTurn() ? 'Your move' : 'AI is thinking...')
                    : 'Pass-and-play',
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _countPieces(List<List<Piece?>> board, PieceColor color) {
    var count = 0;
    for (final row in board) {
      for (final piece in row) {
        if (piece?.color == color) {
          count++;
        }
      }
    }
    return count;
  }
}

class _PieceCountChip extends StatelessWidget {
  const _PieceCountChip({
    required this.label,
    required this.count,
    required this.color,
  });

  final String label;
  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text('$label: $count'),
      ],
    );
  }
}
