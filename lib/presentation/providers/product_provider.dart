import 'package:flutter/foundation.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';

/// Provider for managing product state
class ProductProvider with ChangeNotifier {
  final ProductRepository _repository;

  ProductProvider(this._repository);

  Product? _currentProduct;
  List<Product> _searchResults = [];
  List<Product> _cachedProducts = [];
  bool _isLoading = false;
  String? _errorMessage;

  Product? get currentProduct => _currentProduct;
  List<Product> get searchResults => _searchResults;
  List<Product> get cachedProducts => _cachedProducts;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Get product by barcode
  Future<void> getProductByBarcode(
    String barcode, {
    bool forceRefresh = false,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentProduct = await _repository.getProductByBarcode(
        barcode,
        forceRefresh: forceRefresh,
      );
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      _currentProduct = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Search for products
  Future<void> searchProducts(String query) async {
    if (query.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _searchResults = await _repository.searchProducts(query);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      _searchResults = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Create a manual product
  Future<void> createManualProduct(Product product) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentProduct = await _repository.createManualProduct(product);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load all cached products
  Future<void> loadCachedProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _cachedProducts = await _repository.getCachedProducts();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      _cachedProducts = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clear expired cache
  Future<void> clearExpiredCache() async {
    try {
      await _repository.clearExpiredCache();
      await loadCachedProducts();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  /// Get cache size
  Future<int> getCacheSize() async {
    return await _repository.getCacheSize();
  }

  /// Clear current product
  void clearCurrentProduct() {
    _currentProduct = null;
    notifyListeners();
  }

  /// Clear search results
  void clearSearchResults() {
    _searchResults = [];
    notifyListeners();
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
