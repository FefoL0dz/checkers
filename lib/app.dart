import 'package:flutter/material.dart';

import 'presentation/screens/game_screen.dart';
import 'presentation/screens/main_menu_screen.dart';
import 'presentation/screens/settings_screen.dart';

class CheckersApp extends StatelessWidget {
  const CheckersApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Checkers',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFB71C1C)),
        useMaterial3: true,
      ),
      initialRoute: MainMenuScreen.routeName,
      routes: {
        MainMenuScreen.routeName: (context) => const MainMenuScreen(),
        SettingsScreen.routeName: (context) => const SettingsScreen(),
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
