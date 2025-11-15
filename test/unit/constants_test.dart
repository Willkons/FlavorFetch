import 'package:flutter_test/flutter_test.dart';
import 'package:flavor_fetch/core/constants/app_constants.dart';

void main() {
  group('AppConstants', () {
    test('should have correct app name', () {
      expect(AppConstants.appName, 'FlavorFetch');
    });

    test('should have valid database name', () {
      expect(AppConstants.databaseName, isNotEmpty);
      expect(AppConstants.databaseName.endsWith('.db'), isTrue);
    });

    test('should have valid database version', () {
      expect(AppConstants.databaseVersion, greaterThan(0));
    });

    test('should have valid table names', () {
      expect(AppConstants.tablePets, isNotEmpty);
      expect(AppConstants.tableProducts, isNotEmpty);
      expect(AppConstants.tableFeedingLogs, isNotEmpty);
    });

    test('should have valid API configuration', () {
      expect(AppConstants.openFoodFactsBaseUrl, startsWith('https://'));
      expect(
        AppConstants.apiTimeout,
        greaterThan(const Duration(seconds: 0)),
      );
    });

    test('should have valid rating values', () {
      final ratings = [
        AppConstants.ratingLove,
        AppConstants.ratingLike,
        AppConstants.ratingNeutral,
        AppConstants.ratingDislike,
      ];

      for (final rating in ratings) {
        expect(rating, isNotEmpty);
      }
    });
  });
}
