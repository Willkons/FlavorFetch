# Sprint 1: Pet Management CRUD

**Duration:** Weeks 2-3
**Status:** Not Started
**Dependencies:** Sprint 0 (Project Setup)

## Overview

Sprint 1 implements the core pet management functionality, allowing users to create, read, update, and delete pet profiles. This is the foundational feature of FlavorFetch, as all other features depend on having pets registered in the system.

## Goals

1. Implement Pet entity and data model with SQLite persistence
2. Create pet repository with CRUD operations
3. Build pet list screen with grid/list view
4. Implement add/edit pet form with photo capture
5. Add pet detail view
6. Implement state management for pet operations
7. Write comprehensive tests for pet management

## User Stories

### US-1.1: View Pet List
**As a** pet owner
**I want** to see a list of all my registered pets
**So that** I can select a pet to track their food preferences

**Acceptance Criteria:**
- Pet list screen displays all pets from database
- Each pet card shows photo (or placeholder), name, and pet type icon
- Empty state displayed when no pets exist with "Add Your First Pet" message
- Loading state shown while fetching pets from database
- Pull-to-refresh functionality available
- List supports both grid and list view (user preference saved)
- Pets ordered alphabetically by name
- Navigation to pet detail when card is tapped

**Priority:** P0 (Critical)

### US-1.2: Add New Pet
**As a** pet owner
**I want** to add a new pet profile
**So that** I can start tracking their food preferences

**Acceptance Criteria:**
- Floating action button (FAB) on pet list screen opens add pet form
- Form includes fields:
  - Name (required, max 50 characters)
  - Pet type (required, dropdown: Dog, Cat, Other)
  - Breed (optional, text field, max 50 characters)
  - Birth date (optional, date picker)
  - Photo (optional, camera or gallery)
- Form validation shows error messages for invalid input
- Save button disabled until required fields valid
- Photo compressed to max 1MB before saving
- Photo stored in app documents directory
- Success message shown after pet created
- User returned to pet list with new pet visible
- Cancel button discards changes with confirmation dialog if form modified

**Priority:** P0 (Critical)

### US-1.3: View Pet Details
**As a** pet owner
**I want** to view detailed information about a pet
**So that** I can see their profile and feeding history summary

**Acceptance Criteria:**
- Pet detail screen shows:
  - Large pet photo (or placeholder)
  - Pet name as title
  - Pet type with icon
  - Breed (if provided)
  - Age calculated from birth date (if provided)
  - Number of feeding sessions logged
  - Quick stats: favorite foods, most recent feeding
- Edit button in app bar opens edit form
- Delete button in menu with confirmation dialog
- Back button returns to pet list
- Loading state while fetching pet details
- Error state if pet not found (with back navigation)

**Priority:** P0 (Critical)

### US-1.4: Edit Pet Profile
**As a** pet owner
**I want** to edit a pet's profile information
**So that** I can keep their information up to date

**Acceptance Criteria:**
- Edit form pre-populated with existing pet data
- All fields from add form available for editing
- Photo can be changed or removed
- Old photo file deleted when new photo uploaded
- Save button updates pet in database
- Validation same as add pet form
- Success message shown after update
- User returned to pet detail screen with updated info
- Cancel button discards changes with confirmation dialog if modified

**Priority:** P1 (High)

### US-1.5: Delete Pet
**As a** pet owner
**I want** to delete a pet profile
**So that** I can remove pets I no longer need to track

**Acceptance Criteria:**
- Delete option available from pet detail menu
- Confirmation dialog explains:
  - Pet will be permanently deleted
  - All feeding logs for this pet will be deleted
  - This action cannot be undone
- User must type pet name or confirm checkbox to enable delete
- After confirmation, pet and associated data deleted
- Success message shown
- User returned to pet list
- Pet photo file deleted from storage
- Cancel option available at all steps

**Priority:** P1 (High)

### US-1.6: Photo Management
**As a** pet owner
**I want** to add photos to pet profiles using camera or gallery
**So that** I can easily identify my pets visually

**Acceptance Criteria:**
- Photo button shows options: Camera, Gallery, Remove (if photo exists)
- Camera permission requested when needed
- Gallery permission requested when needed
- Photo preview shown after selection
- Photo cropped to square aspect ratio
- Photo compressed to max 1MB and 800x800px
- Placeholder image shown when no photo set
- Old photo file deleted when replaced
- Photo file deleted when pet deleted
- Photos stored in app documents directory with UUID filename

**Priority:** P1 (High)

## Technical Specifications

### Data Layer

#### Pet Entity

**File:** `lib/domain/entities/pet.dart`

