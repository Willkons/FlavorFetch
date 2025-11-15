import 'package:flutter/material.dart';
import '../presentation/screens/home/home_screen.dart';

/// App routing configuration
class AppRoutes {
  AppRoutes._();

  static const String home = '/';
  static const String petList = '/pets';
  static const String petDetail = '/pets/:id';
  static const String scanner = '/scanner';
  static const String feedingLog = '/feeding-log';
  static const String analytics = '/analytics';

  /// Generate routes for the app
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        );
      // TODO: Add other routes as screens are implemented
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(
              title: const Text('Not Found'),
            ),
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
