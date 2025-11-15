# Contributing to FlavorFetch

Thank you for your interest in contributing to FlavorFetch! This document provides guidelines and instructions for contributing to the project.

## Code of Conduct

This project is committed to providing a welcoming and inclusive environment. Please be respectful and constructive in all interactions.

## Getting Started

### Prerequisites

- Flutter 3.x or higher
- Dart SDK 3.0 or higher
- Git
- VS Code (recommended) with Dev Containers extension
- Docker Desktop (if using dev containers)

### Development Setup

#### Using Dev Container (Recommended)

1. Clone the repository:
   ```bash
   git clone https://github.com/Willkons/FlavorFetch.git
   cd FlavorFetch
   ```

2. Open in VS Code and reopen in container when prompted
3. Wait for container to build and dependencies to install
4. Run `flutter doctor` to verify setup

#### Local Development

1. Clone the repository
2. Install Flutter dependencies:
   ```bash
   flutter pub get
   ```
3. Verify installation:
   ```bash
   flutter doctor
   ```

## Development Workflow

### Branch Strategy

- `main` - Production-ready code
- `develop` - Integration branch for features
- `feature/feature-name` - New features
- `bugfix/issue-description` - Bug fixes
- `hotfix/critical-fix` - Critical production fixes

### Making Changes

1. Create a feature branch from `develop`:
   ```bash
   git checkout develop
   git pull origin develop
   git checkout -b feature/your-feature-name
   ```

2. Make your changes following the code style guide

3. Write or update tests for your changes

4. Run code quality checks:
   ```bash
   dart format .
   flutter analyze
   flutter test
   ```

5. Commit your changes with a descriptive message:
   ```bash
   git commit -m "feat(scope): description of changes"
   ```

6. Push to your branch:
   ```bash
   git push -u origin feature/your-feature-name
   ```

7. Create a pull request to `develop`

### Commit Message Convention

Follow the Conventional Commits specification:

```
type(scope): subject

[optional body]

[optional footer]
```

**Types:**
- `feat` - New feature
- `fix` - Bug fix
- `docs` - Documentation changes
- `style` - Code formatting (no functional changes)
- `refactor` - Code refactoring
- `test` - Adding or updating tests
- `chore` - Maintenance tasks

**Examples:**
```
feat(scanner): add barcode scanning functionality
fix(database): correct pet deletion cascade
docs(readme): update installation instructions
test(pet): add unit tests for pet repository
```

## Code Style Guide

### Dart/Flutter Guidelines

- **Line length**: Maximum 100 characters
- **Formatting**: Use `dart format` before committing
- **Linting**: Follow rules in `analysis_options.yaml`
- **Quotes**: Prefer single quotes for strings
- **Trailing commas**: Required for better formatting

### Project Structure

Follow the layered architecture pattern:

```
lib/
├── presentation/  # UI layer (screens, widgets, providers)
├── domain/        # Business logic layer (entities, repository interfaces)
├── data/          # Data layer (models, repository implementations, services)
├── core/          # Shared utilities (theme, constants, extensions)
└── config/        # App configuration (routes, etc.)
```

### Naming Conventions

- **Files**: `snake_case.dart`
- **Classes**: `PascalCase`
- **Variables/Functions**: `camelCase`
- **Constants**: `camelCase` or `SCREAMING_SNAKE_CASE` for compile-time constants
- **Private members**: Prefix with `_`

## Testing

### Test Requirements

- **Unit tests**: 80%+ coverage for data and domain layers
- **Widget tests**: All key UI components and screens
- **Integration tests**: Critical user flows

### Running Tests

```bash
# All tests
flutter test

# Specific test file
flutter test test/unit/pet_repository_test.dart

# With coverage
flutter test --coverage

# Widget tests only
flutter test test/widget/
```

### Writing Tests

- Follow the AAA pattern: Arrange, Act, Assert
- Use descriptive test names
- Mock external dependencies
- Test edge cases and error scenarios

Example:
```dart
test('should return pet when database query succeeds', () async {
  // Arrange
  when(mockDatabase.query(any)).thenAnswer((_) async => [petData]);

  // Act
  final result = await repository.getPetById(1);

  // Assert
  expect(result.name, 'Fluffy');
});
```

## Pull Request Process

1. **Update documentation** if you've changed APIs or added features
2. **Add tests** for new functionality
3. **Ensure all CI checks pass** (formatting, linting, tests, build)
4. **Update CHANGELOG.md** if applicable
5. **Request review** from maintainers
6. **Address review feedback** promptly

### PR Checklist

- [ ] Code follows the style guide
- [ ] All tests pass
- [ ] New tests added for new features
- [ ] Documentation updated
- [ ] Commit messages follow convention
- [ ] No merge conflicts with target branch
- [ ] CI pipeline passes

## Reporting Issues

When reporting bugs or requesting features, please:

1. **Search existing issues** first to avoid duplicates
2. **Use issue templates** if available
3. **Provide details**:
   - Flutter/Dart version
   - Device/platform information
   - Steps to reproduce (for bugs)
   - Expected vs actual behavior
   - Screenshots if relevant

## Questions?

- Check the [CLAUDE.md](CLAUDE.md) file for AI assistant guidance
- Review the [development plan](docs/dev-plan.md) for architecture details
- Check sprint specifications in [docs/specs/](docs/specs/)

## License

By contributing, you agree that your contributions will be licensed under the Apache License 2.0.
