# Sprint 2: Barcode Scanner & Product Integration

**Duration:** Weeks 4-5
**Status:** Not Started
**Dependencies:** Sprint 1 (Pet Management)

## Overview

Sprint 2 implements barcode scanning functionality and integration with the Open Food Facts API to retrieve pet food product information. This enables users to quickly identify and log pet food products by scanning their barcodes.

## Goals

1. Implement barcode scanner using device camera
2. Integrate Open Food Facts API for product data retrieval
3. Create product entity and data model with caching
4. Build product search and detail screens
5. Implement manual product entry as fallback
6. Add product repository with local caching
7. Handle offline scenarios gracefully

## User Stories

### US-2.1: Scan Barcode
**As a** pet owner
**I want** to scan a pet food product barcode
**So that** I can quickly retrieve product information

**Acceptance Criteria:**
- Scanner screen accessible from main navigation
- Camera preview displays with scanning overlay
- Barcode detection highlights detected codes in real-time
- Supports UPC-A, UPC-E, EAN-8, EAN-13 barcode formats
- Haptic feedback on successful scan
- Auto-navigation to product details after successful scan
- Manual entry button available if scanning fails
- Flash toggle button for low-light conditions
- Permission handling with clear error messages if denied
- Loading indicator shown while fetching product data
- Error message if product not found in API

**Priority:** P0 (Critical)

### US-2.2: View Product Information
**As a** pet owner
**I want** to view detailed information about a scanned product
**So that** I can understand what I'm feeding my pet

**Acceptance Criteria:**
- Product detail screen shows:
  - Product image (from API or placeholder)
  - Product name
  - Brand name
  - Barcode number
  - Ingredients list (if available)
  - Nutrition facts (if available)
  - Product categories
  - "Log Feeding" button to create feeding log entry
- Data fetched from Open Food Facts API
- Loading state while fetching
- Error state if fetch fails with retry option
- Cached products load instantly from local database
- "Report Issue" option if product data incorrect
- Share button to share product information

**Priority:** P0 (Critical)

### US-2.3: Search Products
**As a** pet owner
**I want** to search for products by name or brand
**So that** I can find products without scanning a barcode

**Acceptance Criteria:**
- Search screen accessible from navigation
- Search bar with clear button
- Search queries sent to Open Food Facts API
- Filter to pet food categories automatically applied
- Search results displayed as list with:
  - Product thumbnail
  - Product name
  - Brand name
  - Barcode (for verification)
- Tap result to view product details
- Loading state while searching
- Empty state if no results found
- Debounced search (300ms delay) to reduce API calls
- Recent searches saved locally (last 10)
- Clear recent searches option

**Priority:** P1 (High)

### US-2.4: Manual Product Entry
**As a** pet owner
**I want** to manually enter product information
**So that** I can log products not found in the database

**Acceptance Criteria:**
- Manual entry form accessible from scanner screen
- Form fields:
  - Product name (required, max 100 characters)
  - Brand name (optional, max 50 characters)
  - Barcode (optional, numeric)
  - Product type (dropdown: Dry food, Wet food, Treats, Supplements)
  - Ingredients (optional, multiline text)
  - Notes (optional, multiline text)
- Form validation for required fields
- Save button creates local-only product
- Manual entries marked with custom flag
- Manual entries not synced to Open Food Facts
- Success message after save
- Navigate to product detail after save

**Priority:** P1 (High)

### US-2.5: Product Caching
**As a** pet owner
**I want** scanned products to be cached locally
**So that** I can access product information offline

**Acceptance Criteria:**
- Products fetched from API saved to local SQLite database
- Subsequent scans of same barcode load from cache instantly
- Cache includes all product data (name, brand, ingredients, etc.)
- Product images downloaded and cached locally
- Cache expires after 30 days (configurable)
- Refresh option available to update cached product
- Offline mode shows cached products only with indicator
- Cache size tracked and managed (warn if >100MB)

**Priority:** P1 (High)

### US-2.6: Handle API Errors
**As a** pet owner
**I want** clear error messages when product lookup fails
**So that** I know what action to take

**Acceptance Criteria:**
- Network error shows "No internet connection" with retry button
- Product not found shows option to manually enter or search
- API rate limit error shows "Please wait" with countdown
- Server error shows "Service unavailable" with retry option
- Timeout error shows "Request timed out" with retry option
- All errors logged for debugging (non-PII only)
- Offline mode automatically enabled when network unavailable
- Error messages user-friendly and actionable

