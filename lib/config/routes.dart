import 'package:flutter/material.dart';
import '../domain/entities/product.dart';
import '../presentation/screens/home/home_screen.dart';
import '../presentation/screens/scanner/scanner_screen.dart';
import '../presentation/screens/product_detail/product_detail_screen.dart';
import '../presentation/screens/product_search/product_search_screen.dart';
import '../presentation/screens/manual_product/manual_product_form_screen.dart';

/// App routing configuration
class AppRoutes {
  AppRoutes._();

  static const String home = '/';
  static const String petList = '/pets';
  static const String petDetail = '/pets/:id';
  static const String scanner = '/scanner';
  static const String productDetail = '/product-detail';
  static const String productSearch = '/product-search';
  static const String manualProduct = '/manual-product';
  static const String feedingLog = '/feeding-log';
  static const String analytics = '/analytics';

  /// Generate routes for the app
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        );
      case scanner:
        return MaterialPageRoute(
          builder: (_) => const ScannerScreen(),
        );
      case productDetail:
        final product = settings.arguments as Product?;
        if (product == null) {
          return _errorRoute('Product data is required');
        }
        return MaterialPageRoute(
          builder: (_) => ProductDetailScreen(product: product),
        );
      case productSearch:
        return MaterialPageRoute(
          builder: (_) => const ProductSearchScreen(),
        );
      case manualProduct:
        return MaterialPageRoute(
          builder: (_) => const ManualProductFormScreen(),
        );
      // TODO: Add pet management routes (Sprint 1)
      // TODO: Add feeding log routes (Sprint 3)
      // TODO: Add analytics routes (Sprint 4)
      default:
        return _errorRoute('No route defined for ${settings.name}');
    }
  }

  /// Generate error route
  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: Center(
          child: Text(message),
        ),
      ),
    );
  }
}
