import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flavor_fetch/data/services/open_food_facts_service.dart';

@GenerateMocks([Dio])
import 'open_food_facts_service_test.mocks.dart';

void main() {
  late MockDio mockDio;
  late OpenFoodFactsService service;

  setUp(() {
    mockDio = MockDio();
    service = OpenFoodFactsService(dio: mockDio);
  });

  group('OpenFoodFactsService -', () {
    group('getProductByBarcode', () {
      test('returns product data when API call is successful', () async {
        // Arrange
        const barcode = '1234567890';
        final mockResponse = {
          'status': 1,
          'product': {
            'code': barcode,
            'product_name': 'Test Product',
            'brands': 'Test Brand',
          },
        };

        when(mockDio.get('/product/$barcode')).thenAnswer(
          (_) async => Response(
            data: mockResponse,
            statusCode: 200,
            requestOptions: RequestOptions(path: '/product/$barcode'),
          ),
        );

        // Act
        final result = await service.getProductByBarcode(barcode);

        // Assert
        expect(result['status'], 1);
        expect(result['product']['code'], barcode);
        verify(mockDio.get('/product/$barcode')).called(1);
      });

      test('throws ProductNotFoundException when product not found', () async {
        // Arrange
        const barcode = '9999999999';
        final mockResponse = {
          'status': 0,
        };

        when(mockDio.get('/product/$barcode')).thenAnswer(
          (_) async => Response(
            data: mockResponse,
            statusCode: 200,
            requestOptions: RequestOptions(path: '/product/$barcode'),
          ),
        );

        // Act & Assert
        expect(
          () => service.getProductByBarcode(barcode),
          throwsA(isA<ProductNotFoundException>()),
        );
      });

      test('throws NetworkException on connection error', () async {
        // Arrange
        const barcode = '1234567890';

        when(mockDio.get('/product/$barcode')).thenThrow(
          DioException(
            type: DioExceptionType.connectionError,
            requestOptions: RequestOptions(path: '/product/$barcode'),
          ),
        );

        // Act & Assert
        expect(
          () => service.getProductByBarcode(barcode),
          throwsA(isA<NetworkException>()),
        );
      });

      test('throws TimeoutException on connection timeout', () async {
        // Arrange
        const barcode = '1234567890';

        when(mockDio.get('/product/$barcode')).thenThrow(
          DioException(
            type: DioExceptionType.connectionTimeout,
            requestOptions: RequestOptions(path: '/product/$barcode'),
          ),
        );

        // Act & Assert
        expect(
          () => service.getProductByBarcode(barcode),
          throwsA(isA<TimeoutException>()),
        );
      });

      test('throws RateLimitException when rate limited (429)', () async {
        // Arrange
        const barcode = '1234567890';

        when(mockDio.get('/product/$barcode')).thenThrow(
          DioException(
            type: DioExceptionType.badResponse,
            response: Response(
              statusCode: 429,
              requestOptions: RequestOptions(path: '/product/$barcode'),
            ),
            requestOptions: RequestOptions(path: '/product/$barcode'),
          ),
        );

        // Act & Assert
        expect(
          () => service.getProductByBarcode(barcode),
          throwsA(isA<RateLimitException>()),
        );
      });
    });

    group('searchProducts', () {
      test('returns list of products when search is successful', () async {
        // Arrange
        const query = 'dog food';
        final mockResponse = {
          'products': [
            {
              'code': '1234567890',
              'product_name': 'Product 1',
            },
            {
              'code': '0987654321',
              'product_name': 'Product 2',
            },
          ],
        };

        when(mockDio.get('/search', queryParameters: anyNamed('queryParameters')))
            .thenAnswer(
          (_) async => Response(
            data: mockResponse,
            statusCode: 200,
            requestOptions: RequestOptions(path: '/search'),
          ),
        );

        // Act
        final result = await service.searchProducts(query);

        // Assert
        expect(result, isA<List<Map<String, dynamic>>>());
        expect(result.length, 2);
        expect(result[0]['code'], '1234567890');
      });

      test('returns empty list when no products found', () async {
        // Arrange
        const query = 'nonexistent';
        final mockResponse = {
          'products': [],
        };

        when(mockDio.get('/search', queryParameters: anyNamed('queryParameters')))
            .thenAnswer(
          (_) async => Response(
            data: mockResponse,
            statusCode: 200,
            requestOptions: RequestOptions(path: '/search'),
          ),
        );

        // Act
        final result = await service.searchProducts(query);

        // Assert
        expect(result, isEmpty);
      });

      test('throws NetworkException on connection error', () async {
        // Arrange
        const query = 'test';

        when(mockDio.get('/search', queryParameters: anyNamed('queryParameters')))
            .thenThrow(
          DioException(
            type: DioExceptionType.connectionError,
            requestOptions: RequestOptions(path: '/search'),
          ),
        );

        // Act & Assert
        expect(
          () => service.searchProducts(query),
          throwsA(isA<NetworkException>()),
        );
      });
    });
  });
}
