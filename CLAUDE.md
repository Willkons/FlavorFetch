# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) and other AI assistants when working with code in this repository.

## Project Overview

**FlavorFetch** is an open-source Flutter application for tracking pet food preferences. It enables multi-pet households to scan barcodes, log feeding sessions, rate pet reactions, and analyze food preferences over time.

**Technology Stack:** Flutter 3.x, Dart, SQLite (sqflite), Provider/Riverpod for state management, mobile_scanner for barcode scanning, dio for HTTP, Open Food Facts API integration.

**Project Status (as of November 15, 2025):** Planning phase complete, implementation not yet started.

## Current Repository State

### What Exists
- ✅ **Comprehensive specifications** for all 6 sprints (Sprint 0-5) in `docs/specs/`
- ✅ **Development plan** with detailed architecture in `docs/dev-plan.md`
- ✅ **Git repository** with `main` and `develop` branches
- ✅ **License** (Apache 2.0) and **README**
- ✅ **Flutter-specific .gitignore** configuration

### What Needs to Be Created
- ❌ Flutter project scaffolding (`flutter create` not yet run)
- ❌ `pubspec.yaml` with dependencies
- ❌ Source code directories (`lib/`, `test/`, etc.)
- ❌ Dev container configuration (`.devcontainer/`)
- ❌ CI/CD pipeline configuration
- ❌ Any implementation code

### Next Steps for Implementation
1. **Start with Sprint 0** (see `docs/specs/sprint-0-setup.md`)
2. Initialize Flutter project structure
3. Set up dev container environment
4. Configure dependencies in pubspec.yaml
5. Set up CI/CD pipeline
6. Begin Sprint 1 implementation

## AI Assistant Guidelines

### Before Starting Any Implementation
1. **Read the specification first**: Always check `docs/specs/` for the relevant sprint spec
2. **Follow spec-driven development**: Specifications are authoritative - implement what's specified
3. **Check acceptance criteria**: Each spec has clear acceptance criteria that must be met
4. **Review architecture**: Understand the layered architecture pattern before coding

### When Implementing Features
1. **Start with tests**: Write unit tests based on specifications before implementation (TDD)
2. **Follow the structure**: Adhere to the defined project structure (presentation/domain/data layers)
3. **One feature at a time**: Complete one user story/feature before moving to the next
4. **Update documentation**: If implementation differs from specs, update the specs and this file

### Code Quality Standards
- **Formatting**: Line length 100 characters, use trailing commas
- **Linting**: Follow `package:flutter_lints/flutter.yaml` rules
- **Testing**: Maintain 80%+ test coverage for data and domain layers
- **Documentation**: Add dartdoc comments for public APIs
- **Error handling**: Always handle errors gracefully with user-friendly messages

### Common Patterns to Follow
- **Repository pattern**: All data access goes through repositories
- **Provider for state**: Use Provider/Riverpod, not setState in business logic
- **Offline-first**: Cache API responses in SQLite for offline access
- **Loading states**: Handle loading, success, and error states consistently across UI

## Specification Documents

All feature specifications are located in `docs/specs/`. Each sprint has a detailed specification document:

### Sprint 0: Project Setup (`sprint-0-setup.md`)
**Goal**: Establish development infrastructure
- Flutter project initialization
- Dev container configuration
- CI/CD pipeline (GitHub Actions)
- Linting and code quality tools
- **Start here** if beginning implementation

### Sprint 1: Pet Management (`sprint-1-pet-management.md`)
**Goal**: Core pet profile CRUD operations
- Pet model and database schema
- Pet list screen with add/edit/delete
- Photo capture and storage
- Pet repository with SQLite
- Comprehensive unit and widget tests

### Sprint 2: Barcode Scanner (`sprint-2-barcode-scanner.md`)
**Goal**: Barcode scanning and product integration
- Camera-based barcode scanner
- Open Food Facts API integration
- Product caching in SQLite
- Manual product entry fallback
- Error handling for API failures

### Sprint 3: Feeding Logs (`sprint-3-feeding-logs.md`)
**Goal**: Track feeding sessions and ratings
- Feeding log data model
- Log entry creation with pet/product selection
- Preference rating system (Love/Like/Neutral/Dislike)
- Feeding history view
- Edit and delete functionality

### Sprint 4: Analytics Dashboard (`sprint-4-analytics.md`)
**Goal**: Visualize preference trends
- Analytics screen with charts
- Brand preference analysis
- Flavor/ingredient analysis
- Protein source preferences
- Time-based trend visualization

