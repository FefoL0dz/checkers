# Checkers Game Plan (Flutter or Flame)

Below is a concise but complete plan for a Flutter (UI-driven) or Flame (game-loop)
implementation of Checkers, with architecture, design patterns, SOLID principles,
Game Principles being applied, and screen design.

## 1. Project Goals & Scope
- **Core gameplay:** Standard American Checkers rules.
- **Modes:** Local pass-and-play; optional AI (basic minimax).
- **Visuals:** Clean board, clear piece states (king vs man), animated moves.
- **Cross-platform:** Mobile, web, desktop (Flutter target).

## 2. Architecture Overview

### Option A: Flutter-first (UI-driven)
**Best when:** You want a standard Flutter app with minimal game-loop complexity.

- **Presentation:** Flutter widgets.
- **State:** State management (Riverpod / Bloc / Provider).
- **Game logic:** Pure Dart, clean domain layer.

**Layering**
- **Presentation:** `screens/`, `widgets/`
- **Application:** `controllers/`, `usecases/`
- **Domain:** `entities/`, `rules/`, `services/`
- **Data:** `repositories/` (optional for persistence)

### Option B: Flame-based (game-loop)
**Best when:** You want animation, custom render, and game-engine capabilities.

- **Game loop:** Flame’s `Game` or `FlameGame`.
- **Components:** Board, Pieces, UI overlays.
- **State:** Still keep domain logic separate; Flame drives rendering.

**Layering**
- **Game layer:** `game/` with `CheckersGame`, components
- **Domain:** same as above (pure Dart)
- **UI overlays:** Flutter widgets for menus/settings.

## 3. Design Patterns & SOLID

### Design Patterns
- **State pattern:** for turn phases (`SelectingPiece`, `SelectingMove`, `AnimatingMove`).
- **Command pattern:** encapsulate moves (`MoveCommand`), enable undo/redo.
- **Strategy pattern:** AI algorithms (`RandomAI`, `MinimaxAI`).
- **Observer pattern:** UI or Flame components subscribe to game state.
- **Factory method:** create pieces/boards from configuration or saved game.

### SOLID Mapping
- **S:** `MoveValidator`, `CaptureResolver`, `TurnManager` have clear responsibility.
- **O:** Add new rule variants (e.g., flying kings) by extending rule sets.
- **L:** AI players implement `IPlayer`; human player is also `IPlayer`.
- **I:** Separate `IMoveValidator`, `IAIService`, `IGameRenderer`.
- **D:** UI depends on abstractions (`GameController`, `IGameState`).

## 4. Core Domain Model

### Entities
- `Board`: 8×8 grid of `Square`.
- `Piece`: color, type (man/king), position.
- `Move`: from, to, captures (list).
- `GameState`: board, current turn, history.

### Rules & Services
- `MoveGenerator`: generates legal moves.
- `CaptureResolver`: enforces multi-jump captures.
- `KingPromotionService`: promotes on end row.
- `GameEndDetector`: win/lose/stalemate.

## 5. Game Principles Applied

### Core Loop
1. **Input:** Select piece.
2. **Decision:** Validate legal moves.
3. **Action:** Apply move; update state.
4. **Feedback:** Animate move + capture.
5. **Progression:** End turn or continue forced capture.

### Balance
- Strict enforcement of forced captures.
- Clear visual indicators for legal moves.

### Feedback & UX
- Highlight selectable pieces.
- Show possible moves for selected piece.
- Animate captures + promotions.

## 6. Screens & UI Design Plan

### Screen Map
- **Splash / Logo**
- **Main Menu**
  - Play Local
  - Play vs AI
  - Settings
- **Game Screen**
  - Board (center)
  - Turn indicator
  - Move history
  - Restart / Undo / Menu
- **Settings Screen**
  - Board theme
  - Piece theme
  - Sound toggle
- **Game Over Dialog**
  - Winner + reason
  - Play Again / Main Menu

### Layout Notes
- Board centered, use responsive sizing.
- HUD minimal (turn, remaining pieces).
- Animations: slide moves, fade captures, crown promotion.

## 7. State Management Plan

### Flutter-first
- `GameController` in Riverpod/Bloc.
- Immutable `GameState` updates per move.
- UI listens to state; triggers controller actions.

### Flame
- `CheckersGame` retains domain `GameState`.
- Components render based on state.
- Inputs routed to controller.

## 8. File/Folder Structure (Suggested)
```
lib/
  main.dart
  app.dart
  presentation/
    screens/
    widgets/
  game/ (Flame only)
    checkers_game.dart
    components/
  domain/
    entities/
    rules/
    services/
    usecases/
  data/
    repositories/
```

## 9. AI Plan (Optional)
- **Basic:** Random valid move.
- **Intermediate:** Minimax with depth 2–4.
- **Evaluation:** Piece count, king weight, mobility.

## 10. Testing Strategy (Static Focus)

### Unit tests
- Move generation
- Capture logic
- Promotion
- Game end conditions

### Widget tests
- Board rendering
- Tap selection

## 11. Next Steps / Milestones
1. Build domain rules & move generator.
2. Add UI board with selection highlights.
3. Implement forced capture + multi-jump.
4. Add AI.
5. Polish visuals + animations.

## Testing
Not run (read-only QA review).
