import 'package:flutter/material.dart';

enum BoardThemeOption {
  classic,
  slate,
  forest,
}

@immutable
class BoardThemeData {
  const BoardThemeData({
    required this.label,
    required this.darkSquare,
    required this.lightSquare,
  });

  final String label;
  final Color darkSquare;
  final Color lightSquare;
}

extension BoardThemeOptionX on BoardThemeOption {
  BoardThemeData get data {
    switch (this) {
      case BoardThemeOption.classic:
        return const BoardThemeData(
          label: 'Classic walnut',
          darkSquare: Color(0xFF6D4C41),
          lightSquare: Color(0xFFFFF8E1),
        );
      case BoardThemeOption.slate:
        return const BoardThemeData(
          label: 'Slate',
          darkSquare: Color(0xFF455A64),
          lightSquare: Color(0xFFECEFF1),
        );
      case BoardThemeOption.forest:
        return const BoardThemeData(
          label: 'Forest',
          darkSquare: Color(0xFF2E7D32),
          lightSquare: Color(0xFFE8F5E9),
        );
    }
  }
}

enum PieceThemeOption {
  classic,
  dusk,
  sunrise,
}

@immutable
class PieceThemeData {
  const PieceThemeData({
    required this.label,
    required this.redColor,
    required this.blackColor,
    required this.kingAccent,
  });

  final String label;
  final Color redColor;
  final Color blackColor;
  final Color kingAccent;
}

extension PieceThemeOptionX on PieceThemeOption {
  PieceThemeData get data {
    switch (this) {
      case PieceThemeOption.classic:
        return const PieceThemeData(
          label: 'Classic',
          redColor: Color(0xFFB71C1C),
          blackColor: Color(0xFF263238),
          kingAccent: Color(0xFFFFD54F),
        );
      case PieceThemeOption.dusk:
        return const PieceThemeData(
          label: 'Dusk',
          redColor: Color(0xFF6A1B9A),
          blackColor: Color(0xFF37474F),
          kingAccent: Color(0xFFFFF176),
        );
      case PieceThemeOption.sunrise:
        return const PieceThemeData(
          label: 'Sunrise',
          redColor: Color(0xFFF4511E),
          blackColor: Color(0xFF1A237E),
          kingAccent: Color(0xFFFFF59D),
        );
    }
  }
}
