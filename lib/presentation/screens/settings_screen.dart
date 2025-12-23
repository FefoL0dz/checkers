import 'package:flutter/material.dart';

import '../../settings/settings_scope.dart';
import 'board_theme_screen.dart';
import 'piece_theme_screen.dart';
import 'sound_settings_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const String routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    final settings = SettingsScope.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: AnimatedBuilder(
        animation: settings,
        builder: (context, _) {
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              _SettingsTile(
                title: 'Board theme',
                subtitle: settings.boardThemeData.label,
                onTap: () {
                  Navigator.pushNamed(context, BoardThemeScreen.routeName);
                },
              ),
              _SettingsTile(
                title: 'Piece theme',
                subtitle: settings.pieceThemeData.label,
                onTap: () {
                  Navigator.pushNamed(context, PieceThemeScreen.routeName);
                },
              ),
              _SettingsTile(
                title: 'Sound',
                subtitle: settings.soundEnabled ? 'On' : 'Off',
                onTap: () {
                  Navigator.pushNamed(context, SoundSettingsScreen.routeName);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
