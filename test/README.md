# FlavorFetch Tests

This directory contains tests for the FlavorFetch application.

## Test Organization

```
test/
├── unit/           # Unit tests for models, repositories, services
├── widget/         # Widget tests for UI components
└── integration/    # End-to-end integration tests
```

## Current Test Coverage (Sprint 1)

### Unit Tests

#### Completed
- `unit/pet_entity_test.dart` - Tests for Pet entity including:
  - Entity creation and field validation
  - Age calculation logic (ageInMonths and ageDisplayString)
  - copyWith functionality
  - Equality comparisons
  - PetType enum display names

- `unit/pet_model_test.dart` - Tests for PetModel including:
  - JSON serialization (fromJson/toJson)
  - Entity conversion (toEntity/fromEntity)
  - Round-trip conversions
  - Equality comparisons

#### To Be Added
- `unit/pet_repository_test.dart` - Tests for PetRepositoryImpl
- `unit/pet_provider_test.dart` - Tests for PetProvider state management
- `unit/database_service_test.dart` - Tests for DatabaseService
- `unit/photo_service_test.dart` - Tests for PhotoService

### Widget Tests

#### To Be Added
- `widget/pet_list_screen_test.dart` - Tests for PetListScreen
- `widget/pet_form_screen_test.dart` - Tests for PetFormScreen
- `widget/pet_detail_screen_test.dart` - Tests for PetDetailScreen
- `widget/pet_card_test.dart` - Tests for PetCard widget
- `widget/photo_picker_test.dart` - Tests for PhotoPicker widget
- `widget/empty_state_test.dart` - Tests for EmptyState widget

### Integration Tests

#### To Be Added
- `integration/pet_crud_test.dart` - End-to-end CRUD flow tests

## Running Tests

```bash
# Run all tests
flutter test

# Run unit tests only
flutter test test/unit/

# Run widget tests only
flutter test test/widget/

# Run integration tests
flutter test test/integration/

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/unit/pet_entity_test.dart
```

## Test Coverage Goals

- **Unit Tests**: 80%+ coverage for data and domain layers
- **Widget Tests**: All key UI components and screens
- **Integration Tests**: Critical user flows

## Notes

- The initial Sprint 1 implementation includes core unit tests for entities and models
- Additional tests for repositories, providers, and widgets should be added to achieve 80%+ coverage
- Mock objects using the `mockito` package should be used for testing components with dependencies
