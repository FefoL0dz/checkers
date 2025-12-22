import 'package:flutter/material.dart';

import '../../app.dart';
import 'game_screen.dart';
import 'settings_screen.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  static const String routeName = '/';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Checkers',
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 32),
                FilledButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      GameScreen.routeName,
                      arguments: const GameArguments(vsAi: false),
                    );
                  },
                  child: const Text('Play Local'),
                ),
                const SizedBox(height: 16),
                FilledButton.tonal(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      GameScreen.routeName,
                      arguments: const GameArguments(vsAi: true),
                    );
                  },
                  child: const Text('Play vs AI'),
                ),
                const SizedBox(height: 24),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, SettingsScreen.routeName);
                  },
                  child: const Text('Settings'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
