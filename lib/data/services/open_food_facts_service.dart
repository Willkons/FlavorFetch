import 'package:dio/dio.dart';

/// Service for interacting with the Open Food Facts API
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

  /// Get product information by barcode
  Future<Map<String, dynamic>> getProductByBarcode(String barcode) async {
    try {
      final response = await _dio.get('/product/$barcode');

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;

        // Check if product was found
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

  /// Search for products by name or brand
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

  /// Handle Dio exceptions and convert to custom exceptions
  Exception _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return TimeoutException('Request timed out');
      case DioExceptionType.connectionError:
        return NetworkException('No internet connection');
      case DioExceptionType.badResponse:
        if (e.response?.statusCode == 429) {
          return RateLimitException('Too many requests. Please wait.');
        }
        return ApiException('Server error: ${e.response?.statusCode}');
      case DioExceptionType.cancel:
        return ApiException('Request cancelled');
      default:
        return ApiException('Unknown error: ${e.message}');
    }
  }
}

/// Exception thrown when a product is not found in the API
class ProductNotFoundException implements Exception {
  final String message;
  ProductNotFoundException(this.message);
  @override
  String toString() => message;
}

/// Exception thrown for general API errors
class ApiException implements Exception {
  final String message;
  ApiException(this.message);
  @override
  String toString() => message;
}

/// Exception thrown when network connection is unavailable
class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
  @override
  String toString() => message;
}

/// Exception thrown when a request times out
class TimeoutException implements Exception {
  final String message;
  TimeoutException(this.message);
  @override
  String toString() => message;
}

/// Exception thrown when API rate limit is exceeded
class RateLimitException implements Exception {
  final String message;
  RateLimitException(this.message);
  @override
  String toString() => message;
}
