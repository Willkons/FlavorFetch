import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flavor_fetch/data/repositories/product_repository_impl.dart';
import 'package:flavor_fetch/data/services/database_service.dart';
import 'package:flavor_fetch/data/services/open_food_facts_service.dart';
import 'package:flavor_fetch/domain/entities/product.dart';

@GenerateMocks([DatabaseService, OpenFoodFactsService, Database])
import 'product_repository_test.mocks.dart';

void main() {
  late MockDatabaseService mockDatabaseService;
  late MockOpenFoodFactsService mockApiService;
  late MockDatabase mockDatabase;
  late ProductRepositoryImpl repository;

  setUp(() {
    mockDatabaseService = MockDatabaseService();
    mockApiService = MockOpenFoodFactsService();
    mockDatabase = MockDatabase();
    repository = ProductRepositoryImpl(mockDatabaseService, mockApiService);

    // Default database mock
    when(mockDatabaseService.database).thenAnswer((_) async => mockDatabase);
  });

  group('ProductRepository -', () {
    group('getProductByBarcode', () {
      test('returns cached product when available and not expired', () async {
        // Arrange
        const barcode = '1234567890';
        final cachedProduct = {
          'barcode': barcode,
          'name': 'Cached Product',
          'created_at': DateTime.now().toIso8601String(),
          'last_updated':
              DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
          'is_manual_entry': 0,
        };

        when(mockDatabase.query(
          'products',
          where: anyNamed('where'),
          whereArgs: anyNamed('whereArgs'),
          limit: anyNamed('limit'),
        )).thenAnswer((_) async => [cachedProduct]);

        // Act
        final result = await repository.getProductByBarcode(barcode);

        // Assert
        expect(result.barcode, barcode);
        expect(result.name, 'Cached Product');
        verifyNever(mockApiService.getProductByBarcode(any));
      });

      test('fetches from API and caches when not in cache', () async {
        // Arrange
        const barcode = '1234567890';
        final apiResponse = {
          'status': 1,
          'product': {
            'code': barcode,
            'product_name': 'API Product',
            'brands': 'Test Brand',
          },
        };

        // Mock cache miss
        when(mockDatabase.query(
          'products',
          where: anyNamed('where'),
          whereArgs: anyNamed('whereArgs'),
          limit: anyNamed('limit'),
        )).thenAnswer((_) async => []);

        when(mockApiService.getProductByBarcode(barcode))
            .thenAnswer((_) async => apiResponse);

        when(mockDatabase.insert(
          any,
          any,
          conflictAlgorithm: anyNamed('conflictAlgorithm'),
        )).thenAnswer((_) async => 1);

        // Act
        final result = await repository.getProductByBarcode(barcode);

        // Assert
        expect(result.barcode, barcode);
        expect(result.name, 'API Product');
        verify(mockApiService.getProductByBarcode(barcode)).called(1);
        verify(mockDatabase.insert(
          'products',
          any,
          conflictAlgorithm: ConflictAlgorithm.replace,
        )).called(1);
      });

      test('returns cached product when API fails', () async {
        // Arrange
        const barcode = '1234567890';
        final cachedProduct = {
          'barcode': barcode,
          'name': 'Cached Product',
          'created_at': DateTime.now().toIso8601String(),
          'last_updated': DateTime.now().toIso8601String(),
          'is_manual_entry': 0,
        };

        // First call for expired check, second for fallback
        when(mockDatabase.query(
          'products',
          where: anyNamed('where'),
          whereArgs: anyNamed('whereArgs'),
          limit: anyNamed('limit'),
        )).thenAnswer((_) async => [cachedProduct]);

        when(mockApiService.getProductByBarcode(barcode))
            .thenThrow(NetworkException('No internet'));

        // Act
        final result = await repository.getProductByBarcode(barcode);

        // Assert
        expect(result.barcode, barcode);
        expect(result.name, 'Cached Product');
      });

      test('throws exception when API fails and no cache available', () async {
        // Arrange
        const barcode = '1234567890';

        when(mockDatabase.query(
          'products',
          where: anyNamed('where'),
          whereArgs: anyNamed('whereArgs'),
          limit: anyNamed('limit'),
        )).thenAnswer((_) async => []);

        when(mockApiService.getProductByBarcode(barcode))
            .thenThrow(NetworkException('No internet'));

        // Act & Assert
        expect(
          () => repository.getProductByBarcode(barcode),
          throwsA(isA<NetworkException>()),
        );
      });

      test('forces refresh when forceRefresh is true', () async {
        // Arrange
        const barcode = '1234567890';
        final apiResponse = {
          'status': 1,
          'product': {
            'code': barcode,
            'product_name': 'Refreshed Product',
          },
        };

        when(mockApiService.getProductByBarcode(barcode))
            .thenAnswer((_) async => apiResponse);

        when(mockDatabase.insert(
          any,
          any,
          conflictAlgorithm: anyNamed('conflictAlgorithm'),
        )).thenAnswer((_) async => 1);

        // Act
        await repository.getProductByBarcode(barcode, forceRefresh: true);

        // Assert
        verify(mockApiService.getProductByBarcode(barcode)).called(1);
      });
    });

    group('createManualProduct', () {
      test('saves manual product to cache', () async {
        // Arrange
        final product = Product(
          barcode: 'MANUAL_123',
          name: 'Manual Product',
          isManualEntry: true,
          createdAt: DateTime.now(),
        );

        when(mockDatabase.insert(
          any,
          any,
          conflictAlgorithm: anyNamed('conflictAlgorithm'),
        )).thenAnswer((_) async => 1);

        // Act
        final result = await repository.createManualProduct(product);

        // Assert
        expect(result.barcode, product.barcode);
        expect(result.isManualEntry, true);
        verify(mockDatabase.insert(
          'products',
          any,
          conflictAlgorithm: ConflictAlgorithm.replace,
        )).called(1);
      });
    });

    group('getCachedProducts', () {
      test('returns all cached products', () async {
        // Arrange
        final cachedProducts = [
          {
            'barcode': '1234567890',
            'name': 'Product 1',
            'created_at': DateTime.now().toIso8601String(),
            'is_manual_entry': 0,
          },
          {
            'barcode': '0987654321',
            'name': 'Product 2',
            'created_at': DateTime.now().toIso8601String(),
            'is_manual_entry': 1,
          },
        ];

        when(mockDatabase.query(
          'products',
          orderBy: anyNamed('orderBy'),
        )).thenAnswer((_) async => cachedProducts);

        // Act
        final result = await repository.getCachedProducts();

        // Assert
        expect(result.length, 2);
        expect(result[0].barcode, '1234567890');
        expect(result[1].isManualEntry, true);
      });
    });

    group('clearExpiredCache', () {
      test('deletes expired cached products', () async {
        // Arrange
        when(mockDatabase.delete(
          any,
          where: anyNamed('where'),
          whereArgs: anyNamed('whereArgs'),
        )).thenAnswer((_) async => 1);

        // Act
        await repository.clearExpiredCache();

        // Assert
        verify(mockDatabase.delete(
          'products',
          where: anyNamed('where'),
          whereArgs: anyNamed('whereArgs'),
        )).called(1);
      });
    });

    group('getCacheSize', () {
      test('returns count of cached products', () async {
        // Arrange
        when(mockDatabase.rawQuery(any)).thenAnswer(
          (_) async => [
            {'count': 42}
          ],
        );

        // Act
        final result = await repository.getCacheSize();

        // Assert
        expect(result, 42);
      });
    });
  });
}
