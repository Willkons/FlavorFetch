import 'package:flutter/material.dart';
import '../presentation/screens/pet_list/pet_list_screen.dart';

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
      case petList:
        return MaterialPageRoute(
          builder: (_) => const PetListScreen(),
        );
      // TODO: Add other routes as screens are implemented in future sprints
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
