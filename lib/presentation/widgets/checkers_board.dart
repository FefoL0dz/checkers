import 'dart:math';

import 'package:flutter/material.dart';

import '../../models/piece.dart';
import '../../utils/board_utils.dart';

class CheckersBoard extends StatelessWidget {
  const CheckersBoard({
    super.key,
    required this.board,
    required this.selected,
    required this.highlightedTargets,
    required this.onSquareTap,
  });

  final List<List<Piece?>> board;
  final Piece? selected;
  final Set<Point<int>> highlightedTargets;
  final void Function(int row, int col) onSquareTap;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: GridView.builder(
        itemCount: BoardUtils.boardSize * BoardUtils.boardSize,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: BoardUtils.boardSize,
        ),
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final row = index ~/ BoardUtils.boardSize;
          final col = index % BoardUtils.boardSize;
          final isDark = BoardUtils.isDarkSquare(row, col);
          final piece = board[row][col];
          final isSelected = selected?.row == row && selected?.col == col;
          final isTarget = highlightedTargets.contains(Point<int>(row, col));
          return GestureDetector(
            onTap: () => onSquareTap(row, col),
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF6D4C41) : const Color(0xFFFFF8E1),
                border: Border.all(color: Colors.black12),
              ),
              child: Center(
                child: _PieceView(
                  piece: piece,
                  isSelected: isSelected,
                  isTarget: isTarget,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PieceView extends StatelessWidget {
  const _PieceView({
    required this.piece,
    required this.isSelected,
    required this.isTarget,
  });

  final Piece? piece;
  final bool isSelected;
  final bool isTarget;

  @override
  Widget build(BuildContext context) {
    if (piece == null && !isTarget) {
      return const SizedBox.shrink();
    }
    final highlight = isTarget ? const Color(0xFF00C853) : null;
    if (piece == null && isTarget) {
      return Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          color: highlight,
          shape: BoxShape.circle,
        ),
      );
    }
    final baseColor = piece!.color == PieceColor.red
        ? const Color(0xFFB71C1C)
        : const Color(0xFF263238);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: baseColor,
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? Colors.amberAccent : Colors.black26,
          width: isSelected ? 3 : 1,
        ),
        boxShadow: [
          if (isTarget)
            const BoxShadow(
              color: Color(0xFF00C853),
              blurRadius: 8,
              spreadRadius: 2,
            ),
        ],
      ),
      child: piece!.isKing
          ? const Center(
              child: Icon(
                Icons.workspace_premium,
                color: Colors.amber,
                size: 20,
              ),
            )
          : null,
    );
  }
}
