/// Pet entity representing a pet in the application.
///
/// This is the core business entity for pet management, containing
/// all pet-related information and business logic.
class Pet {
  /// Unique identifier for the pet
  final String id;

  /// Name of the pet (required, max 50 characters)
  final String name;

  /// Type of pet (dog, cat, or other)
  final PetType type;

  /// Optional breed information
  final String? breed;

  /// Optional birth date for age calculation
  final DateTime? birthDate;

  /// Optional path to pet's photo in local storage
  final String? photoPath;

  /// Timestamp when the pet was created
  final DateTime createdAt;

  /// Timestamp when the pet was last updated
  final DateTime updatedAt;

  Pet({
    required this.id,
    required this.name,
    required this.type,
    this.breed,
    this.birthDate,
    this.photoPath,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Calculates the pet's age in months.
  ///
  /// Returns null if birthDate is not set.
  /// Returns negative values for future birth dates (edge case).
  int? get ageInMonths {
    if (birthDate == null) return null;
    final now = DateTime.now();
    return (now.year - birthDate!.year) * 12 + now.month - birthDate!.month;
  }

  /// Returns a human-readable age string.
  ///
  /// Examples:
  /// - "Age unknown" if no birth date
  /// - "5 months" if less than 12 months
  /// - "1 year" or "3 years" if 12+ months
  String get ageDisplayString {
    final months = ageInMonths;
    if (months == null) return 'Age unknown';
    if (months < 0) return 'Age unknown'; // Handle future dates
    if (months < 12) return '$months ${months == 1 ? 'month' : 'months'}';
    final years = months ~/ 12;
    return '$years ${years == 1 ? 'year' : 'years'}';
  }

  /// Creates a copy of this pet with updated fields.
  Pet copyWith({
    String? id,
    String? name,
    PetType? type,
    String? breed,
    DateTime? birthDate,
    String? photoPath,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Pet(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      breed: breed ?? this.breed,
      birthDate: birthDate ?? this.birthDate,
      photoPath: photoPath ?? this.photoPath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Pet &&
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

/// Enum representing the type of pet.
enum PetType {
  /// Dog
  dog,

  /// Cat
  cat,

  /// Other type of pet
  other;

  /// Returns a user-friendly display name for the pet type.
  String get displayName => switch (this) {
        PetType.dog => 'Dog',
        PetType.cat => 'Cat',
        PetType.other => 'Other',
      };

  /// Returns an icon name suggestion for the pet type.
  String get iconName => switch (this) {
        PetType.dog => 'pets',
        PetType.cat => 'pets',
        PetType.other => 'pets',
      };
}
