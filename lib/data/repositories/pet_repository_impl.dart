import 'package:sqflite/sqflite.dart';
import '../../domain/entities/pet.dart';
import '../../domain/repositories/pet_repository.dart';
import '../models/pet_model.dart';
import '../services/database_service.dart';

/// Implementation of [PetRepository] using SQLite.
///
/// This class handles all database operations for pets,
/// including CRUD operations and queries.
class PetRepositoryImpl implements PetRepository {
  final DatabaseService _databaseService;

  PetRepositoryImpl(this._databaseService);

  @override
  Future<List<Pet>> getAllPets() async {
    try {
      final db = await _databaseService.database;
      final maps = await db.query(
        'pets',
        orderBy: 'name ASC',
      );

      return maps.map((map) => PetModel.fromJson(map).toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to load pets: $e');
    }
  }

  @override
  Future<Pet?> getPetById(String id) async {
    try {
      final db = await _databaseService.database;
      final maps = await db.query(
        'pets',
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );

      if (maps.isEmpty) return null;
      return PetModel.fromJson(maps.first).toEntity();
    } catch (e) {
      throw Exception('Failed to load pet: $e');
    }
  }

  @override
  Future<Pet> createPet(Pet pet) async {
    try {
      final db = await _databaseService.database;
      final model = PetModel.fromEntity(pet);

      await db.insert(
        'pets',
        model.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      return pet;
    } catch (e) {
      throw Exception('Failed to create pet: $e');
    }
  }

  @override
  Future<Pet> updatePet(Pet pet) async {
    try {
      final db = await _databaseService.database;
      final model = PetModel.fromEntity(pet);

      final count = await db.update(
        'pets',
        model.toJson(),
        where: 'id = ?',
        whereArgs: [pet.id],
      );

      if (count == 0) {
        throw Exception('Pet not found');
      }

      return pet;
    } catch (e) {
      throw Exception('Failed to update pet: $e');
    }
  }

  @override
  Future<void> deletePet(String id) async {
    try {
      final db = await _databaseService.database;

      // Delete the pet (cascade delete will handle feeding_logs)
      final count = await db.delete(
        'pets',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (count == 0) {
        throw Exception('Pet not found');
      }
    } catch (e) {
      throw Exception('Failed to delete pet: $e');
    }
  }

  @override
  Future<int> getPetCount() async {
    try {
      final db = await _databaseService.database;
      final result = await db.rawQuery('SELECT COUNT(*) as count FROM pets');
      return Sqflite.firstIntValue(result) ?? 0;
    } catch (e) {
      throw Exception('Failed to get pet count: $e');
    }
  }
}
