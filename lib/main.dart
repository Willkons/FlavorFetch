import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'data/services/database_service.dart';
import 'data/repositories/pet_repository_impl.dart';
import 'presentation/providers/pet_provider.dart';

void main() {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services
  final databaseService = DatabaseService();
  final petRepository = PetRepositoryImpl(databaseService);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => PetProvider(petRepository),
        ),
      ],
      child: const FlavorFetchApp(),
    ),
  );
}
