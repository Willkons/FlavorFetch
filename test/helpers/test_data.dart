/// Test data helpers for FlavorFetch tests
class TestData {
  TestData._();

  // Sample pet data
  static const Map<String, dynamic> samplePet = {
    'id': 1,
    'name': 'Fluffy',
    'type': 'cat',
    'breed': 'Persian',
    'birthDate': '2020-01-15',
    'photoPath': '/path/to/photo.jpg',
  };

  // Sample product data
  static const Map<String, dynamic> sampleProduct = {
    'barcode': '1234567890123',
    'name': 'Premium Cat Food',
    'brand': 'PetCo',
    'ingredients': 'Chicken, Rice, Vegetables',
    'category': 'cat-food',
  };

  // Sample feeding log data
  static const Map<String, dynamic> sampleFeedingLog = {
    'id': 1,
    'petId': 1,
    'productBarcode': '1234567890123',
    'rating': 'love',
    'timestamp': '2024-11-15 10:30:00',
    'notes': 'Really enjoyed it!',
  };
}
