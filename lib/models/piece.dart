import 'package:meta/meta.dart';

/// Represents the color of a checkers piece.
enum PieceColor { red, black }

/// Immutable representation of a checkers piece on the board.
@immutable
class Piece {
  const Piece({
    required this.row,
    required this.col,
    required this.color,
    this.isKing = false,
  });

  /// Current row of the piece (0 based, top to bottom).
  final int row;

  /// Current column of the piece (0 based, left to right).
  final int col;

  /// Color of the piece.
  final PieceColor color;

  /// Whether the piece has been promoted to a king.
  final bool isKing;

  /// Creates a copy of the piece with the provided updates.
  Piece copyWith({int? row, int? col, bool? isKing}) {
    return Piece(
      row: row ?? this.row,
      col: col ?? this.col,
      color: color,
      isKing: isKing ?? this.isKing,
    );
  }

  /// Returns true if the piece belongs to the provided [otherColor].
  bool isSameColor(PieceColor otherColor) => color == otherColor;

  /// Returns true if the piece belongs to the opposing player.
  bool isOpponentOf(Piece other) => color != other.color;

  @override
  String toString() {
    final buffer = StringBuffer(color == PieceColor.red ? 'R' : 'B');
    if (isKing) {
      buffer.write('K');
    }
    buffer.write('($row,$col)');
    return buffer.toString();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Piece &&
        other.row == row &&
        other.col == col &&
        other.color == color &&
        other.isKing == isKing;
  }

  @override
  int get hashCode => Object.hash(row, col, color, isKing);
}
