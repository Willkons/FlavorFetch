import '../entities/product.dart';

/// Repository interface for product data operations
abstract class ProductRepository {
  /// Get a product by barcode
  ///
  /// If [forceRefresh] is true, always fetch from API.
  /// Otherwise, return cached product if available and not expired.
  Future<Product> getProductByBarcode(
    String barcode, {
    bool forceRefresh = false,
  });

  /// Search for products by name or brand
  Future<List<Product>> searchProducts(String query);

  /// Create a manual product entry
  Future<Product> createManualProduct(Product product);

  /// Get all cached products
  Future<List<Product>> getCachedProducts();

  /// Clear expired cached products (older than 30 days)
  Future<void> clearExpiredCache();

  /// Get the number of cached products
  Future<int> getCacheSize();
}
