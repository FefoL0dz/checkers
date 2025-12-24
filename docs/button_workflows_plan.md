# Button Workflow Implementation Plan

## Context
The settings tiles on `SettingsScreen` (`lib/presentation/screens/settings_screen.dart`) currently render as static cards without any interaction. This leaves three user-facing buttons effectively unimplemented:

- **Board theme**
- **Piece theme**
- **Sound**

This plan documents the full workflow for each button, including screen flows, UI patterns, SOLID-aligned design, state management strategy, and clean architecture guidance for implementation.

---

## Goals

1. **Provide interactive settings screens** for each unimplemented button.
2. **Apply selections immediately** to the game UI (board colors, piece colors, etc.).
3. **Use maintainable architecture** with clear separation of concerns, adherence to SOLID and clean principles, and scalable state management.
4. **Create a senior-review-ready plan** with precise modules, patterns, and behaviors.

---

## Architecture & Design Principles

### 1) Separation of Concerns (Clean Architecture)
- **Presentation**: Flutter widgets/screens responsible only for rendering and user interaction.
- **Domain/State**: A `SettingsController` exposes current settings and update methods.
- **Models**: `BoardThemeOption` and `PieceThemeOption` enums + data mappings encapsulate theme details.

### 2) SOLID Principles
- **Single Responsibility**: Each screen handles one setting, and the controller only manages settings state.
- **Open/Closed**: Adding new themes or settings should require extending enums/data mappings without modifying existing logic.
- **Liskov Substitution**: Settings access is abstracted behind a notifier; widgets depend on the interface (not the concrete storage).
- **Interface Segregation**: Screens only consume what they need via `SettingsController` getters.
- **Dependency Inversion**: UI depends on an injected `SettingsController` via an `InheritedNotifier` scope.

### 3) State Management Strategy
- Use a **`ChangeNotifier`**-based `SettingsController` shared through the widget tree with `InheritedNotifier` (`SettingsScope`).
- This is lightweight and matches the app’s current complexity without new dependencies.
- The controller is created once at app root and disposed appropriately.

---

## Workflow Use Cases

### A) Board Theme Button

**User story:** As a player, I want to choose a board theme to improve visual comfort or style.

**Screens & Flow:**
1. User taps **Board theme** in `SettingsScreen`.
2. Navigate to `BoardThemeScreen`.
3. Display a list of board themes using `RadioListTile`.
4. Selecting a theme updates the `SettingsController` immediately.
5. The board UI re-renders with the new colors.
6. The `SettingsScreen` subtitle updates to reflect the selection.

**UI Patterns:**
- `RadioListTile` list for mutually exclusive options.
- Optional preview tile: small 2x2 checkerboard sample per theme.

**Data & Logic:**
- `BoardThemeOption` enum (`classic`, `slate`, `emerald`, etc.).
- `BoardThemeOptionX` extension maps to display name + dark/light square colors.

**Error/Edge Cases:**
- None critical; default theme always available.

---

### B) Piece Theme Button

**User story:** As a player, I want to change piece colors for personalization or accessibility.

**Screens & Flow:**
1. User taps **Piece theme** in `SettingsScreen`.
2. Navigate to `PieceThemeScreen`.
3. Display themes using `RadioListTile`.
4. Selecting a theme updates `SettingsController` immediately.
5. Pieces on the board update to new colors; winner badge and count chips match theme.

**UI Patterns:**
- `RadioListTile` list for exclusive options.
- Optional preview chips: two colored circles per theme.

**Data & Logic:**
- `PieceThemeOption` enum with mappings for red/black/king accent colors.

**Error/Edge Cases:**
- Ensure contrast with board light squares to preserve readability.

---

### C) Sound Button

**User story:** As a player, I want to toggle sound effects on/off.

**Screens & Flow:**
1. User taps **Sound** in `SettingsScreen`.
2. Navigate to `SoundSettingsScreen`.
3. Display `SwitchListTile` for sound effects.
4. Toggling updates `SettingsController`.
5. The `SettingsScreen` subtitle updates to On/Off.

**UI Patterns:**
- `SwitchListTile` with descriptive subtitle.

**Data & Logic:**
- Boolean flag `soundEnabled` stored in `SettingsController`.
- Optional future extension: add sound playback when moves/captures occur.

**Edge Cases:**
- Sound is a soft feature; if no audio engine exists, the toggle remains functional as a preference.

---

## Implementation Plan (Step-by-Step)

### 1) Add Settings Models
- Create `lib/settings/settings_models.dart`.
- Define:
  - `enum BoardThemeOption` with names + color data mapping.
  - `enum PieceThemeOption` with names + color data mapping.

### 2) Add Settings Controller + Scope
- Create `lib/settings/settings_controller.dart`:
  - `class SettingsController extends ChangeNotifier`.
  - Holds `boardTheme`, `pieceTheme`, `soundEnabled`.
  - Update methods call `notifyListeners()`.
- Create `lib/settings/settings_scope.dart`:
  - `class SettingsScope extends InheritedNotifier<SettingsController>`.
  - `static SettingsController of(BuildContext context)` to access in widgets.

### 3) Wire Settings into App Root
- Update `lib/app.dart`:
  - Convert `CheckersApp` to `StatefulWidget`.
  - Instantiate `SettingsController` once.
  - Wrap `MaterialApp` with `SettingsScope`.

### 4) Implement Settings Screens
- Update `SettingsScreen` to:
  - Render interactive tiles with `onTap`.
  - Show current values as subtitles.
  - Navigate to new settings screens.
- Add new screens:
  - `BoardThemeScreen`
  - `PieceThemeScreen`
  - `SoundSettingsScreen`

### 5) Apply Settings in UI
- Update `CheckersBoard` to:
  - Pull board/piece colors from `SettingsController`.
  - Repaint when settings change.
- Update `GameScreen` piece count chips to use theme colors.

### 6) Validate UX
- Confirm:
  - Each settings button is interactive.
  - Theme changes update game visuals immediately.
  - Settings list reflects new selections.

---

## Testing Checklist

- Launch app → Settings → each tile navigates correctly.
- Changing board theme updates square colors in active game.
- Changing piece theme updates pieces + piece count chips.
- Toggling sound flips subtitle between On/Off.

---

## Future Enhancements (Optional)

- Persist settings using `SharedPreferences` or a local database.
- Add sound effects (move, capture, king promotion).
- Add accessibility presets (colorblind-safe themes).

---

## Files to Update/Create

- **New**: `lib/settings/settings_models.dart`
- **New**: `lib/settings/settings_controller.dart`
- **New**: `lib/settings/settings_scope.dart`
- **New**: `lib/presentation/screens/board_theme_screen.dart`
- **New**: `lib/presentation/screens/piece_theme_screen.dart`
- **New**: `lib/presentation/screens/sound_settings_screen.dart`
- **Update**: `lib/app.dart`
- **Update**: `lib/presentation/screens/settings_screen.dart`
- **Update**: `lib/presentation/widgets/checkers_board.dart`
- **Update**: `lib/presentation/screens/game_screen.dart`

---

## Review Notes (Senior Engineer Expectations)

- Architecture follows clean principles and is test-friendly.
- State management is minimal yet scalable.
- UI elements are interactive and immediately reflect settings.
- Code structure is modular and avoids duplication.
- All newly created components are named clearly and scoped appropriately.