**Priority:** P1 (High)

## Technical Specifications

### Data Layer

#### Product Entity

**File:** `lib/domain/entities/product.dart`

```dart
class Product {
  final String barcode;
  final String name;
  final String? brand;
  final String? imageUrl;
  final String? ingredients;
  final NutritionFacts? nutritionFacts;
  final List<String> categories;
  final bool isManualEntry;
  final DateTime createdAt;
  final DateTime? lastUpdated;

  Product({
    required this.barcode,
    required this.name,
    this.brand,
    this.imageUrl,
    this.ingredients,
    this.nutritionFacts,
    this.categories = const [],
    this.isManualEntry = false,
    required this.createdAt,
    this.lastUpdated,
  });

  bool get isCacheExpired {
    if (lastUpdated == null) return false;
    final expiryDate = lastUpdated!.add(const Duration(days: 30));
    return DateTime.now().isAfter(expiryDate);
  }

  String get displayName => brand != null ? '$brand $name' : name;
}

class NutritionFacts {
  final double? energyKcal;
  final double? proteins;
  final double? carbohydrates;
  final double? fat;
  final double? fiber;
  final String servingSize;

  NutritionFacts({
    this.energyKcal,
    this.proteins,
    this.carbohydrates,
    this.fat,
    this.fiber,
    required this.servingSize,
  });
}
```

#### Product Model

**File:** `lib/data/models/product_model.dart`

```dart
import '../../domain/entities/product.dart';

class ProductModel {
  final String barcode;
  final String name;
  final String? brand;
  final String? imageUrl;
  final String? localImagePath;
  final String? ingredients;
  final Map<String, dynamic>? nutritionFacts;
  final String? categories;
  final bool isManualEntry;
  final DateTime createdAt;
  final DateTime? lastUpdated;

  ProductModel({
    required this.barcode,
    required this.name,
    this.brand,
    this.imageUrl,
    this.localImagePath,
    this.ingredients,
    this.nutritionFacts,
    this.categories,
    this.isManualEntry = false,
    required this.createdAt,
    this.lastUpdated,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      barcode: json['barcode'] as String,
      name: json['name'] as String,
      brand: json['brand'] as String?,
      imageUrl: json['image_url'] as String?,
      localImagePath: json['local_image_path'] as String?,
      ingredients: json['ingredients'] as String?,
      nutritionFacts: json['nutrition_facts'] != null
          ? Map<String, dynamic>.from(json['nutrition_facts'])
          : null,
      categories: json['categories'] as String?,
      isManualEntry: (json['is_manual_entry'] as int?) == 1,
      createdAt: DateTime.parse(json['created_at'] as String),
      lastUpdated: json['last_updated'] != null
          ? DateTime.parse(json['last_updated'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'barcode': barcode,
      'name': name,
      'brand': brand,
      'image_url': imageUrl,
      'local_image_path': localImagePath,
      'ingredients': ingredients,
      'nutrition_facts': nutritionFacts,
      'categories': categories,
      'is_manual_entry': isManualEntry ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'last_updated': lastUpdated?.toIso8601String(),
    };
  }

  Product toEntity() {
    NutritionFacts? nutrition;
    if (nutritionFacts != null) {
      nutrition = NutritionFacts(
        energyKcal: nutritionFacts!['energy_kcal'] as double?,
        proteins: nutritionFacts!['proteins'] as double?,
        carbohydrates: nutritionFacts!['carbohydrates'] as double?,
        fat: nutritionFacts!['fat'] as double?,
        fiber: nutritionFacts!['fiber'] as double?,
        servingSize: nutritionFacts!['serving_size'] as String? ?? '100g',
      );
    }

    return Product(
      barcode: barcode,
      name: name,
      brand: brand,
      imageUrl: localImagePath ?? imageUrl,
      ingredients: ingredients,
      nutritionFacts: nutrition,
      categories: categories?.split(',') ?? [],
      isManualEntry: isManualEntry,
      createdAt: createdAt,
      lastUpdated: lastUpdated,
    );
  }

  factory ProductModel.fromEntity(Product product) {
    Map<String, dynamic>? nutritionJson;
    if (product.nutritionFacts != null) {
      final n = product.nutritionFacts!;
      nutritionJson = {
        'energy_kcal': n.energyKcal,
        'proteins': n.proteins,
        'carbohydrates': n.carbohydrates,
        'fat': n.fat,
        'fiber': n.fiber,
        'serving_size': n.servingSize,
      };
    }

    return ProductModel(
      barcode: product.barcode,
      name: product.name,
      brand: product.brand,
      imageUrl: product.imageUrl,
      ingredients: product.ingredients,
      nutritionFacts: nutritionJson,
      categories: product.categories.join(','),
      isManualEntry: product.isManualEntry,
      createdAt: product.createdAt,
      lastUpdated: product.lastUpdated,
    );
  }

  factory ProductModel.fromOpenFoodFacts(Map<String, dynamic> json) {
    final product = json['product'];
    if (product == null) {
      throw Exception('Product data not found in API response');
    }

    return ProductModel(
      barcode: product['code'] as String,
      name: product['product_name'] as String? ?? 'Unknown Product',
      brand: product['brands'] as String?,
      imageUrl: product['image_url'] as String?,
      ingredients: product['ingredients_text'] as String?,
      nutritionFacts: _extractNutritionFacts(product),
      categories: product['categories'] as String?,
      isManualEntry: false,
      createdAt: DateTime.now(),
      lastUpdated: DateTime.now(),
    );
  }

  static Map<String, dynamic>? _extractNutritionFacts(Map<String, dynamic> product) {
    final nutriments = product['nutriments'];
    if (nutriments == null) return null;

    return {
      'energy_kcal': nutriments['energy-kcal_100g'] as double?,
      'proteins': nutriments['proteins_100g'] as double?,
      'carbohydrates': nutriments['carbohydrates_100g'] as double?,
      'fat': nutriments['fat_100g'] as double?,
      'fiber': nutriments['fiber_100g'] as double?,
      'serving_size': product['serving_size'] as String? ?? '100g',
    };
  }
}
```

