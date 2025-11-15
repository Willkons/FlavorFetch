# Sprint 0: Project Setup, Dev Container, and CI/CD

**Duration:** Week 1
**Status:** Not Started
**Dependencies:** None

## Overview

Sprint 0 establishes the foundational infrastructure for the FlavorFetch project, including development environment setup, project scaffolding, and automated testing/deployment pipelines.

## Goals

1. Set up Flutter project structure with proper architecture
2. Configure VS Code Dev Container for consistent development environment
3. Establish CI/CD pipeline with GitHub Actions
4. Configure code quality tools and linting
5. Set up testing infrastructure
6. Create initial documentation

## User Stories

### US-0.1: Development Environment Setup
**As a** developer
**I want** a consistent development environment using Dev Containers
**So that** all team members work with identical tooling and dependencies

**Acceptance Criteria:**
- Dev container configuration file exists at `.devcontainer/devcontainer.json`
- Container includes Flutter stable, Dart SDK, and required extensions
- Container starts successfully and runs `flutter doctor` without errors
- VS Code extensions are automatically installed (Dart, Flutter, GitLens)
- Documentation exists for both dev container and local development setup

### US-0.2: Project Scaffolding
**As a** developer
**I want** a well-organized Flutter project structure
**So that** code is maintainable and follows best practices

**Acceptance Criteria:**
- Flutter project created with `flutter create flavor_fetch`
- Directory structure follows layered architecture pattern (presentation/domain/data)
- Core utilities folder created with theme, constants, and extensions
- Main app entry point configured with proper MaterialApp setup
- Placeholder screens created for future navigation
- Package dependencies added to `pubspec.yaml` (sqflite, provider, dio, mobile_scanner, etc.)

### US-0.3: Code Quality Configuration
**As a** developer
**I want** automated code quality checks
**So that** code maintains consistent style and quality standards

**Acceptance Criteria:**
- `analysis_options.yaml` configured with flutter_lints plus custom rules
- Line length set to 100 characters
- Dart formatter configured with trailing commas enabled
- Pre-commit hooks configured (optional but recommended)
- All existing code passes `flutter analyze` without errors
- All existing code formatted with `dart format`

### US-0.4: Testing Infrastructure
**As a** developer
**I want** a testing framework ready for TDD
**So that** I can write tests before implementing features

**Acceptance Criteria:**
- Test directories created: `test/unit/`, `test/widget/`, `test/integration/`
- Test coverage tooling configured
- Sample unit test, widget test, and integration test created as templates
- `flutter test` command runs successfully
- Coverage reports can be generated with `flutter test --coverage`
- Mock data helpers created in `test/helpers/`

### US-0.5: CI/CD Pipeline
**As a** developer
**I want** automated testing and builds on every commit
**So that** issues are caught early and releases are streamlined

**Acceptance Criteria:**
- GitHub Actions workflow file created at `.github/workflows/ci.yml`
- CI runs on pull requests and pushes to main/develop branches
- CI pipeline includes:
  - Code formatting check (`dart format --set-exit-if-changed`)
  - Static analysis (`flutter analyze`)
  - Unit and widget tests (`flutter test`)
  - Build check for Android (`flutter build apk --debug`)
- CD workflow created for releases (tags trigger production builds)
- Build artifacts uploaded for tagged releases
- Status badges added to README.md

### US-0.6: Documentation
**As a** developer or contributor
**I want** comprehensive project documentation
**So that** I can understand and contribute to the project effectively

**Acceptance Criteria:**
- README.md includes project overview, setup instructions, and contribution guidelines
- CLAUDE.md exists with AI assistant guidance (already exists, verify completeness)
- LICENSE file added (MIT or appropriate open-source license)
- CONTRIBUTING.md created with PR guidelines and code standards
- Architecture documentation in `docs/architecture.md`
- API integration guide in `docs/api-integration.md`

## Technical Specifications

### Dev Container Configuration

**File:** `.devcontainer/devcontainer.json`

```json
{
  "name": "FlavorFetch Flutter Development",
  "image": "ghcr.io/cirruslabs/flutter:stable",
  "customizations": {
    "vscode": {
      "extensions": [
        "Dart-Code.dart-code",
        "Dart-Code.flutter",
        "eamodio.gitlens",
        "usernamehw.errorlens",
        "ms-azuretools.vscode-docker"
      ],
      "settings": {
        "dart.lineLength": 100,
        "editor.formatOnSave": true,
        "editor.rulers": [100]
      }
    }
  },
  "postCreateCommand": "flutter pub get && flutter doctor",
  "forwardPorts": [],
  "remoteUser": "root"
}
```

### Project Dependencies

**Required packages in `pubspec.yaml`:**

