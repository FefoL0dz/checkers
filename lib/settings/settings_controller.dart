import 'package:flutter/foundation.dart';

import 'settings_models.dart';

class SettingsController extends ChangeNotifier {
  BoardThemeOption _boardTheme = BoardThemeOption.classic;
  PieceThemeOption _pieceTheme = PieceThemeOption.classic;
  bool _soundEnabled = false;

  BoardThemeOption get boardTheme => _boardTheme;
  PieceThemeOption get pieceTheme => _pieceTheme;
  bool get soundEnabled => _soundEnabled;

  BoardThemeData get boardThemeData => _boardTheme.data;
  PieceThemeData get pieceThemeData => _pieceTheme.data;

  void updateBoardTheme(BoardThemeOption option) {
    if (_boardTheme == option) {
      return;
    }
    _boardTheme = option;
    notifyListeners();
  }

  void updatePieceTheme(PieceThemeOption option) {
    if (_pieceTheme == option) {
      return;
    }
    _pieceTheme = option;
    notifyListeners();
  }

  void setSoundEnabled(bool enabled) {
    if (_soundEnabled == enabled) {
      return;
    }
    _soundEnabled = enabled;
    notifyListeners();
  }
}
