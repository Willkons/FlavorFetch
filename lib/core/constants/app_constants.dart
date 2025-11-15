/// Application-wide constants for FlavorFetch
class AppConstants {
  AppConstants._();

  // App info
  static const String appName = 'FlavorFetch';
  static const String appVersion = '0.1.0';

  // Database
  static const String databaseName = 'flavor_fetch.db';
  static const int databaseVersion = 1;

  // Table names
  static const String tablePets = 'pets';
  static const String tableProducts = 'products';
  static const String tableFeedingLogs = 'feeding_logs';

  // API
  static const String openFoodFactsBaseUrl =
      'https://world.openfoodfacts.org/api/v2';
  static const Duration apiTimeout = Duration(seconds: 30);

  // Image
  static const int maxImageSizeBytes = 5 * 1024 * 1024; // 5MB
  static const int imageQuality = 85;

  // Pagination
  static const int defaultPageSize = 20;

  // Rating values
  static const String ratingLove = 'love';
  static const String ratingLike = 'like';
  static const String ratingNeutral = 'neutral';
  static const String ratingDislike = 'dislike';

  // Date formats
  static const String dateFormat = 'yyyy-MM-dd';
  static const String dateTimeFormat = 'yyyy-MM-dd HH:mm:ss';
  static const String displayDateFormat = 'MMM d, yyyy';
  static const String displayDateTimeFormat = 'MMM d, yyyy h:mm a';
}