```dart
class Pet {
  final String id;
  final String name;
  final PetType type;
  final String? breed;
  final DateTime? birthDate;
  final String? photoPath;
  final DateTime createdAt;
  final DateTime updatedAt;

  Pet({
    required this.id,
    required this.name,
    required this.type,
    this.breed,
    this.birthDate,
    this.photoPath,
    required this.createdAt,
    required this.updatedAt,
  });

  int? get ageInMonths {
    if (birthDate == null) return null;
    final now = DateTime.now();
    return (now.year - birthDate!.year) * 12 + now.month - birthDate!.month;
  }

  String get ageDisplayString {
    final months = ageInMonths;
    if (months == null) return 'Age unknown';
    if (months < 12) return '$months ${months == 1 ? 'month' : 'months'}';
    final years = months ~/ 12;
    return '$years ${years == 1 ? 'year' : 'years'}';
  }
}

enum PetType {
  dog,
  cat,
  other;

  String get displayName => switch (this) {
    PetType.dog => 'Dog',
    PetType.cat => 'Cat',
    PetType.other => 'Other',
  };
}
```

#### Pet Model

**File:** `lib/data/models/pet_model.dart`

```dart
import '../../domain/entities/pet.dart';

class PetModel {
  final String id;
  final String name;
  final String type;
  final String? breed;
  final DateTime? birthDate;
  final String? photoPath;
  final DateTime createdAt;
  final DateTime updatedAt;

  PetModel({
    required this.id,
    required this.name,
    required this.type,
    this.breed,
    this.birthDate,
    this.photoPath,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PetModel.fromJson(Map<String, dynamic> json) {
    return PetModel(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      breed: json['breed'] as String?,
      birthDate: json['birth_date'] != null
          ? DateTime.parse(json['birth_date'] as String)
          : null,
      photoPath: json['photo_path'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'breed': breed,
      'birth_date': birthDate?.toIso8601String(),
      'photo_path': photoPath,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Pet toEntity() {
    return Pet(
      id: id,
      name: name,
      type: PetType.values.firstWhere((e) => e.name == type),
      breed: breed,
      birthDate: birthDate,
      photoPath: photoPath,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory PetModel.fromEntity(Pet pet) {
    return PetModel(
      id: pet.id,
      name: pet.name,
      type: pet.type.name,
      breed: pet.breed,
      birthDate: pet.birthDate,
      photoPath: pet.photoPath,
      createdAt: pet.createdAt,
      updatedAt: pet.updatedAt,
    );
  }
}
```

#### Database Service

**File:** `lib/data/services/database_service.dart`

```dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static Database? _database;
  static const String _dbName = 'flavor_fetch.db';
  static const int _dbVersion = 1;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE pets (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        type TEXT NOT NULL,
        breed TEXT,
        birth_date TEXT,
        photo_path TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // Create index for common queries
    await db.execute('CREATE INDEX idx_pets_name ON pets(name)');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle future migrations
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}
```

#### Pet Repository Interface

**File:** `lib/domain/repositories/pet_repository.dart`

```dart
import '../entities/pet.dart';

abstract class PetRepository {
  Future<List<Pet>> getAllPets();
  Future<Pet?> getPetById(String id);
  Future<Pet> createPet(Pet pet);
  Future<Pet> updatePet(Pet pet);
  Future<void> deletePet(String id);
  Future<int> getPetCount();
}
```

#### Pet Repository Implementation

**File:** `lib/data/repositories/pet_repository_impl.dart`

```dart
import '../../domain/entities/pet.dart';
import '../../domain/repositories/pet_repository.dart';
import '../models/pet_model.dart';
import '../services/database_service.dart';

class PetRepositoryImpl implements PetRepository {
  final DatabaseService _databaseService;

  PetRepositoryImpl(this._databaseService);

  @override
  Future<List<Pet>> getAllPets() async {
    final db = await _databaseService.database;
    final maps = await db.query(
      'pets',
      orderBy: 'name ASC',
    );

    return maps.map((map) => PetModel.fromJson(map).toEntity()).toList();
  }

  @override
  Future<Pet?> getPetById(String id) async {
    final db = await _databaseService.database;
    final maps = await db.query(
      'pets',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isEmpty) return null;
    return PetModel.fromJson(maps.first).toEntity();
  }

  @override
  Future<Pet> createPet(Pet pet) async {
    final db = await _databaseService.database;
    final model = PetModel.fromEntity(pet);

    await db.insert(
      'pets',
      model.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return pet;
  }

  @override
  Future<Pet> updatePet(Pet pet) async {
    final db = await _databaseService.database;
    final model = PetModel.fromEntity(pet);

    await db.update(
      'pets',
      model.toJson(),
      where: 'id = ?',
      whereArgs: [pet.id],
    );

    return pet;
  }

  @override
  Future<void> deletePet(String id) async {
    final db = await _databaseService.database;

    await db.delete(
      'pets',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<int> getPetCount() async {
    final db = await _databaseService.database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM pets');
    return Sqflite.firstIntValue(result) ?? 0;
  }
}
```

