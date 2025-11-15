import 'package:flutter_test/flutter_test.dart';
import 'package:flavor_fetch/domain/entities/pet.dart';

void main() {
  group('Pet Entity', () {
    test('should create a Pet with required fields', () {
      final now = DateTime.now();
      final pet = Pet(
        id: '123',
        name: 'Buddy',
        type: PetType.dog,
        createdAt: now,
        updatedAt: now,
      );

      expect(pet.id, '123');
      expect(pet.name, 'Buddy');
      expect(pet.type, PetType.dog);
      expect(pet.breed, null);
      expect(pet.birthDate, null);
      expect(pet.photoPath, null);
      expect(pet.createdAt, now);
      expect(pet.updatedAt, now);
    });

    test('should create a Pet with all fields', () {
      final now = DateTime.now();
      final birthDate = DateTime(2020, 1, 1);
      final pet = Pet(
        id: '123',
        name: 'Buddy',
        type: PetType.dog,
        breed: 'Golden Retriever',
        birthDate: birthDate,
        photoPath: '/path/to/photo.jpg',
        createdAt: now,
        updatedAt: now,
      );

      expect(pet.id, '123');
      expect(pet.name, 'Buddy');
      expect(pet.type, PetType.dog);
      expect(pet.breed, 'Golden Retriever');
      expect(pet.birthDate, birthDate);
      expect(pet.photoPath, '/path/to/photo.jpg');
    });

    group('Age Calculation', () {
      test('should return null for ageInMonths when birthDate is null', () {
        final pet = Pet(
          id: '123',
          name: 'Buddy',
          type: PetType.dog,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        expect(pet.ageInMonths, null);
      });

      test('should calculate correct age in months', () {
        final now = DateTime.now();
        final birthDate = DateTime(
          now.year - 2,
          now.month - 6,
          now.day,
        );
        final pet = Pet(
          id: '123',
          name: 'Buddy',
          type: PetType.dog,
          birthDate: birthDate,
          createdAt: now,
          updatedAt: now,
        );

        expect(pet.ageInMonths, 30); // 2 years + 6 months = 30 months
      });

      test('should return "Age unknown" when birthDate is null', () {
        final pet = Pet(
          id: '123',
          name: 'Buddy',
          type: PetType.dog,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        expect(pet.ageDisplayString, 'Age unknown');
      });

      test('should return age in months for pets less than 1 year old', () {
        final now = DateTime.now();
        final birthDate = DateTime(
          now.year,
          now.month - 6,
          now.day,
        );
        final pet = Pet(
          id: '123',
          name: 'Buddy',
          type: PetType.dog,
          birthDate: birthDate,
          createdAt: now,
          updatedAt: now,
        );

        expect(pet.ageDisplayString, '6 months');
      });

      test('should return singular "month" for 1 month old pet', () {
        final now = DateTime.now();
        final birthDate = DateTime(
          now.year,
          now.month - 1,
          now.day,
        );
        final pet = Pet(
          id: '123',
          name: 'Buddy',
          type: PetType.dog,
          birthDate: birthDate,
          createdAt: now,
          updatedAt: now,
        );

        expect(pet.ageDisplayString, '1 month');
      });

      test('should return age in years for pets 1+ years old', () {
        final now = DateTime.now();
        final birthDate = DateTime(
          now.year - 3,
          now.month,
          now.day,
        );
        final pet = Pet(
          id: '123',
          name: 'Buddy',
          type: PetType.dog,
          birthDate: birthDate,
          createdAt: now,
          updatedAt: now,
        );

        expect(pet.ageDisplayString, '3 years');
      });

      test('should return singular "year" for 1 year old pet', () {
        final now = DateTime.now();
        final birthDate = DateTime(
          now.year - 1,
          now.month,
          now.day,
        );
        final pet = Pet(
          id: '123',
          name: 'Buddy',
          type: PetType.dog,
          birthDate: birthDate,
          createdAt: now,
          updatedAt: now,
        );

        expect(pet.ageDisplayString, '1 year');
      });

      test('should handle future birth dates gracefully', () {
        final now = DateTime.now();
        final birthDate = DateTime(
          now.year + 1,
          now.month,
          now.day,
        );
        final pet = Pet(
          id: '123',
          name: 'Buddy',
          type: PetType.dog,
          birthDate: birthDate,
          createdAt: now,
          updatedAt: now,
        );

        expect(pet.ageDisplayString, 'Age unknown');
      });
    });

    group('copyWith', () {
      test('should create a copy with updated fields', () {
        final now = DateTime.now();
        final original = Pet(
          id: '123',
          name: 'Buddy',
          type: PetType.dog,
          createdAt: now,
          updatedAt: now,
        );

        final updated = original.copyWith(
          name: 'Max',
          type: PetType.cat,
        );

        expect(updated.id, '123');
        expect(updated.name, 'Max');
        expect(updated.type, PetType.cat);
        expect(updated.createdAt, now);
      });

      test('should keep original values if not specified', () {
        final now = DateTime.now();
        final original = Pet(
          id: '123',
          name: 'Buddy',
          type: PetType.dog,
          breed: 'Labrador',
          createdAt: now,
          updatedAt: now,
        );

        final updated = original.copyWith(name: 'Max');

        expect(updated.breed, 'Labrador');
        expect(updated.type, PetType.dog);
      });
    });

    group('Equality', () {
      test('should be equal when all fields are the same', () {
        final now = DateTime.now();
        final pet1 = Pet(
          id: '123',
          name: 'Buddy',
          type: PetType.dog,
          createdAt: now,
          updatedAt: now,
        );
        final pet2 = Pet(
          id: '123',
          name: 'Buddy',
          type: PetType.dog,
          createdAt: now,
          updatedAt: now,
        );

        expect(pet1, pet2);
        expect(pet1.hashCode, pet2.hashCode);
      });

      test('should not be equal when fields differ', () {
        final now = DateTime.now();
        final pet1 = Pet(
          id: '123',
          name: 'Buddy',
          type: PetType.dog,
          createdAt: now,
          updatedAt: now,
        );
        final pet2 = Pet(
          id: '123',
          name: 'Max',
          type: PetType.dog,
          createdAt: now,
          updatedAt: now,
        );

        expect(pet1, isNot(pet2));
      });
    });
  });

  group('PetType Enum', () {
    test('should have correct display names', () {
      expect(PetType.dog.displayName, 'Dog');
      expect(PetType.cat.displayName, 'Cat');
      expect(PetType.other.displayName, 'Other');
    });

    test('should have all expected values', () {
      expect(PetType.values, hasLength(3));
      expect(PetType.values, contains(PetType.dog));
      expect(PetType.values, contains(PetType.cat));
      expect(PetType.values, contains(PetType.other));
    });
  });
}
