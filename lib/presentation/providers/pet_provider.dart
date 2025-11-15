import 'package:flutter/foundation.dart';
import '../../domain/entities/pet.dart';
import '../../domain/repositories/pet_repository.dart';

/// Provider for managing pet state and operations.
///
/// This provider handles all pet-related state management,
/// including loading, creating, updating, and deleting pets.
class PetProvider extends ChangeNotifier {
  final PetRepository _repository;

  List<Pet> _pets = [];
  Pet? _selectedPet;
  bool _isLoading = false;
  String? _error;

  PetProvider(this._repository);

  /// List of all pets
  List<Pet> get pets => _pets;

  /// Currently selected pet
  Pet? get selectedPet => _selectedPet;

  /// Whether an operation is in progress
  bool get isLoading => _isLoading;

  /// Current error message, if any
  String? get error => _error;

  /// Whether there are any pets
  bool get hasPets => _pets.isNotEmpty;

  /// Number of pets
  int get petCount => _pets.length;

  /// Loads all pets from the repository.
  Future<void> loadPets() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _pets = await _repository.getAllPets();
    } catch (e) {
      _error = 'Failed to load pets: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Loads a specific pet by ID.
  Future<void> loadPetById(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _selectedPet = await _repository.getPetById(id);
      if (_selectedPet == null) {
        _error = 'Pet not found';
      }
    } catch (e) {
      _error = 'Failed to load pet: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Creates a new pet.
  ///
  /// Returns true if successful, false otherwise.
  /// Updates the error message on failure.
  Future<bool> createPet(Pet pet) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _repository.createPet(pet);
      await loadPets(); // Reload the list
      return true;
    } catch (e) {
      _error = 'Failed to create pet: $e';
      notifyListeners();
      return false;
    }
  }

  /// Updates an existing pet.
  ///
  /// Returns true if successful, false otherwise.
  /// Updates the error message on failure.
  Future<bool> updatePet(Pet pet) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _repository.updatePet(pet);
      await loadPets(); // Reload the list
      if (_selectedPet?.id == pet.id) {
        _selectedPet = pet;
      }
      return true;
    } catch (e) {
      _error = 'Failed to update pet: $e';
      notifyListeners();
      return false;
    }
  }

  /// Deletes a pet by ID.
  ///
  /// Returns true if successful, false otherwise.
  /// Updates the error message on failure.
  Future<bool> deletePet(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _repository.deletePet(id);
      _pets.removeWhere((pet) => pet.id == id);
      if (_selectedPet?.id == id) {
        _selectedPet = null;
      }
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to delete pet: $e';
      notifyListeners();
      return false;
    }
  }

  /// Selects a pet without loading from the repository.
  void selectPet(Pet pet) {
    _selectedPet = pet;
    notifyListeners();
  }

  /// Clears the currently selected pet.
  void clearSelectedPet() {
    _selectedPet = null;
    notifyListeners();
  }

  /// Clears the current error message.
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Refreshes the pet list (same as loadPets but more semantic).
  Future<void> refresh() async {
    await loadPets();
  }
}
