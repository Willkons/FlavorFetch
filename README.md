# FlavorFetch

[![CI](https://github.com/Willkons/FlavorFetch/actions/workflows/ci.yml/badge.svg)](https://github.com/Willkons/FlavorFetch/actions/workflows/ci.yml)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)
[![Flutter](https://img.shields.io/badge/Flutter-3.x-blue.svg)](https://flutter.dev/)

FlavorFetch is an open-source Flutter app for tracking pet food preferences. Scan barcodes to log foods, rate reactions for multiple pets, and analyze preferences by brand, flavor, and ingredients. Features local SQLite storage with optional cloud backup (Dropbox/Drive). Perfect for multi-pet households!

## Features (Planned)

- 🐾 **Multi-Pet Management** - Track preferences for all your pets in one place
- 📱 **Barcode Scanning** - Quick product entry via mobile camera
- ⭐ **Preference Ratings** - Rate foods as Love, Like, Neutral, or Dislike
- 📊 **Analytics Dashboard** - Visualize trends by brand, flavor, and ingredients
- 💾 **Local-First Storage** - All data stored locally with SQLite
- 🌙 **Dark Mode** - Support for light and dark themes
- 📤 **Data Export** - Export feeding logs to JSON/CSV

## Project Status

**Current Phase:** Sprint 0 - Project Setup ✅

This project is in active development. The infrastructure is complete, and we're ready to begin implementing features.

### Sprint Progress

- [x] Sprint 0: Project Setup & Infrastructure
- [ ] Sprint 1: Pet Management
- [ ] Sprint 2: Barcode Scanner & Product Integration
- [ ] Sprint 3: Feeding Logs
- [ ] Sprint 4: Analytics Dashboard
- [ ] Sprint 5: Data Export & Polish

## Getting Started

### Prerequisites

- Flutter 3.x or higher
- Dart SDK 3.0 or higher
- Android Studio / Xcode (for mobile deployment)
- VS Code with Dev Containers (recommended)

### Installation

#### Using Dev Container (Recommended)

1. **Clone the repository:**
   ```bash
   git clone https://github.com/Willkons/FlavorFetch.git
   cd FlavorFetch
   ```

2. **Open in VS Code:**
   ```bash
   code .
   ```

3. **Reopen in container** when prompted (or use Command Palette: "Dev Containers: Reopen in Container")

4. **Wait for setup** - Dependencies will install automatically

5. **Verify installation:**
   ```bash
   flutter doctor
   ```

#### Local Development

1. **Clone the repository:**
   ```bash
   git clone https://github.com/Willkons/FlavorFetch.git
   cd FlavorFetch
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the app:**
   ```bash
   flutter run
   ```

### Running Tests

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific tests
flutter test test/unit/
```

### Code Quality

```bash
# Format code
dart format .

# Analyze code
flutter analyze

# Run all quality checks
dart format . && flutter analyze && flutter test
```

## Architecture

FlavorFetch follows a **layered architecture** pattern:

```
lib/
├── presentation/  # UI layer (screens, widgets, state management)
├── domain/        # Business logic (entities, repository interfaces)
├── data/          # Data layer (models, repositories, services)
├── core/          # Shared utilities (theme, constants, extensions)
└── config/        # Configuration (routes, etc.)
```

### Technology Stack

- **Framework:** Flutter 3.x
- **Language:** Dart 3.0+
- **State Management:** Provider/Riverpod
- **Local Database:** SQLite (sqflite)
- **HTTP Client:** Dio
- **Barcode Scanning:** mobile_scanner
- **API:** Open Food Facts (product data)

## Contributing

We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

### Quick Start for Contributors

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes following the [code style guide](CONTRIBUTING.md#code-style-guide)
4. Write tests for your changes
5. Commit using [conventional commits](CONTRIBUTING.md#commit-message-convention)
6. Push to your branch (`git push origin feature/amazing-feature`)
7. Open a Pull Request

## Documentation

- [Development Plan](docs/dev-plan.md) - Comprehensive architecture and sprint planning
- [Sprint Specifications](docs/specs/) - Detailed feature specifications
- [CLAUDE.md](CLAUDE.md) - AI assistant guidance for development
- [CONTRIBUTING.md](CONTRIBUTING.md) - Contribution guidelines

## License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [Open Food Facts](https://world.openfoodfacts.org/) for providing pet food data
- Flutter and Dart teams for the amazing framework
- All contributors who help improve FlavorFetch

## Contact

- **Issues:** [GitHub Issues](https://github.com/Willkons/FlavorFetch/issues)
- **Discussions:** [GitHub Discussions](https://github.com/Willkons/FlavorFetch/discussions)

---

Made with ❤️ for pet parents everywhere
