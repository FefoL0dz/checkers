import 'package:flutter/material.dart';

import 'presentation/screens/board_theme_screen.dart';
import 'presentation/screens/game_screen.dart';
import 'presentation/screens/main_menu_screen.dart';
import 'presentation/screens/piece_theme_screen.dart';
import 'presentation/screens/settings_screen.dart';
import 'presentation/screens/sound_settings_screen.dart';
import 'settings/settings_controller.dart';
import 'settings/settings_scope.dart';

class CheckersApp extends StatefulWidget {
  const CheckersApp({super.key});

  @override
  State<CheckersApp> createState() => _CheckersAppState();
}

class _CheckersAppState extends State<CheckersApp> {
  final SettingsController _settingsController = SettingsController();

  @override
  void dispose() {
    _settingsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SettingsScope(
      controller: _settingsController,
      child: MaterialApp(
        title: 'Checkers',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFB71C1C)),
          useMaterial3: true,
        ),
        initialRoute: MainMenuScreen.routeName,
        routes: {
          MainMenuScreen.routeName: (context) => const MainMenuScreen(),
          SettingsScreen.routeName: (context) => const SettingsScreen(),
          BoardThemeScreen.routeName: (context) => const BoardThemeScreen(),
          PieceThemeScreen.routeName: (context) => const PieceThemeScreen(),
          SoundSettingsScreen.routeName: (context) =>
              const SoundSettingsScreen(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == GameScreen.routeName) {
            final args = settings.arguments;
            return MaterialPageRoute(
              builder: (context) => GameScreen(
                args: args is GameArguments ? args : const GameArguments(),
              ),
            );
          }
          return null;
        },
      ),
    );
  }
}

class GameArguments {
  const GameArguments({
    this.vsAi = false,
    this.humanPlaysRed = true,
  });

  final bool vsAi;
  final bool humanPlaysRed;
}
