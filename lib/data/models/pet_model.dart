import '../../domain/entities/pet.dart';

/// Data model for Pet entity with JSON serialization support.
///
/// This model handles conversion between the database/API representation
/// and the domain entity.
class PetModel {
  final String id;
  final String name;
  final String type;
  final String? breed;
  final DateTime? birthDate;
  final String? photoPath;
  final DateTime createdAt;
  final DateTime updatedAt;

  PetModel({
    required this.id,
    required this.name,
    required this.type,
    this.breed,
    this.birthDate,
    this.photoPath,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Creates a PetModel from a JSON map (from SQLite or API).
  factory PetModel.fromJson(Map<String, dynamic> json) {
    return PetModel(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      breed: json['breed'] as String?,
      birthDate: json['birth_date'] != null
          ? DateTime.parse(json['birth_date'] as String)
          : null,
      photoPath: json['photo_path'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Converts this model to a JSON map (for SQLite or API).
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'breed': breed,
      'birth_date': birthDate?.toIso8601String(),
      'photo_path': photoPath,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Converts this model to a domain entity.
  Pet toEntity() {
    return Pet(
      id: id,
      name: name,
      type: PetType.values.firstWhere((e) => e.name == type),
      breed: breed,
      birthDate: birthDate,
      photoPath: photoPath,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Creates a PetModel from a domain entity.
  factory PetModel.fromEntity(Pet pet) {
    return PetModel(
      id: pet.id,
      name: pet.name,
      type: pet.type.name,
      breed: pet.breed,
      birthDate: pet.birthDate,
      photoPath: pet.photoPath,
      createdAt: pet.createdAt,
      updatedAt: pet.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PetModel &&
        other.id == id &&
        other.name == name &&
        other.type == type &&
        other.breed == breed &&
        other.birthDate == birthDate &&
        other.photoPath == photoPath &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      type,
      breed,
      birthDate,
      photoPath,
      createdAt,
      updatedAt,
    );
  }
}