### Presentation Layer

#### Pet Provider

**File:** `lib/presentation/providers/pet_provider.dart`

```dart
import 'package:flutter/foundation.dart';
import '../../domain/entities/pet.dart';
import '../../domain/repositories/pet_repository.dart';

class PetProvider extends ChangeNotifier {
  final PetRepository _repository;

  List<Pet> _pets = [];
  Pet? _selectedPet;
  bool _isLoading = false;
  String? _error;

  PetProvider(this._repository);

  List<Pet> get pets => _pets;
  Pet? get selectedPet => _selectedPet;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasPets => _pets.isNotEmpty;

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

  Future<bool> createPet(Pet pet) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _repository.createPet(pet);
      await loadPets();
      return true;
    } catch (e) {
      _error = 'Failed to create pet: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> updatePet(Pet pet) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _repository.updatePet(pet);
      await loadPets();
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

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
```

#### Pet List Screen

**File:** `lib/presentation/screens/pet_list/pet_list_screen.dart`

**Key Components:**
- App bar with title and view toggle (grid/list)
- Loading state with shimmer effect
- Empty state with illustration and "Add Your First Pet" button
- Pet grid/list view with cards
- Floating action button to add new pet
- Pull-to-refresh functionality
- Navigation to pet detail on card tap

#### Pet Form Screen

**File:** `lib/presentation/screens/pet_form/pet_form_screen.dart`

**Key Components:**
- Form with TextFormField widgets
- Pet type dropdown
- Date picker for birth date
- Photo selection button with preview
- Form validation
- Save and cancel buttons
- Loading indicator during save

#### Pet Detail Screen

**File:** `lib/presentation/screens/pet_detail/pet_detail_screen.dart`

**Key Components:**
- Hero animation for pet photo
- Pet information display
- Edit button in app bar
- Delete option in menu
- Quick stats section (placeholder for feeding data)
- Loading and error states

## Testing Requirements

### Unit Tests

**File:** `test/unit/pet_repository_test.dart`
- Test CRUD operations
- Test query ordering
- Test error handling
- Mock database service

**File:** `test/unit/pet_model_test.dart`
- Test JSON serialization/deserialization
- Test entity conversion
- Test age calculation

**File:** `test/unit/pet_provider_test.dart`
- Test state changes
- Test loading states
- Test error handling
- Mock repository

### Widget Tests

**File:** `test/widget/pet_list_screen_test.dart`
- Test empty state display
- Test pet list rendering
- Test loading state
- Test FAB functionality

**File:** `test/widget/pet_form_screen_test.dart`
- Test form validation
- Test field input
- Test save/cancel buttons
- Test photo selection

**File:** `test/widget/pet_detail_screen_test.dart`
- Test pet information display
- Test edit/delete buttons
- Test navigation

### Integration Tests

**File:** `test/integration/pet_crud_test.dart`
- Test complete CRUD flow
- Test navigation between screens
- Test data persistence

## Definition of Done

- [ ] Pet entity and model implemented with all fields
- [ ] Database schema created with pets table
- [ ] Pet repository interface and implementation complete
- [ ] Pet provider with state management working
- [ ] Pet list screen with grid/list view implemented
- [ ] Add/edit pet form functional with validation
- [ ] Pet detail screen displaying all information
- [ ] Photo capture and storage working
- [ ] Delete pet with confirmation working
- [ ] All unit tests passing with >80% coverage
- [ ] All widget tests passing
- [ ] Integration tests passing
- [ ] Code reviewed and merged to develop branch
- [ ] Documentation updated

## Dependencies and Blockers

**Dependencies:**
- Sprint 0 must be complete
- SQLite database service operational
- Image picker package configured

**Potential Blockers:**
- Camera/gallery permissions on different platforms
- Image compression performance
- SQLite query performance with large datasets

## Notes

- Pet photos should be properly managed (deleted when pet deleted or photo replaced)
- Consider lazy loading for large pet lists in future iterations
- Age calculation should handle edge cases (future dates, very old pets)
- Breed field could be enhanced with suggestions/autocomplete in future
- Consider adding weight tracking in future sprints

## Resources

- [Flutter Form Validation](https://docs.flutter.dev/cookbook/forms/validation)
- [Image Picker Plugin](https://pub.dev/packages/image_picker)
- [SQLite Flutter Guide](https://docs.flutter.dev/cookbook/persistence/sqlite)
- [Provider State Management](https://pub.dev/packages/provider)
