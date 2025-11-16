import 'dart:convert';
import '../../domain/entities/product.dart';

/// Data model for Product with JSON serialization
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

  /// Create ProductModel from database JSON
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      barcode: json['barcode'] as String,
      name: json['name'] as String,
      brand: json['brand'] as String?,
      imageUrl: json['image_url'] as String?,
      localImagePath: json['local_image_path'] as String?,
      ingredients: json['ingredients'] as String?,
      nutritionFacts: json['nutrition_facts'] != null
          ? (json['nutrition_facts'] is String
              ? jsonDecode(json['nutrition_facts'] as String)
                  as Map<String, dynamic>
              : json['nutrition_facts'] as Map<String, dynamic>)
          : null,
      categories: json['categories'] as String?,
      isManualEntry: (json['is_manual_entry'] as int?) == 1,
      createdAt: DateTime.parse(json['created_at'] as String),
      lastUpdated: json['last_updated'] != null
          ? DateTime.parse(json['last_updated'] as String)
          : null,
    );
  }

  /// Convert ProductModel to database JSON
  Map<String, dynamic> toJson() {
    return {
      'barcode': barcode,
      'name': name,
      'brand': brand,
      'image_url': imageUrl,
      'local_image_path': localImagePath,
      'ingredients': ingredients,
      'nutrition_facts': nutritionFacts != null ? jsonEncode(nutritionFacts) : null,
      'categories': categories,
      'is_manual_entry': isManualEntry ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'last_updated': lastUpdated?.toIso8601String(),
    };
  }

  /// Convert ProductModel to Product entity
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
      categories: categories?.split(',').map((e) => e.trim()).toList() ?? [],
      isManualEntry: isManualEntry,
      createdAt: createdAt,
      lastUpdated: lastUpdated,
    );
  }

  /// Create ProductModel from Product entity
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
      categories: product.categories.join(', '),
      isManualEntry: product.isManualEntry,
      createdAt: product.createdAt,
      lastUpdated: product.lastUpdated,
    );
  }

  /// Create ProductModel from Open Food Facts API response
  factory ProductModel.fromOpenFoodFacts(Map<String, dynamic> json) {
    final product = json['product'];
    if (product == null) {
      throw Exception('Product data not found in API response');
    }

    // Get the product code/barcode
    final barcode = (product['code'] as String?) ?? '';
    if (barcode.isEmpty) {
      throw Exception('Product barcode not found in API response');
    }

    return ProductModel(
      barcode: barcode,
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

  /// Extract nutrition facts from Open Food Facts product data
  static Map<String, dynamic>? _extractNutritionFacts(
      Map<String, dynamic> product) {
    final nutriments = product['nutriments'];
    if (nutriments == null) return null;

    // Helper to safely convert to double
    double? toDouble(dynamic value) {
      if (value == null) return null;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value);
      return null;
    }

    return {
      'energy_kcal': toDouble(nutriments['energy-kcal_100g']),
      'proteins': toDouble(nutriments['proteins_100g']),
      'carbohydrates': toDouble(nutriments['carbohydrates_100g']),
      'fat': toDouble(nutriments['fat_100g']),
      'fiber': toDouble(nutriments['fiber_100g']),
      'serving_size': product['serving_size'] as String? ?? '100g',
    };
  }
}
