import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/app_theme.dart';
import 'router/app_router.dart';

final appRouterProvider = Provider<AppRouter>((ref) => AppRouter());

class CheckersApp extends ConsumerWidget {
  const CheckersApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appRouter = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Checkers',
      theme: AppTheme.light,
      routerConfig: appRouter.config(),
    );
  }
}