#### Database Schema Update

**File:** `lib/data/services/database_service.dart` (update)

```dart
// Add to _onCreate method:
await db.execute('''
  CREATE TABLE products (
    barcode TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    brand TEXT,
    image_url TEXT,
    local_image_path TEXT,
    ingredients TEXT,
    nutrition_facts TEXT,
    categories TEXT,
    is_manual_entry INTEGER DEFAULT 0,
    created_at TEXT NOT NULL,
    last_updated TEXT
  )
''');

await db.execute('CREATE INDEX idx_products_name ON products(name)');
await db.execute('CREATE INDEX idx_products_brand ON products(brand)');
```

#### Open Food Facts Service

**File:** `lib/data/services/open_food_facts_service.dart`

```dart
import 'package:dio/dio.dart';

class OpenFoodFactsService {
  final Dio _dio;
  static const String baseUrl = 'https://world.openfoodfacts.org/api/v2';
  static const Duration timeout = Duration(seconds: 10);

  OpenFoodFactsService({Dio? dio})
      : _dio = dio ??
            Dio(BaseOptions(
              baseUrl: baseUrl,
              connectTimeout: timeout,
              receiveTimeout: timeout,
              headers: {
                'User-Agent': 'FlavorFetch - Pet Food Tracker',
              },
            ));

  Future<Map<String, dynamic>> getProductByBarcode(String barcode) async {
    try {
      final response = await _dio.get('/product/$barcode');

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;

        if (data['status'] == 1) {
          return data;
        } else {
          throw ProductNotFoundException('Product not found: $barcode');
        }
      } else {
        throw ApiException('Failed to fetch product: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  Future<List<Map<String, dynamic>>> searchProducts(
    String query, {
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await _dio.get('/search', queryParameters: {
        'search_terms': query,
        'categories': 'pet-food',
        'page': page,
        'page_size': pageSize,
        'json': 1,
      });

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final products = data['products'] as List<dynamic>? ?? [];
        return products.cast<Map<String, dynamic>>();
      } else {
        throw ApiException('Failed to search products: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  Exception _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException('Request timed out');
      case DioExceptionType.connectionError:
        return NetworkException('No internet connection');
      case DioExceptionType.badResponse:
        if (e.response?.statusCode == 429) {
          return RateLimitException('Too many requests. Please wait.');
        }
        return ApiException('Server error: ${e.response?.statusCode}');
      default:
        return ApiException('Unknown error: ${e.message}');
    }
  }
}

class ProductNotFoundException implements Exception {
  final String message;
  ProductNotFoundException(this.message);
  @override
  String toString() => message;
}

class ApiException implements Exception {
  final String message;
  ApiException(this.message);
  @override
  String toString() => message;
}

class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
  @override
  String toString() => message;
}

class TimeoutException implements Exception {
  final String message;
  TimeoutException(this.message);
  @override
  String toString() => message;
}

class RateLimitException implements Exception {
  final String message;
  RateLimitException(this.message);
  @override
  String toString() => message;
}
```

