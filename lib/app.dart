import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/routes.dart';
import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'domain/repositories/product_repository.dart';
import 'presentation/providers/product_provider.dart';

/// Main application widget
class FlavorFetchApp extends StatelessWidget {
  final ProductRepository productRepository;

  const FlavorFetchApp({super.key, required this.productRepository});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProductProvider(productRepository),
        ),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        onGenerateRoute: AppRoutes.generateRoute,
        initialRoute: AppRoutes.home,
      ),
    );
  }
}
