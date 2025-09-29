import 'dart:math';

/// Represents a single move in a checkers match. The move may span multiple
/// jumps if the [capturedPieces] list contains more than one entry.
class Move {
  Move({
    required this.fromRow,
    required this.fromCol,
    required this.toRow,
    required this.toCol,
    List<Point<int>>? capturedPieces,
    this.promotesToKing = false,
  }) : capturedPieces = List.unmodifiable(capturedPieces ?? const []);

  /// Row from which the piece originated.
  final int fromRow;

  /// Column from which the piece originated.
  final int fromCol;

  /// Destination row.
  final int toRow;

  /// Destination column.
  final int toCol;

  /// Coordinates of all opponent pieces captured during the move.
  final List<Point<int>> capturedPieces;

  /// Whether the move results in the piece being promoted to a king.
  final bool promotesToKing;

  /// Returns `true` if the move captures at least one opponent piece.
  bool get isCapture => capturedPieces.isNotEmpty;

  /// A descriptive string for debugging and logs.
  String describe() {
    final buffer = StringBuffer('($fromRow,$fromCol) -> ($toRow,$toCol)');
    if (capturedPieces.isNotEmpty) {
      buffer.write(' capturing ${capturedPieces.length}');
    }
    if (promotesToKing) {
      buffer.write(' [promotes]');
    }
    return buffer.toString();
  }

  @override
  String toString() => describe();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Move) return false;
    if (other.fromRow != fromRow ||
        other.fromCol != fromCol ||
        other.toRow != toRow ||
        other.toCol != toCol ||
        other.promotesToKing != promotesToKing ||
        other.capturedPieces.length != capturedPieces.length) {
      return false;
    }
    for (var i = 0; i < capturedPieces.length; i++) {
      if (capturedPieces[i] != other.capturedPieces[i]) {
        return false;
      }
    }
    return true;
  }

  @override
  int get hashCode => Object.hashAll(<Object?>[
        fromRow,
        fromCol,
        toRow,
        toCol,
        promotesToKing,
        ...capturedPieces,
      ]);
}