```yaml
dependencies:
  flutter:
    sdk: flutter

  # State Management
  provider: ^6.1.1

  # Local Database
  sqflite: ^2.3.0
  path_provider: ^2.1.1
  path: ^1.8.3

  # HTTP & API
  dio: ^5.4.0

  # Barcode Scanning
  mobile_scanner: ^3.5.5

  # Image Handling
  image_picker: ^1.0.5

  # UI Components
  intl: ^0.18.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.1
  build_runner: ^2.4.6
  mockito: ^5.4.4
```

### Directory Structure

```
FlavorFetch/
├── .devcontainer/
│   └── devcontainer.json
├── .github/
│   └── workflows/
│       ├── ci.yml
│       └── cd.yml
├── android/
├── ios/
├── lib/
│   ├── main.dart
│   ├── app.dart
│   ├── core/
│   │   ├── constants/
│   │   │   └── app_constants.dart
│   │   ├── theme/
│   │   │   ├── app_theme.dart
│   │   │   ├── colors.dart
│   │   │   └── text_styles.dart
│   │   ├── utils/
│   │   └── extensions/
│   ├── data/
│   │   ├── models/
│   │   ├── repositories/
│   │   └── services/
│   ├── domain/
│   │   ├── entities/
│   │   └── repositories/
│   ├── presentation/
│   │   ├── screens/
│   │   │   └── home/
│   │   ├── widgets/
│   │   └── providers/
│   └── config/
│       └── routes.dart
├── test/
│   ├── unit/
│   ├── widget/
│   ├── integration/
│   └── helpers/
│       └── test_data.dart
├── docs/
│   ├── dev-plan.md
│   ├── architecture.md
│   ├── api-integration.md
│   └── specs/
├── .gitignore
├── analysis_options.yaml
├── pubspec.yaml
├── README.md
├── CLAUDE.md
├── LICENSE
└── CONTRIBUTING.md
```

### CI/CD Pipeline Configuration

**File:** `.github/workflows/ci.yml`

```yaml
name: CI

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v3

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.x'
          channel: 'stable'

      - name: Install dependencies
        run: flutter pub get

      - name: Verify formatting
        run: dart format --set-exit-if-changed .

      - name: Analyze code
        run: flutter analyze

      - name: Run tests
        run: flutter test --coverage

      - name: Upload coverage
        uses: codecov/codecov-action@v3
        with:
          file: coverage/lcov.info

      - name: Build APK
        run: flutter build apk --debug
```

### Analysis Options

**File:** `analysis_options.yaml`

```yaml
include: package:flutter_lints/flutter.yaml

analyzer:
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"

  errors:
    invalid_annotation_target: ignore

linter:
  rules:
    - prefer_const_constructors
    - prefer_const_literals_to_create_immutables
    - prefer_final_fields
    - avoid_print
    - avoid_unnecessary_containers
    - sized_box_for_whitespace
    - use_key_in_widget_constructors
    - prefer_single_quotes
    - require_trailing_commas
```

## Testing Requirements

### Unit Tests
- Test data models serialization/deserialization
- Test utility functions and extensions
- Mock repository implementations for testing

### Widget Tests
- Test placeholder home screen renders
- Test theme application (light/dark mode)
- Test navigation routing

### Integration Tests
- App starts without crashes
- Navigation between placeholder screens works

## Definition of Done

- [ ] Dev container configuration complete and tested
- [ ] Project structure created following architecture guidelines
- [ ] All dependencies installed and verified
- [ ] Code quality tools configured (linter, formatter)
- [ ] Testing infrastructure ready with example tests
- [ ] CI/CD pipeline running successfully on GitHub
- [ ] Documentation complete (README, CONTRIBUTING, architecture docs)
- [ ] `flutter doctor` shows no errors
- [ ] `flutter analyze` passes without warnings
- [ ] `flutter test` runs successfully
- [ ] All code formatted according to style guide
- [ ] Sprint 0 tagged and documented

## Dependencies and Blockers

**Dependencies:**
- None (foundational sprint)

**Potential Blockers:**
- GitHub Actions quota limits
- Flutter version compatibility issues
- Dev container Docker resource requirements

## Notes

- This sprint does not include UI implementation beyond placeholder screens
- Focus on infrastructure over features
- Ensure all team members can successfully build and run the project
- Document any platform-specific setup requirements (especially for iOS development)
- Consider adding optional tools: flutter_launcher_icons, flutter_native_splash

## Resources

- [Flutter Dev Container Examples](https://github.com/cirruslabs/docker-images-flutter)
- [GitHub Actions for Flutter](https://docs.flutter.dev/deployment/cd#github-actions)
- [Flutter Project Structure Best Practices](https://docs.flutter.dev/development/tools/sdk/release-notes)
