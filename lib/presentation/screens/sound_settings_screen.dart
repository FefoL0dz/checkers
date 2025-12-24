import 'package:flutter/material.dart';

import '../../settings/settings_scope.dart';

class SoundSettingsScreen extends StatelessWidget {
  const SoundSettingsScreen({super.key});

  static const String routeName = '/settings/sound';

  @override
  Widget build(BuildContext context) {
    final settings = SettingsScope.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Sound')),
      body: AnimatedBuilder(
        animation: settings,
        builder: (context, _) {
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const Text('Toggle sound effects for moves and captures.'),
              const SizedBox(height: 12),
              SwitchListTile(
                value: settings.soundEnabled,
                title: const Text('Sound effects'),
                subtitle: Text(
                  settings.soundEnabled
                      ? 'Enabled (effects will play when available)'
                      : 'Disabled',
                ),
                onChanged: settings.setSoundEnabled,
              ),
            ],
          );
        },
      ),
    );
  }
}
