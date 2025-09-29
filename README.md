# Checkers

Starter Flutter project structured with Clean Architecture, Riverpod for
state management, and AutoRoute for declarative navigation. Use this template
as the foundation for building out the Checkers application.

## Getting started

1. Ensure Flutter and Dart are installed.
2. Fetch dependencies:
   ```sh
   flutter pub get
   ```
3. Generate routing code (after editing the router configuration):
   ```sh
   dart run build_runner build --delete-conflicting-outputs
   ```
4. Run the application:
   ```sh
   flutter run
   ```

The project is organized into `core` services, global `app` configuration, and
feature-first modules under `features/` that separate `domain`, `application`,
and `presentation` layers.
