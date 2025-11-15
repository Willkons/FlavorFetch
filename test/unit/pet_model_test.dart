import 'package:flutter_test/flutter_test.dart';
import 'package:flavor_fetch/domain/entities/pet.dart';
import 'package:flavor_fetch/data/models/pet_model.dart';

void main() {
  group('PetModel', () {
    final now = DateTime.now();
    final birthDate = DateTime(2020, 1, 1);

    final jsonMap = {
      'id': '123',
      'name': 'Buddy',
      'type': 'dog',
      'breed': 'Golden Retriever',
      'birth_date': birthDate.toIso8601String(),
      'photo_path': '/path/to/photo.jpg',
      'created_at': now.toIso8601String(),
      'updated_at': now.toIso8601String(),
    };

    group('fromJson', () {
      test('should correctly deserialize from JSON with all fields', () {
        final model = PetModel.fromJson(jsonMap);

        expect(model.id, '123');
        expect(model.name, 'Buddy');
        expect(model.type, 'dog');
        expect(model.breed, 'Golden Retriever');
        expect(model.birthDate, birthDate);
        expect(model.photoPath, '/path/to/photo.jpg');
        expect(model.createdAt, now);
        expect(model.updatedAt, now);
      });

      test('should correctly deserialize from JSON with null optional fields', () {
        final minimalJson = {
          'id': '123',
          'name': 'Buddy',
          'type': 'dog',
          'breed': null,
          'birth_date': null,
          'photo_path': null,
          'created_at': now.toIso8601String(),
          'updated_at': now.toIso8601String(),
        };

        final model = PetModel.fromJson(minimalJson);

        expect(model.id, '123');
        expect(model.name, 'Buddy');
        expect(model.type, 'dog');
        expect(model.breed, null);
        expect(model.birthDate, null);
        expect(model.photoPath, null);
      });
    });

    group('toJson', () {
      test('should correctly serialize to JSON with all fields', () {
        final model = PetModel(
          id: '123',
          name: 'Buddy',
          type: 'dog',
          breed: 'Golden Retriever',
          birthDate: birthDate,
          photoPath: '/path/to/photo.jpg',
          createdAt: now,
          updatedAt: now,
        );

        final json = model.toJson();

        expect(json['id'], '123');
        expect(json['name'], 'Buddy');
        expect(json['type'], 'dog');
        expect(json['breed'], 'Golden Retriever');
        expect(json['birth_date'], birthDate.toIso8601String());
        expect(json['photo_path'], '/path/to/photo.jpg');
        expect(json['created_at'], now.toIso8601String());
        expect(json['updated_at'], now.toIso8601String());
      });

      test('should correctly serialize to JSON with null optional fields', () {
        final model = PetModel(
          id: '123',
          name: 'Buddy',
          type: 'dog',
          createdAt: now,
          updatedAt: now,
        );

        final json = model.toJson();

        expect(json['id'], '123');
        expect(json['name'], 'Buddy');
        expect(json['type'], 'dog');
        expect(json['breed'], null);
        expect(json['birth_date'], null);
        expect(json['photo_path'], null);
      });
    });

    group('toEntity', () {
      test('should correctly convert to Pet entity with all fields', () {
        final model = PetModel(
          id: '123',
          name: 'Buddy',
          type: 'dog',
          breed: 'Golden Retriever',
          birthDate: birthDate,
          photoPath: '/path/to/photo.jpg',
          createdAt: now,
          updatedAt: now,
        );

        final entity = model.toEntity();

        expect(entity.id, '123');
        expect(entity.name, 'Buddy');
        expect(entity.type, PetType.dog);
        expect(entity.breed, 'Golden Retriever');
        expect(entity.birthDate, birthDate);
        expect(entity.photoPath, '/path/to/photo.jpg');
        expect(entity.createdAt, now);
        expect(entity.updatedAt, now);
      });

      test('should correctly convert PetType from string', () {
        final dogModel = PetModel(
          id: '1',
          name: 'Dog',
          type: 'dog',
          createdAt: now,
          updatedAt: now,
        );
        expect(dogModel.toEntity().type, PetType.dog);

        final catModel = PetModel(
          id: '2',
          name: 'Cat',
          type: 'cat',
          createdAt: now,
          updatedAt: now,
        );
        expect(catModel.toEntity().type, PetType.cat);

        final otherModel = PetModel(
          id: '3',
          name: 'Other',
          type: 'other',
          createdAt: now,
          updatedAt: now,
        );
        expect(otherModel.toEntity().type, PetType.other);
      });
    });

    group('fromEntity', () {
      test('should correctly convert from Pet entity with all fields', () {
        final entity = Pet(
          id: '123',
          name: 'Buddy',
          type: PetType.dog,
          breed: 'Golden Retriever',
          birthDate: birthDate,
          photoPath: '/path/to/photo.jpg',
          createdAt: now,
          updatedAt: now,
        );

        final model = PetModel.fromEntity(entity);

        expect(model.id, '123');
        expect(model.name, 'Buddy');
        expect(model.type, 'dog');
        expect(model.breed, 'Golden Retriever');
        expect(model.birthDate, birthDate);
        expect(model.photoPath, '/path/to/photo.jpg');
        expect(model.createdAt, now);
        expect(model.updatedAt, now);
      });

      test('should correctly convert PetType to string', () {
        final dogEntity = Pet(
          id: '1',
          name: 'Dog',
          type: PetType.dog,
          createdAt: now,
          updatedAt: now,
        );
        expect(PetModel.fromEntity(dogEntity).type, 'dog');

        final catEntity = Pet(
          id: '2',
          name: 'Cat',
          type: PetType.cat,
          createdAt: now,
          updatedAt: now,
        );
        expect(PetModel.fromEntity(catEntity).type, 'cat');

        final otherEntity = Pet(
          id: '3',
          name: 'Other',
          type: PetType.other,
          createdAt: now,
          updatedAt: now,
        );
        expect(PetModel.fromEntity(otherEntity).type, 'other');
      });
    });

    group('Round-trip conversion', () {
      test('should maintain data integrity through JSON round-trip', () {
        final originalModel = PetModel(
          id: '123',
          name: 'Buddy',
          type: 'dog',
          breed: 'Golden Retriever',
          birthDate: birthDate,
          photoPath: '/path/to/photo.jpg',
          createdAt: now,
          updatedAt: now,
        );

        final json = originalModel.toJson();
        final reconstructedModel = PetModel.fromJson(json);

        expect(reconstructedModel, originalModel);
      });

      test('should maintain data integrity through entity round-trip', () {
        final originalEntity = Pet(
          id: '123',
          name: 'Buddy',
          type: PetType.dog,
          breed: 'Golden Retriever',
          birthDate: birthDate,
          photoPath: '/path/to/photo.jpg',
          createdAt: now,
          updatedAt: now,
        );

        final model = PetModel.fromEntity(originalEntity);
        final reconstructedEntity = model.toEntity();

        expect(reconstructedEntity, originalEntity);
      });
    });

    group('Equality', () {
      test('should be equal when all fields are the same', () {
        final model1 = PetModel(
          id: '123',
          name: 'Buddy',
          type: 'dog',
          createdAt: now,
          updatedAt: now,
        );
        final model2 = PetModel(
          id: '123',
          name: 'Buddy',
          type: 'dog',
          createdAt: now,
          updatedAt: now,
        );

        expect(model1, model2);
        expect(model1.hashCode, model2.hashCode);
      });

      test('should not be equal when fields differ', () {
        final model1 = PetModel(
          id: '123',
          name: 'Buddy',
          type: 'dog',
          createdAt: now,
          updatedAt: now,
        );
        final model2 = PetModel(
          id: '123',
          name: 'Max',
          type: 'dog',
          createdAt: now,
          updatedAt: now,
        );

        expect(model1, isNot(model2));
      });
    });
  });
}
