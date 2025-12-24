import 'package:flutter/material.dart';

import '../../settings/settings_models.dart';
import '../../settings/settings_scope.dart';

class PieceThemeScreen extends StatelessWidget {
  const PieceThemeScreen({super.key});

  static const String routeName = '/settings/piece-theme';

  @override
  Widget build(BuildContext context) {
    final settings = SettingsScope.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Piece theme')),
      body: AnimatedBuilder(
        animation: settings,
        builder: (context, _) {
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const Text('Pick a palette for the pieces and king accents.'),
              const SizedBox(height: 16),
              for (final option in PieceThemeOption.values)
                _PieceThemeTile(
                  option: option,
                  selected: settings.pieceTheme,
                  onSelected: settings.updatePieceTheme,
                ),
            ],
          );
        },
      ),
    );
  }
}

class _PieceThemeTile extends StatelessWidget {
  const _PieceThemeTile({
    required this.option,
    required this.selected,
    required this.onSelected,
  });

  final PieceThemeOption option;
  final PieceThemeOption selected;
  final ValueChanged<PieceThemeOption> onSelected;

  @override
  Widget build(BuildContext context) {
    final data = option.data;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: RadioListTile<PieceThemeOption>(
        value: option,
        groupValue: selected,
        onChanged: (value) {
          if (value != null) {
            onSelected(value);
          }
        },
        title: Text(data.label),
        secondary: _PiecePreview(data: data),
      ),
    );
  }
}

class _PiecePreview extends StatelessWidget {
  const _PiecePreview({required this.data});

  final PieceThemeData data;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 56,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _PieceDot(color: data.redColor, accent: data.kingAccent),
          _PieceDot(color: data.blackColor, accent: data.kingAccent),
        ],
      ),
    );
  }
}

class _PieceDot extends StatelessWidget {
  const _PieceDot({required this.color, required this.accent});

  final Color color;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: accent, width: 2),
      ),
    );
  }
}
