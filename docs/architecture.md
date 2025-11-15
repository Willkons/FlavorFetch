# FlavorFetch Architecture

## Overview

FlavorFetch follows a **layered architecture** pattern that separates concerns and promotes maintainability, testability, and scalability. The architecture is designed to be clean, modular, and easy to understand.

## Architecture Layers

### 1. Presentation Layer (`lib/presentation/`)

**Responsibility:** User interface and user interaction

**Components:**
- **Screens:** Full-page views (e.g., PetListScreen, ScannerScreen)
- **Widgets:** Reusable UI components (e.g., PetCard, RatingWidget)
- **Providers:** State management using Provider/Riverpod

**Rules:**
- No direct database or API calls
- Only contains UI logic
- Communicates with domain layer through repositories
- Handles user input and displays data

**Example:**
```dart
// presentation/screens/pet_list/pet_list_screen.dart
class PetListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final pets = context.watch<PetProvider>().pets;
    return ListView.builder(
      itemCount: pets.length,
      itemBuilder: (context, index) => PetCard(pet: pets[index]),
    );
  }
}
```

### 2. Domain Layer (`lib/domain/`)

**Responsibility:** Business logic and rules

**Components:**
- **Entities:** Pure business objects (e.g., Pet, Product, FeedingLog)
- **Repository Interfaces:** Contracts for data access (e.g., PetRepository)
- **Use Cases:** Complex business operations (if needed)

**Rules:**
- No dependencies on presentation or data layers
- Contains pure business logic
- Defines interfaces that data layer implements
- Framework-independent

**Example:**
```dart
// domain/entities/pet.dart
class Pet {
  final int? id;
  final String name;
  final String type;
  final String? breed;
  final DateTime? birthDate;
  final String? photoPath;

  Pet({
    this.id,
    required this.name,
    required this.type,
    this.breed,
    this.birthDate,
    this.photoPath,
  });
}

// domain/repositories/pet_repository.dart
abstract class PetRepository {
  Future<List<Pet>> getAllPets();
  Future<Pet?> getPetById(int id);
  Future<int> insertPet(Pet pet);
  Future<void> updatePet(Pet pet);
  Future<void> deletePet(int id);
}
```

### 3. Data Layer (`lib/data/`)

**Responsibility:** Data access and management

**Components:**
- **Models:** Data transfer objects with serialization (e.g., PetModel)
- **Repository Implementations:** Concrete implementations of domain interfaces
- **Services:** Database, API, and storage services

**Rules:**
- Implements domain repository interfaces
- Handles data transformation (Entity ↔ Model)
- Manages data sources (SQLite, API, cache)
- Contains serialization/deserialization logic

**Example:**
```dart
// data/models/pet_model.dart
class PetModel {
  final int? id;
  final String name;
  final String type;
  final String? breed;
  final String? birthDate;
  final String? photoPath;

  PetModel({...});

  Map<String, dynamic> toJson() => {...};
  factory PetModel.fromJson(Map<String, dynamic> json) => PetModel(...);

  Pet toEntity() => Pet(...);
  factory PetModel.fromEntity(Pet pet) => PetModel(...);
}

// data/repositories/pet_repository_impl.dart
class PetRepositoryImpl implements PetRepository {
  final DatabaseService _database;

  PetRepositoryImpl(this._database);

  @override
  Future<List<Pet>> getAllPets() async {
    final results = await _database.query('pets');
    return results.map((json) => PetModel.fromJson(json).toEntity()).toList();
  }

  // ... other methods
}
```

### 4. Core Layer (`lib/core/`)

**Responsibility:** Shared utilities and configurations

**Components:**
- **Constants:** App-wide constants
- **Theme:** UI theme configuration
- **Utils:** Helper functions and utilities
- **Extensions:** Dart extensions for common operations

**Rules:**
- Used by all other layers
- No business logic
- Pure utility functions
- Immutable where possible

### 5. Config Layer (`lib/config/`)

**Responsibility:** App configuration

**Components:**
- **Routes:** Navigation configuration
- **Environment:** Environment-specific settings (if needed)

## Data Flow

### Read Operation Flow

```
User Action → Screen → Provider → Repository Interface → Repository Implementation → Database/API
                                                                                           ↓
User Sees Data ← Screen ← Provider ← Entity ← Model Conversion ← Raw Data ←──────────────┘
```

### Write Operation Flow

```
User Input → Screen → Provider → Repository Interface → Repository Implementation → Database/API
                                                                                          ↓
UI Updates ← Screen ← Provider ← Success/Error ←────────────────────────────────────────┘
```

## State Management

### Provider Pattern

We use the **Provider** package (with possible migration to Riverpod) for state management:

```dart
// presentation/providers/pet_provider.dart
class PetProvider extends ChangeNotifier {
  final PetRepository _repository;
  List<Pet> _pets = [];
  bool _isLoading = false;
  String? _error;

  List<Pet> get pets => _pets;
  bool get isLoading => _isLoading;
  String? get error => _error;

  PetProvider(this._repository);

  Future<void> loadPets() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _pets = await _repository.getAllPets();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
```

### State Management Principles

1. **Single Source of Truth:** Each piece of data has one authoritative source
2. **Immutability:** State objects are immutable where possible
3. **Reactive Updates:** UI automatically updates when state changes
4. **Loading States:** Always handle loading, success, and error states
5. **Error Handling:** Graceful error handling with user feedback

