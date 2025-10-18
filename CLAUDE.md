# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**FlavorFetch** is an open-source Flutter application for tracking pet food preferences. It enables multi-pet households to scan barcodes, log feeding sessions, rate pet reactions, and analyze food preferences over time.

**Technology Stack:** Flutter 3.x, Dart, SQLite (sqflite), Provider/Riverpod for state management, mobile_scanner for barcode scanning, dio for HTTP, Open Food Facts API integration.

**Project Status:** Early development phase - currently in specification and planning stage. The development plan has been created but implementation has not yet begun.

## Development Environment

### Dev Container Setup (Preferred)
The project is designed to use VS Code Dev Containers for consistent development environments:
- Base image: `ghcr.io/cirruslabs/flutter:stable`
- Configuration will be in `.devcontainer/devcontainer.json` (not yet created)
- Requires Docker Desktop and VS Code Dev Containers extension

### Local Development (Alternative)
If not using dev containers:
```bash
# Verify Flutter installation
flutter doctor

# Install dependencies
flutter pub get

# Run code generation (if using build_runner)
flutter pub run build_runner build --delete-conflicting-outputs

# Run the app
flutter run
```

## Common Commands

### Development
```bash
# Format code (line length: 100 characters)
dart format lib/

# Analyze code for issues
flutter analyze

# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test file
flutter test test/unit/pet_repository_test.dart

# Watch mode for code generation
flutter pub run build_runner watch

# Hot reload during development
# Press 'r' in terminal where app is running

# Check device logs
flutter logs
```

### Building
```bash
# Build Android APK
flutter build apk --release

# Build Android App Bundle
flutter build appbundle --release

# Build iOS (requires macOS)
flutter build ios --release
```

## Architecture

### Layered Architecture Pattern

**Presentation Layer** (`lib/presentation/`)
- Screens and widgets
- State management with Provider/Riverpod
- UI logic only, no business logic

**Domain Layer** (`lib/domain/`)
- Business logic and use cases
- Entity definitions
- Repository interfaces (contracts)

**Data Layer** (`lib/data/`)
- Repository implementations
- Data sources: SQLite database (local) and Open Food Facts API (remote)
- Data models with JSON serialization

### Project Structure
```
lib/
├── main.dart
├── app.dart
├── core/                   # Shared utilities, constants, theme
│   ├── constants/
│   ├── theme/
│   ├── utils/
│   └── extensions/
├── data/                   # Data layer
│   ├── models/            # Data models with serialization
│   ├── repositories/      # Repository implementations
│   └── services/          # Database, API, storage services
├── domain/                # Business logic layer
│   ├── entities/          # Business entities
│   └── repositories/      # Repository interfaces
├── presentation/          # UI layer
│   ├── screens/
│   │   ├── pet_list/
│   │   ├── scanner/
│   │   ├── feeding_log/
│   │   └── analytics/
│   ├── widgets/           # Reusable UI components
│   └── providers/         # State management providers
└── config/
    └── routes.dart        # Navigation configuration
```

### Core Data Models

**Pet Model**: Represents a pet with id, name, photo, breed, birth date, type (cat/dog/other)
- Primary entity for the application
- Photos stored locally with path references

**Product Model**: Pet food products from barcode scans
- Fetched from Open Food Facts API
- Cached locally in SQLite for offline access
- Includes barcode, name, brand, ingredients, flavor profile, nutrition facts

**FeedingLog Model**: Tracks feeding sessions
- Links pets to products with timestamps
- Includes preference ratings: love, like, neutral, dislike
- Optional notes field for user observations

### Database Schema

SQLite database with three main tables:
- `pets`: Pet profiles
- `products`: Scanned product information (cached from API)
- `feeding_logs`: Feeding session records with ratings

Key indexes:
- `idx_feeding_logs_pet_id`: For pet-specific queries
- `idx_feeding_logs_product`: For product analysis
- `idx_feeding_logs_date`: For chronological queries

### State Management

