/// Represents nutritional information for a product
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NutritionFacts &&
          runtimeType == other.runtimeType &&
          energyKcal == other.energyKcal &&
          proteins == other.proteins &&
          carbohydrates == other.carbohydrates &&
          fat == other.fat &&
          fiber == other.fiber &&
          servingSize == other.servingSize;

  @override
  int get hashCode => Object.hash(
        energyKcal,
        proteins,
        carbohydrates,
        fat,
        fiber,
        servingSize,
      );
}

/// Represents a pet food product
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

  /// Check if the cached product has expired (30 days old)
  bool get isCacheExpired {
    if (lastUpdated == null) return false;
    final expiryDate = lastUpdated!.add(const Duration(days: 30));
    return DateTime.now().isAfter(expiryDate);
  }

  /// Get display name with brand if available
  String get displayName => brand != null ? '$brand $name' : name;

  /// Create a copy of this product with updated fields
  Product copyWith({
    String? barcode,
    String? name,
    String? brand,
    String? imageUrl,
    String? ingredients,
    NutritionFacts? nutritionFacts,
    List<String>? categories,
    bool? isManualEntry,
    DateTime? createdAt,
    DateTime? lastUpdated,
  }) {
    return Product(
      barcode: barcode ?? this.barcode,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      imageUrl: imageUrl ?? this.imageUrl,
      ingredients: ingredients ?? this.ingredients,
      nutritionFacts: nutritionFacts ?? this.nutritionFacts,
      categories: categories ?? this.categories,
      isManualEntry: isManualEntry ?? this.isManualEntry,
      createdAt: createdAt ?? this.createdAt,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product &&
          runtimeType == other.runtimeType &&
          barcode == other.barcode &&
          name == other.name &&
          brand == other.brand &&
          imageUrl == other.imageUrl &&
          ingredients == other.ingredients &&
          nutritionFacts == other.nutritionFacts &&
          _listEquals(categories, other.categories) &&
          isManualEntry == other.isManualEntry &&
          createdAt == other.createdAt &&
          lastUpdated == other.lastUpdated;

  @override
  int get hashCode => Object.hash(
        barcode,
        name,
        brand,
        imageUrl,
        ingredients,
        nutritionFacts,
        Object.hashAll(categories),
        isManualEntry,
        createdAt,
        lastUpdated,
      );

  bool _listEquals<T>(List<T>? a, List<T>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