## Database Architecture

### SQLite Schema

**Pets Table:**
```sql
CREATE TABLE pets (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  type TEXT NOT NULL,
  breed TEXT,
  birth_date TEXT,
  photo_path TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
);
```

**Products Table:**
```sql
CREATE TABLE products (
  barcode TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  brand TEXT,
  ingredients TEXT,
  category TEXT,
  nutrition_facts TEXT,
  cached_at TEXT NOT NULL
);
```

**Feeding Logs Table:**
```sql
CREATE TABLE feeding_logs (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  pet_id INTEGER NOT NULL,
  product_barcode TEXT NOT NULL,
  rating TEXT NOT NULL,
  timestamp TEXT NOT NULL,
  notes TEXT,
  FOREIGN KEY (pet_id) REFERENCES pets (id) ON DELETE CASCADE,
  FOREIGN KEY (product_barcode) REFERENCES products (barcode)
);

CREATE INDEX idx_feeding_logs_pet_id ON feeding_logs(pet_id);
CREATE INDEX idx_feeding_logs_product ON feeding_logs(product_barcode);
CREATE INDEX idx_feeding_logs_date ON feeding_logs(timestamp);
```

### Database Service

```dart
// data/services/database_service.dart
class DatabaseService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = await getDatabasePath();
    return await openDatabase(
      path,
      version: AppConstants.databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create tables
  }
}
```

## API Integration

### Open Food Facts API

**Base URL:** `https://world.openfoodfacts.org/api/v2`

**Endpoints:**
- Get product: `GET /product/{barcode}`
- Search products: `GET /search?search_terms={query}&categories=pet-food`

### Offline-First Strategy

1. **Check local cache** first
2. If not found or stale, **fetch from API**
3. **Cache the result** in SQLite
4. **Return data** to UI

```dart
// data/repositories/product_repository_impl.dart
Future<Product?> getProductByBarcode(String barcode) async {
  // Check cache first
  final cached = await _database.getProduct(barcode);
  if (cached != null && !_isStale(cached.cachedAt)) {
    return cached.toEntity();
  }

  // Fetch from API
  try {
    final product = await _apiService.getProduct(barcode);
    await _database.cacheProduct(product);
    return product.toEntity();
  } catch (e) {
    // Return cached data if API fails
    return cached?.toEntity();
  }
}
```

## Navigation

### Route Configuration

```dart
// config/routes.dart
class AppRoutes {
  static const String home = '/';
  static const String petList = '/pets';
  static const String petDetail = '/pets/:id';
  static const String scanner = '/scanner';
  static const String feedingLog = '/feeding-log';
  static const String analytics = '/analytics';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Route generation logic
  }
}
```

## Testing Strategy

### Unit Tests

- Test domain entities
- Test repository implementations with mocked dependencies
- Test services in isolation
- Test utility functions

### Widget Tests

- Test individual widgets
- Test screen layouts
- Test user interactions
- Test state changes

### Integration Tests

- Test complete user flows
- Test database operations
- Test API integration
- Test navigation

## Best Practices

### 1. Dependency Injection

Use constructor injection for dependencies:
```dart
class PetRepositoryImpl implements PetRepository {
  final DatabaseService _database;

  PetRepositoryImpl(this._database); // Injected dependency
}
```

### 2. Error Handling

Always handle errors gracefully:
```dart
try {
  await repository.savePet(pet);
} on DatabaseException catch (e) {
  // Handle database error
} on Exception catch (e) {
  // Handle general error
}
```

### 3. Immutability

Prefer immutable objects:
```dart
class Pet {
  final String name;
  Pet({required this.name});

  Pet copyWith({String? name}) => Pet(name: name ?? this.name);
}
```

### 4. Single Responsibility

Each class should have one responsibility:
- ✅ `PetRepository` - Handle pet data operations
- ❌ `PetManager` - Handle pets, products, and analytics

### 5. Interface Segregation

Keep interfaces focused:
```dart
abstract class PetRepository {
  Future<List<Pet>> getAllPets();
  Future<Pet?> getPetById(int id);
  Future<int> insertPet(Pet pet);
}

abstract class PetPhotoRepository {
  Future<String> savePetPhoto(File photo);
  Future<void> deletePetPhoto(String path);
}
```

## Performance Considerations

1. **Lazy Loading:** Load data on demand
2. **Pagination:** Limit query results for large datasets
3. **Indexing:** Use database indexes for frequently queried columns
4. **Caching:** Cache API responses and computed values
5. **Image Optimization:** Compress images before storage

## Security Considerations

1. **Input Validation:** Validate all user inputs
2. **SQL Injection:** Use parameterized queries
3. **File Storage:** Store files in app-specific directories
4. **Data Privacy:** No sensitive data leaves the device (local-first)

## Future Enhancements

1. **Riverpod Migration:** Consider migrating from Provider to Riverpod
2. **Freezed Models:** Use freezed package for immutable models
3. **Code Generation:** Use build_runner for JSON serialization
4. **Cloud Sync:** Add optional cloud backup (Dropbox/Google Drive)
5. **Multi-Platform:** Expand to web and desktop

---

**Last Updated:** November 15, 2025