Uses **Provider** pattern (may switch to Riverpod):
- Each feature has a dedicated Provider (e.g., PetProvider, FeedingLogProvider)
- Providers use ChangeNotifier for reactive updates
- Repository pattern for data access separation
- Providers handle loading states, errors, and data caching

### API Integration

**Open Food Facts API**: `https://world.openfoodfacts.org/api/v2`
- Product lookup: `GET /api/v2/product/{barcode}`
- Product search: `GET /api/v2/search?search_terms={query}&categories=pet-food`
- Service class: `OpenFoodFactsService` in `lib/data/services/`
- Offline-first: Cache all fetched products in local database

## Development Workflow

### Spec-Driven Development
This project follows specification-driven development:
1. Features are specified in detail before implementation (see `docs/specs/`)
2. Write tests based on specifications
3. Implement features to pass tests
4. Refactor and document

### Git Workflow
- **Main branch**: `main` (production-ready)
- **Integration branch**: `develop`
- **Feature branches**: `feature/feature-name`
- **Bug fixes**: `bugfix/issue-description`

### Commit Message Convention
```
type(scope): subject

Types: feat, fix, docs, style, refactor, test, chore
Example: feat(scanner): add barcode scanning with camera
```

### Code Quality
- Line length: 100 characters
- Use trailing commas for better formatting
- Run `dart format .` before committing
- Lint configuration: Uses `package:flutter_lints/flutter.yaml` with additional rules
- Test coverage target: 80%+

## Sprint Plan

The project is organized into sprints:
- **Sprint 0**: Project setup, dev container, CI/CD (Week 1)
- **Sprint 1**: Pet management CRUD (Week 2-3)
- **Sprint 2**: Barcode scanner & product integration (Week 4-5)
- **Sprint 3**: Feeding log functionality (Week 6-7)
- **Sprint 4**: Analytics dashboard (Week 8-9)
- **Sprint 5**: Data export & polish (Week 10)

See `docs/dev-plan.md` for detailed sprint goals and acceptance criteria.

## Testing Strategy

### Test Organization
```
test/
├── unit/          # Unit tests for models, repositories, services
├── widget/        # Widget tests for UI components
└── integration/   # End-to-end integration tests
```

### Test Coverage Requirements
- Unit tests: 80%+ coverage for data and domain layers
- Widget tests: All key UI components and screens
- Integration tests: Critical user flows (scan → log → view analytics)

### Running Tests
```bash
# All tests
flutter test

# Unit tests only
flutter test test/unit/

# Widget tests only
flutter test test/widget/

# Integration tests
flutter drive --target=test_driver/app.dart

# With coverage report
flutter test --coverage
```

## Important Development Notes

### When Creating New Features
1. Check if a specification exists in `docs/specs/`
2. If no spec exists, create one following the template in `docs/dev-plan.md` Appendix B
3. Write tests before implementation (TDD approach)
4. Follow the layered architecture pattern
5. Update relevant documentation

### Database Migrations
- SQLite schema is defined in database service
- For schema changes, implement version migration logic
- Test migrations with existing data

### API Integration
- Always handle network errors gracefully
- Implement proper caching strategy for offline access
- Don't spam the Open Food Facts API - respect rate limits
- Manual product entry should be available as fallback

### State Management
- Keep providers focused and single-responsibility
- Avoid business logic in UI layer
- Use repository pattern for all data access
- Handle loading, success, and error states consistently

### UI/UX Considerations
- Support both light and dark themes
- Ensure accessibility compliance
- Test on both Android and iOS
- Consider tablet layouts for larger screens
- Provide meaningful error messages to users

## Key Resources

- **Development Plan**: [docs/dev-plan.md](docs/dev-plan.md) - Comprehensive development guide with architecture details, sprint planning, and specifications
- **Flutter Docs**: https://docs.flutter.dev/
- **Open Food Facts API**: https://world.openfoodfacts.org/data
- **SQLite Flutter Guide**: https://docs.flutter.dev/cookbook/persistence/sqlite
