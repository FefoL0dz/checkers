import 'package:auto_route/auto_route.dart';

import '../../features/home/presentation/pages/home_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends _$AppRouter {
  @override
  final List<AutoRoute> routes = [
    AutoRoute(page: HomeRoute.page, path: '/'),
  ];
}
