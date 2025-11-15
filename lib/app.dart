import 'package:flutter/material.dart';
import 'config/routes.dart';
import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';

/// Main application widget
class FlavorFetchApp extends StatelessWidget {
  const FlavorFetchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      onGenerateRoute: AppRoutes.generateRoute,
      initialRoute: AppRoutes.home,
    );
  }
}