#### Product Repository Interface

**File:** `lib/domain/repositories/product_repository.dart`

```dart
import '../entities/product.dart';

abstract class ProductRepository {
  Future<Product> getProductByBarcode(String barcode, {bool forceRefresh = false});
  Future<List<Product>> searchProducts(String query);
  Future<Product> createManualProduct(Product product);
  Future<List<Product>> getCachedProducts();
  Future<void> clearExpiredCache();
  Future<int> getCacheSize();
}
```

#### Product Repository Implementation

**File:** `lib/data/repositories/product_repository_impl.dart`

```dart
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../models/product_model.dart';
import '../services/database_service.dart';
import '../services/open_food_facts_service.dart';

class ProductRepositoryImpl implements ProductRepository {
  final DatabaseService _databaseService;
  final OpenFoodFactsService _apiService;

  ProductRepositoryImpl(this._databaseService, this._apiService);

  @override
  Future<Product> getProductByBarcode(
    String barcode, {
    bool forceRefresh = false,
  }) async {
    // Check cache first unless force refresh
    if (!forceRefresh) {
      final cached = await _getCachedProduct(barcode);
      if (cached != null && !cached.isCacheExpired) {
        return cached;
      }
    }

    // Fetch from API
    try {
      final apiData = await _apiService.getProductByBarcode(barcode);
      final model = ProductModel.fromOpenFoodFacts(apiData);

      // Save to cache
      await _cacheProduct(model);

      return model.toEntity();
    } catch (e) {
      // If API fails, return cached version if available
      final cached = await _getCachedProduct(barcode);
      if (cached != null) {
        return cached;
      }
      rethrow;
    }
  }

  @override
  Future<List<Product>> searchProducts(String query) async {
    try {
      final results = await _apiService.searchProducts(query);
      final products = <Product>[];

      for (final result in results) {
        try {
          final model = ProductModel.fromOpenFoodFacts({'product': result});
          await _cacheProduct(model);
          products.add(model.toEntity());
        } catch (e) {
          // Skip invalid products
          continue;
        }
      }

      return products;
    } catch (e) {
      // If search fails, search cached products
      return await _searchCachedProducts(query);
    }
  }

  @override
  Future<Product> createManualProduct(Product product) async {
    final model = ProductModel.fromEntity(product);
    await _cacheProduct(model);
    return product;
  }

  @override
  Future<List<Product>> getCachedProducts() async {
    final db = await _databaseService.database;
    final maps = await db.query('products', orderBy: 'last_updated DESC');
    return maps.map((map) => ProductModel.fromJson(map).toEntity()).toList();
  }

  @override
  Future<void> clearExpiredCache() async {
    final db = await _databaseService.database;
    final expiryDate = DateTime.now().subtract(const Duration(days: 30));

    await db.delete(
      'products',
      where: 'last_updated < ? AND is_manual_entry = 0',
      whereArgs: [expiryDate.toIso8601String()],
    );
  }

  @override
  Future<int> getCacheSize() async {
    final db = await _databaseService.database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM products');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<Product?> _getCachedProduct(String barcode) async {
    final db = await _databaseService.database;
    final maps = await db.query(
      'products',
      where: 'barcode = ?',
      whereArgs: [barcode],
      limit: 1,
    );

    if (maps.isEmpty) return null;
    return ProductModel.fromJson(maps.first).toEntity();
  }

  Future<void> _cacheProduct(ProductModel model) async {
    final db = await _databaseService.database;
    await db.insert(
      'products',
      model.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Product>> _searchCachedProducts(String query) async {
    final db = await _databaseService.database;
    final maps = await db.query(
      'products',
      where: 'name LIKE ? OR brand LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      orderBy: 'last_updated DESC',
      limit: 20,
    );

    return maps.map((map) => ProductModel.fromJson(map).toEntity()).toList();
  }
}
```

