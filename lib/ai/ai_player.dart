import 'dart:math';

import '../game/checkers_game.dart';
import '../models/move.dart';
import '../models/piece.dart';

/// A very small AI capable of selecting a move for a checkers player.
///
/// The strategy is intentionally simple so it can run quickly on device and be
/// understandable. It prioritizes moves that capture the highest number of
/// opponent pieces and falls back to random selection when multiple options are
/// equivalent.
class AiPlayer {
  AiPlayer({Random? random}) : _random = random ?? Random();

  final Random _random;

  /// Chooses the next move for [color] given the [game] state.
  Move? chooseMove(CheckersGame game, PieceColor color) {
    final moves = game.legalMovesFor(color);
    if (moves.isEmpty) {
      return null;
    }
    moves.sort(
      (a, b) => b.capturedPieces.length.compareTo(a.capturedPieces.length),
    );
    final bestCaptureCount = moves.first.capturedPieces.length;
    final bestMoves = moves
        .where((move) => move.capturedPieces.length == bestCaptureCount)
        .toList();
    return bestMoves[_random.nextInt(bestMoves.length)];
  }
}
