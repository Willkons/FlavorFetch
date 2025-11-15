# Open Food Facts API Integration Guide

## Overview

FlavorFetch integrates with the [Open Food Facts API](https://world.openfoodfacts.org/) to fetch pet food product information based on barcode scans. This guide covers how to use the API, handle responses, implement caching, and manage errors.

## API Basics

### Base URL

```
https://world.openfoodfacts.org/api/v2
```

### Authentication

**No authentication required** - Open Food Facts is a free, open database.

### Rate Limiting

- Be respectful of API resources
- Implement caching to minimize requests
- No hard rate limits, but avoid excessive requests

## Endpoints

### 1. Get Product by Barcode

**Endpoint:** `GET /product/{barcode}`

**Description:** Retrieve detailed product information by barcode

**Example Request:**
```
GET https://world.openfoodfacts.org/api/v2/product/1234567890123
```

**Example Response:**
```json
{
  "code": "1234567890123",
  "product": {
    "product_name": "Premium Cat Food",
    "brands": "PetCo",
    "categories": "Pet food, Cat food",
    "ingredients_text": "Chicken, Rice, Vegetables, Vitamins",
    "image_url": "https://images.openfoodfacts.org/...",
    "nutriments": {
      "proteins_100g": 30,
      "fat_100g": 15,
      "fiber_100g": 3
    }
  },
  "status": 1,
  "status_verbose": "product found"
}
```

**Response Fields:**
- `status`: 1 if product found, 0 if not found
- `code`: Product barcode
- `product`: Product details object
  - `product_name`: Product name
  - `brands`: Brand name(s)
  - `categories`: Product categories
  - `ingredients_text`: Ingredients list
  - `image_url`: Product image URL
  - `nutriments`: Nutritional information

### 2. Search Products

**Endpoint:** `GET /api/v2/search`

**Description:** Search for products by keywords

**Query Parameters:**
- `search_terms`: Search keywords
- `categories`: Filter by category (e.g., "pet-food", "cat-food")
- `page_size`: Number of results per page (default: 20)
- `page`: Page number (default: 1)

**Example Request:**
```
GET https://world.openfoodfacts.org/api/v2/search?search_terms=cat+food&categories=pet-food&page_size=10
```

**Example Response:**
```json
{
  "count": 150,
  "page": 1,
  "page_size": 10,
  "products": [
    {
      "code": "1234567890123",
      "product_name": "Premium Cat Food",
      "brands": "PetCo",
      "categories": "Pet food, Cat food"
    },
    // ... more products
  ]
}
```

## Implementation

### Service Class

```dart
// lib/data/services/open_food_facts_service.dart

import 'package:dio/dio.dart';
import '../../core/constants/app_constants.dart';
import '../models/product_model.dart';

class OpenFoodFactsService {
  final Dio _dio;

  OpenFoodFactsService({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: AppConstants.openFoodFactsBaseUrl,
                connectTimeout: AppConstants.apiTimeout,
                receiveTimeout: AppConstants.apiTimeout,
              ),
            );

  /// Fetch product by barcode
  Future<ProductModel?> getProductByBarcode(String barcode) async {
    try {
      final response = await _dio.get('/product/$barcode');

      if (response.statusCode == 200) {
        final data = response.data;

        if (data['status'] == 1) {
          return ProductModel.fromOpenFoodFacts(
            barcode,
            data['product'],
          );
        }
      }

      return null;
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  /// Search products by keywords
  Future<List<ProductModel>> searchProducts({
    required String query,
    String? category,
    int pageSize = 20,
    int page = 1,
  }) async {
    try {
      final response = await _dio.get(
        '/search',
        queryParameters: {
          'search_terms': query,
          if (category != null) 'categories': category,
          'page_size': pageSize,
          'page': page,
        },
      );

      if (response.statusCode == 200) {
        final products = response.data['products'] as List;
        return products
            .map((p) => ProductModel.fromOpenFoodFacts(
                  p['code'] as String,
                  p,
                ))
            .toList();
      }

      return [];
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  Exception _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Request timeout. Please check your connection.');
      case DioExceptionType.badResponse:
        return Exception('Server error: ${e.response?.statusCode}');
      case DioExceptionType.connectionError:
        return Exception('No internet connection');
      default:
        return Exception('Failed to fetch product data');
    }
  }
}
```

### Product Model

```dart
// lib/data/models/product_model.dart

class ProductModel {
  final String barcode;
  final String name;
  final String? brand;
  final String? ingredients;
  final String? category;
  final String? imageUrl;
  final Map<String, dynamic>? nutritionFacts;
  final DateTime cachedAt;

  ProductModel({
    required this.barcode,
    required this.name,
    this.brand,
    this.ingredients,
    this.category,
    this.imageUrl,
    this.nutritionFacts,
    DateTime? cachedAt,
  }) : cachedAt = cachedAt ?? DateTime.now();

  /// Create from Open Food Facts API response
  factory ProductModel.fromOpenFoodFacts(
    String barcode,
    Map<String, dynamic> json,
  ) {
    return ProductModel(
      barcode: barcode,
      name: json['product_name'] ?? 'Unknown Product',
      brand: json['brands'],
      ingredients: json['ingredients_text'],
      category: json['categories'],
      imageUrl: json['image_url'],
      nutritionFacts: json['nutriments'] as Map<String, dynamic>?,
    );
  }

  /// Convert to database JSON
  Map<String, dynamic> toJson() {
    return {
      'barcode': barcode,
      'name': name,
      'brand': brand,
      'ingredients': ingredients,
      'category': category,
      'image_url': imageUrl,
      'nutrition_facts': nutritionFacts != null
          ? jsonEncode(nutritionFacts)
          : null,
      'cached_at': cachedAt.toIso8601String(),
    };
  }

  /// Create from database JSON
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      barcode: json['barcode'] as String,
      name: json['name'] as String,
      brand: json['brand'] as String?,
      ingredients: json['ingredients'] as String?,
      category: json['category'] as String?,
      imageUrl: json['image_url'] as String?,
      nutritionFacts: json['nutrition_facts'] != null
          ? jsonDecode(json['nutrition_facts']) as Map<String, dynamic>
          : null,
      cachedAt: DateTime.parse(json['cached_at'] as String),
    );
  }
}
```

## Caching Strategy

### Offline-First Approach

1. **Check local cache** first
2. If not found or stale, **fetch from API**
3. **Save to cache**
4. **Return result**

### Repository Implementation

```dart
// lib/data/repositories/product_repository_impl.dart

class ProductRepositoryImpl implements ProductRepository {
  final DatabaseService _database;
  final OpenFoodFactsService _apiService;

  static const Duration _cacheExpiration = Duration(days: 30);

  ProductRepositoryImpl(this._database, this._apiService);

  @override
  Future<Product?> getProductByBarcode(String barcode) async {
    // 1. Check cache first
    final cached = await _getCachedProduct(barcode);
    if (cached != null && !_isStale(cached.cachedAt)) {
      return cached.toEntity();
    }

    // 2. Fetch from API
    try {
      final product = await _apiService.getProductByBarcode(barcode);
      if (product != null) {
        // 3. Save to cache
        await _cacheProduct(product);
        return product.toEntity();
      }
    } on Exception catch (e) {
      // 4. If API fails, return cached data even if stale
      if (cached != null) {
        return cached.toEntity();
      }
      rethrow;
    }

    return null;
  }

  Future<ProductModel?> _getCachedProduct(String barcode) async {
    final db = await _database.database;
    final results = await db.query(
      AppConstants.tableProducts,
      where: 'barcode = ?',
      whereArgs: [barcode],
    );

    if (results.isNotEmpty) {
      return ProductModel.fromJson(results.first);
    }
    return null;
  }

  Future<void> _cacheProduct(ProductModel product) async {
    final db = await _database.database;
    await db.insert(
      AppConstants.tableProducts,
      product.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  bool _isStale(DateTime cachedAt) {
    return DateTime.now().difference(cachedAt) > _cacheExpiration;
  }
}
```

## Error Handling

### Common Error Scenarios

1. **Product Not Found (404)**
   - Show manual entry form
   - Allow user to enter product details manually

2. **Network Error**
   - Check local cache
   - Show offline indicator
   - Retry option

3. **Timeout**
   - Increase timeout for slow connections
   - Show loading indicator
   - Fallback to cache

4. **Invalid Barcode**
   - Validate barcode format before API call
   - Show error message to user

### Error Handling Example

```dart
Future<Product?> getProductByBarcode(String barcode) async {
  try {
    // Validate barcode
    if (!_isValidBarcode(barcode)) {
      throw Exception('Invalid barcode format');
    }

    // Check cache
    final cached = await _getCachedProduct(barcode);
    if (cached != null && !_isStale(cached.cachedAt)) {
      return cached.toEntity();
    }

    // Fetch from API
    final product = await _apiService.getProductByBarcode(barcode);
    if (product != null) {
      await _cacheProduct(product);
      return product.toEntity();
    }

    // Product not found
    return null;
  } on Exception catch (e) {
    // Return cached data if available
    if (cached != null) {
      return cached.toEntity();
    }

    // Re-throw error if no cache available
    throw Exception('Failed to fetch product: ${e.toString()}');
  }
}

bool _isValidBarcode(String barcode) {
  // EAN-8, EAN-13, UPC-A, UPC-E
  return RegExp(r'^\d{8}$|^\d{12,13}$').hasMatch(barcode);
}
```

## Testing

### Mock API Service

```dart
// test/helpers/mock_open_food_facts_service.dart

class MockOpenFoodFactsService extends Mock implements OpenFoodFactsService {}

void main() {
  group('ProductRepository', () {
    late ProductRepositoryImpl repository;
    late MockOpenFoodFactsService mockApi;
    late MockDatabaseService mockDb;

    setUp(() {
      mockApi = MockOpenFoodFactsService();
      mockDb = MockDatabaseService();
      repository = ProductRepositoryImpl(mockDb, mockApi);
    });

    test('should fetch from API when not in cache', () async {
      // Arrange
      when(mockDb.query(any))
          .thenAnswer((_) async => []);
      when(mockApi.getProductByBarcode('123'))
          .thenAnswer((_) async => ProductModel(...));

      // Act
      final result = await repository.getProductByBarcode('123');

      // Assert
      expect(result, isNotNull);
      verify(mockApi.getProductByBarcode('123')).called(1);
    });

    test('should return cached data when available', () async {
      // Arrange
      final cached = ProductModel(
        barcode: '123',
        name: 'Cached Product',
        cachedAt: DateTime.now(),
      );
      when(mockDb.query(any))
          .thenAnswer((_) async => [cached.toJson()]);

      // Act
      final result = await repository.getProductByBarcode('123');

      // Assert
      expect(result?.name, 'Cached Product');
      verifyNever(mockApi.getProductByBarcode(any));
    });
  });
}
```

## Best Practices

1. **Always cache API responses** to minimize network requests
2. **Handle offline scenarios** gracefully
3. **Validate barcodes** before making API calls
4. **Use timeouts** to prevent hanging requests
5. **Implement retry logic** for transient failures
6. **Monitor API usage** to avoid abuse
7. **Provide manual entry fallback** when API fails
8. **Respect user's data plan** by minimizing unnecessary requests

## Resources

- [Open Food Facts API Documentation](https://openfoodfacts.github.io/openfoodfacts-server/api/)
- [Open Food Facts Database](https://world.openfoodfacts.org/)
- [Dio HTTP Client](https://pub.dev/packages/dio)
- [Barcode Scanner Package](https://pub.dev/packages/mobile_scanner)

---

**Last Updated:** November 15, 2025