### Presentation Layer

#### Scanner Screen

**File:** `lib/presentation/screens/scanner/scanner_screen.dart`

**Key Components:**
- Mobile scanner widget with camera preview
- Scanning overlay with animated border
- Flash toggle button
- Manual entry button
- Barcode format detection
- Haptic feedback on scan
- Loading overlay during product fetch
- Error snackbar for scan failures

**Packages:**
- `mobile_scanner: ^3.5.5`

#### Product Detail Screen

**File:** `lib/presentation/screens/product_detail/product_detail_screen.dart`

**Key Components:**
- Product image with zoom capability
- Product information sections (collapsible)
- Ingredients list
- Nutrition facts table
- "Log Feeding" button (navigates to feeding log)
- Share button
- Refresh button for cached products
- Error state with retry option

#### Product Search Screen

**File:** `lib/presentation/screens/product_search/product_search_screen.dart`

**Key Components:**
- Search bar with debounce
- Recent searches list
- Search results grid
- Loading shimmer effect
- Empty state
- Tap result to view details

#### Manual Product Form Screen

**File:** `lib/presentation/screens/manual_product/manual_product_form_screen.dart`

**Key Components:**
- Form with validation
- Product type dropdown
- Multiline text fields for ingredients/notes
- Save button
- Cancel with confirmation

## Testing Requirements

### Unit Tests

**File:** `test/unit/product_repository_test.dart`
- Test API calls with mocked responses
- Test caching behavior
- Test cache expiry logic
- Test offline fallback
- Test error handling

**File:** `test/unit/open_food_facts_service_test.dart`
- Test API request formation
- Test response parsing
- Test error handling (timeout, network, not found)
- Mock Dio client

**File:** `test/unit/product_model_test.dart`
- Test JSON parsing from Open Food Facts API
- Test entity conversion
- Test manual product creation

### Widget Tests

**File:** `test/widget/scanner_screen_test.dart`
- Test scanner UI elements
- Test flash toggle
- Test manual entry button
- Mock barcode detection

**File:** `test/widget/product_detail_screen_test.dart`
- Test product information display
- Test loading/error states
- Test log feeding button

**File:** `test/widget/product_search_screen_test.dart`
- Test search functionality
- Test results display
- Test empty state

### Integration Tests

**File:** `test/integration/barcode_scan_flow_test.dart`
- Test complete scan-to-detail flow
- Test caching behavior
- Test offline mode
- Test manual product entry

## Definition of Done

- [ ] Barcode scanner functional with all supported formats
- [ ] Open Food Facts API integration working
- [ ] Product entity and model complete with nutrition facts
- [ ] Product caching implemented with expiry
- [ ] Scanner screen with camera preview working
- [ ] Product detail screen displaying all information
- [ ] Product search functional with debouncing
- [ ] Manual product entry form complete
- [ ] Offline mode working with cached products
- [ ] Error handling for all API failures
- [ ] All unit tests passing with >80% coverage
- [ ] All widget tests passing
- [ ] Integration tests passing
- [ ] Code reviewed and merged to develop branch

## Dependencies and Blockers

**Dependencies:**
- Sprint 1 complete (for feeding log integration in Sprint 3)
- Camera permissions configured for iOS/Android
- Network permissions configured

**Potential Blockers:**
- Open Food Facts API rate limits
- Limited pet food products in Open Food Facts database
- Camera performance on older devices
- Barcode detection accuracy in poor lighting

## Notes

- Consider adding QR code support for future product types
- Monitor API usage to avoid rate limits (implement exponential backoff)
- Product images should be cached with size limits
- Consider adding product favorites/bookmarks in future
- Manual products could be submitted to Open Food Facts with user consent
- Consider implementing product comparison feature in future

## Resources

- [Mobile Scanner Package](https://pub.dev/packages/mobile_scanner)
- [Open Food Facts API Documentation](https://world.openfoodfacts.org/data)
- [Dio HTTP Client](https://pub.dev/packages/dio)
- [Barcode Format Specifications](https://en.wikipedia.org/wiki/Universal_Product_Code)
