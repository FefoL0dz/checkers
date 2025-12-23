import 'package:flutter/material.dart';

import '../../settings/settings_models.dart';
import '../../settings/settings_scope.dart';

class BoardThemeScreen extends StatelessWidget {
  const BoardThemeScreen({super.key});

  static const String routeName = '/settings/board-theme';

  @override
  Widget build(BuildContext context) {
    final settings = SettingsScope.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Board theme')),
      body: AnimatedBuilder(
        animation: settings,
        builder: (context, _) {
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const Text(
                'Choose the board style that feels best for your eyes.',
              ),
              const SizedBox(height: 16),
              for (final option in BoardThemeOption.values)
                _BoardThemeTile(
                  option: option,
                  selected: settings.boardTheme,
                  onSelected: settings.updateBoardTheme,
                ),
            ],
          );
        },
      ),
    );
  }
}

class _BoardThemeTile extends StatelessWidget {
  const _BoardThemeTile({
    required this.option,
    required this.selected,
    required this.onSelected,
  });

  final BoardThemeOption option;
  final BoardThemeOption selected;
  final ValueChanged<BoardThemeOption> onSelected;

  @override
  Widget build(BuildContext context) {
    final data = option.data;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: RadioListTile<BoardThemeOption>(
        value: option,
        groupValue: selected,
        onChanged: (value) {
          if (value != null) {
            onSelected(value);
          }
        },
        title: Text(data.label),
        secondary: _BoardPreview(data: data),
      ),
    );
  }
}

class _BoardPreview extends StatelessWidget {
  const _BoardPreview({required this.data});

  final BoardThemeData data;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 48,
      child: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Container(color: data.lightSquare),
          Container(color: data.darkSquare),
          Container(color: data.darkSquare),
          Container(color: data.lightSquare),
        ],
      ),
    );
  }
}
