import '../entities/pet.dart';

/// Repository interface for pet data operations.
///
/// This interface defines the contract for pet data access,
/// allowing for different implementations (e.g., SQLite, remote API).
abstract class PetRepository {
  /// Retrieves all pets from the data source.
  ///
  /// Returns a list of all pets, ordered alphabetically by name.
  /// Returns an empty list if no pets exist.
  Future<List<Pet>> getAllPets();

  /// Retrieves a specific pet by ID.
  ///
  /// Returns the pet if found, null otherwise.
  /// Throws an exception if there's a database error.
  Future<Pet?> getPetById(String id);

  /// Creates a new pet in the data source.
  ///
  /// Returns the created pet.
  /// Throws an exception if creation fails.
  Future<Pet> createPet(Pet pet);

  /// Updates an existing pet in the data source.
  ///
  /// Returns the updated pet.
  /// Throws an exception if the pet doesn't exist or update fails.
  Future<Pet> updatePet(Pet pet);

  /// Deletes a pet from the data source.
  ///
  /// Also deletes all associated feeding logs (cascade delete).
  /// Throws an exception if deletion fails.
  Future<void> deletePet(String id);

  /// Returns the total count of pets in the data source.
  ///
  /// Useful for empty state checks and statistics.
  Future<int> getPetCount();
}