### Sprint 5: Data Export & Polish (`sprint-5-polish.md`)
**Goal**: Export functionality and UI polish
- Export to JSON/CSV formats
- Import data functionality
- UI/UX improvements
- Performance optimization
- App icon and splash screen

### Specification Structure
Each spec includes:
- **User Stories**: What users need to accomplish
- **Technical Requirements**: Detailed implementation requirements
- **Acceptance Criteria**: Testable conditions for completion
- **Data Models**: Exact field definitions
- **UI Mockups/Descriptions**: Visual guidance
- **Testing Requirements**: What must be tested

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

### Security & Privacy Considerations
- **No authentication required**: App is local-first, no user accounts
- **Local data only**: All pet and feeding data stored in local SQLite database
- **API keys**: Open Food Facts API is public, no keys required
- **Photo storage**: Pet photos stored in app's local directory
- **No sensitive data**: App doesn't handle payment info or personal identification
- **Future cloud sync**: When implemented, use OAuth 2.0 for Dropbox/Drive (Sprint 6+)

### Performance Best Practices
- **Lazy loading**: Load images and data on demand
- **Database indexing**: Use indexes for frequently queried columns
- **Caching**: Cache API responses to reduce network calls
- **Image optimization**: Compress photos before storage
- **Pagination**: Implement for long lists (feeding logs, analytics)

### Accessibility Requirements
- **Screen reader support**: Provide semantic labels for all interactive elements
- **Color contrast**: Meet WCAG AA standards (4.5:1 for text)
- **Touch targets**: Minimum 48x48dp for interactive elements
- **Text scaling**: Support dynamic text sizing
- **Navigation**: Ensure keyboard navigation works (for web/desktop)

## Quick Reference for AI Assistants

### Starting a New Sprint Implementation
```bash
# 1. Read the sprint specification
cat docs/specs/sprint-X-name.md

# 2. Create feature branch
git checkout develop
git pull origin develop
git checkout -b feature/sprint-X-name

# 3. Follow TDD: Write tests first, then implement
# 4. Commit regularly with conventional commit messages
# 5. Push and create PR when ready
```

### Adding a New Dependency
```yaml
# In pubspec.yaml, add under dependencies:
dependencies:
  flutter:
    sdk: flutter
  package_name: ^version  # Add here

# Then run:
flutter pub get
```

### Creating a New Feature Following Architecture
```
1. Domain Layer (lib/domain/)
   - Create entity class (e.g., pet.dart)
   - Create repository interface (e.g., pet_repository.dart)

2. Data Layer (lib/data/)
   - Create data model with serialization (e.g., pet_model.dart)
   - Implement repository (e.g., pet_repository_impl.dart)
   - Create/update database service if needed

3. Presentation Layer (lib/presentation/)
   - Create provider for state management
   - Create screen widgets
   - Create reusable components

4. Tests (test/)
   - Unit tests for repositories and services
   - Widget tests for UI components
   - Integration tests for user flows
```

### Common Troubleshooting

**Issue**: `flutter` command not found
- **Solution**: Install Flutter SDK or ensure it's in PATH

**Issue**: Dependencies not resolving
- **Solution**: `flutter pub get` or `flutter pub upgrade`

**Issue**: Build errors after adding dependencies
- **Solution**: `flutter clean && flutter pub get`

**Issue**: Tests failing
- **Solution**: Check test coverage with `flutter test --coverage` and review specs

**Issue**: Hot reload not working
- **Solution**: Try hot restart (Shift+R) or full rebuild

## Key Resources

- **Development Plan**: [docs/dev-plan.md](docs/dev-plan.md) - Comprehensive development guide with architecture details, sprint planning, and specifications
- **Sprint Specifications**: [docs/specs/](docs/specs/) - Detailed specifications for each sprint
- **Specification Index**: [docs/specs/README.md](docs/specs/README.md) - Overview of all specifications
- **Flutter Docs**: https://docs.flutter.dev/
- **Open Food Facts API**: https://world.openfoodfacts.org/data
- **SQLite Flutter Guide**: https://docs.flutter.dev/cookbook/persistence/sqlite
- **Provider Package**: https://pub.dev/packages/provider
- **Mobile Scanner Package**: https://pub.dev/packages/mobile_scanner

---

**Last Updated**: November 15, 2025
**For Questions**: Refer to specs in `docs/specs/` or development plan in `docs/dev-plan.md`
