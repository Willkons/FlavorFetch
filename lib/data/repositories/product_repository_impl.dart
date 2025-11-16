import 'package:sqflite/sqflite.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../models/product_model.dart';
import '../services/database_service.dart';
import '../services/open_food_facts_service.dart';

/// Implementation of ProductRepository
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

  /// Get a cached product by barcode
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

  /// Cache a product in the database
  Future<void> _cacheProduct(ProductModel model) async {
    final db = await _databaseService.database;
    await db.insert(
      'products',
      model.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Search cached products by name or brand
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
