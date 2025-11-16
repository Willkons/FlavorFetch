import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'data/services/database_service.dart';
import 'data/services/open_food_facts_service.dart';
import 'data/repositories/product_repository_impl.dart';
import 'presentation/providers/product_provider.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize database service
  final databaseService = DatabaseService();
  await databaseService.database; // Initialize database

  // Initialize API service
  final apiService = OpenFoodFactsService();

  // Initialize repository
  final productRepository = ProductRepositoryImpl(databaseService, apiService);

  runApp(FlavorFetchApp(productRepository: productRepository));
}
