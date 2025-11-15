# Sprint 5: Data Export & Polish

**Duration:** Week 10
**Status:** Not Started
**Dependencies:** Sprint 0-4 (All previous sprints)

## Overview

Sprint 5 focuses on data portability, app refinement, performance optimization, and final polish before release. This sprint ensures the app is production-ready with professional UI/UX, comprehensive data management, and proper error handling.

## Goals

1. Implement data export (JSON, CSV, PDF)
2. Implement data import for migration/backup
3. Add data backup and restore functionality
4. Implement settings and preferences management
5. Polish UI/UX with animations and micro-interactions
6. Optimize performance and database queries
7. Implement comprehensive error handling
8. Add onboarding flow for new users
9. Complete accessibility improvements
10. Finalize app icon, splash screen, and branding

## User Stories

### US-5.1: Export All Data
**As a** pet owner
**I want** to export all my data in multiple formats
**So that** I can keep backups or switch devices

**Acceptance Criteria:**
- Export option in settings menu
- Export formats available:
  - JSON (complete data, for backup/migration)
  - CSV (feeding logs, for spreadsheet analysis)
  - PDF (formatted report with charts)
- Export includes:
  - All pets with photos
  - All products (cached)
  - All feeding logs with photos
  - User settings/preferences
- Export packages photos in ZIP with data file
- Progress indicator during export
- Success message with share options (email, cloud storage, etc.)
- Export file named with timestamp: `FlavorFetch_Export_YYYY-MM-DD.zip`
- File size warning if >50MB
- Option to exclude photos to reduce size

**Priority:** P0 (Critical)

### US-5.2: Import Data
**As a** pet owner
**I want** to import data from a previous export
**So that** I can restore my data or migrate to a new device

**Acceptance Criteria:**
- Import option in settings menu
- Supports JSON format from app exports
- Import process:
  - Select file from device storage
  - Validation of file format and structure
  - Preview of data to be imported (counts: X pets, Y logs, Z products)
  - Import mode selector:
    - Replace all data (warning: will delete existing data)
    - Merge (skip duplicates)
    - Merge (overwrite duplicates)
  - Confirmation dialog with mode explanation
- Progress indicator during import
- Success message with summary (X pets, Y logs imported)
- Error handling for corrupt files
- Rollback on failure (atomic operation)
- Photos extracted and stored correctly

**Priority:** P0 (Critical)

### US-5.3: Automatic Backup
**As a** pet owner
**I want** automatic backups of my data
**So that** I don't lose important information

**Acceptance Criteria:**
- Backup settings in settings menu
- Backup options:
  - Automatic backup (on/off)
  - Backup frequency (daily, weekly, manual only)
  - Backup location (app documents, cloud provider)
  - Include photos (on/off)
- Automatic backup runs in background
- Backup file name includes date: `FlavorFetch_Backup_YYYY-MM-DD.json`
- Keep last N backups (configurable: 3, 5, 10)
- Old backups auto-deleted when limit reached
- Backup restoration from list of available backups
- Last backup timestamp displayed in settings
- Manual "Backup Now" button
- Notification on backup success/failure (optional)

**Priority:** P1 (High)

### US-5.4: Settings and Preferences
**As a** pet owner
**I want** to customize app settings
**So that** the app works the way I prefer

**Acceptance Criteria:**
- Settings screen accessible from main navigation
- Settings organized into sections:
  - **General**
    - Theme (Light, Dark, System)
    - Language (English, future: additional languages)
    - Date format (MM/DD/YYYY, DD/MM/YYYY, YYYY-MM-DD)
  - **Data & Backup**
    - Automatic backup settings
    - Export data
    - Import data
    - Clear cache
    - Delete all data (with strong confirmation)
  - **Analytics**
    - Default date range for analytics
    - Enable/disable specific insights
  - **Notifications** (future feature)
    - Feeding reminders (on/off)
  - **About**
    - App version
    - Open source licenses
    - Privacy policy
    - Send feedback
    - Rate app
- Settings persisted locally
- Theme changes applied immediately
- Settings export/import with data backup

**Priority:** P1 (High)

### US-5.5: Onboarding Flow
**As a** new user
**I want** a guided introduction to the app
**So that** I understand how to use it effectively

**Acceptance Criteria:**
- Onboarding shown on first app launch only
- Onboarding screens (swipeable):
  1. Welcome: App logo, tagline, "Get Started" button
  2. Add Pets: "Track food preferences for all your pets"
  3. Scan Products: "Quickly identify food with barcode scanning"
  4. Log Feedings: "Rate reactions and build preference history"
  5. Analyze Preferences: "Discover favorites with smart analytics"
  6. Get Started: "Add your first pet" button
- Skip button on all screens
- Progress indicator (dots)
- Smooth animations between screens
- After completion, navigate to "Add Pet" screen
- Option to view onboarding again from settings
- Never show automatically after first time

**Priority:** P1 (High)

### US-5.6: Performance Optimization
**As a** pet owner
**I want** the app to run smoothly
**So that** I have a pleasant user experience

**Acceptance Criteria:**
- Database queries optimized:
  - Proper indexes on all foreign keys
  - Paginated loading for large lists (50 items at a time)
  - Lazy loading for images
- Image optimization:
  - Cached network images
  - Compressed local images
  - Thumbnails generated for lists
  - Progressive loading
- App startup time <2 seconds on mid-range devices
- Screen transitions smooth (60 FPS)
- No janky scrolling in lists
- Memory usage monitored and optimized
- Background tasks don't block UI
- Analytics calculations cached and run async
- Database vacuum on app cleanup

**Priority:** P0 (Critical)

### US-5.7: Error Handling & Recovery
**As a** pet owner
**I want** clear error messages and recovery options
**So that** I can resolve issues easily

**Acceptance Criteria:**
- All error scenarios handled gracefully:
  - Network failures
  - Database errors
  - Permission denials
  - File system errors
  - Invalid data inputs
- Error messages are:
  - User-friendly (no technical jargon)
  - Actionable (suggest what to do)
  - Contextual (related to current action)
- Error types:
  - Snackbar for minor, recoverable errors
  - Dialog for errors requiring user action
  - Error screen for critical failures
- Retry mechanisms for network operations
- Offline mode clearly indicated
- Crash reporting configured (opt-in)
- Error logs saved locally for debugging
- "Report Problem" option in settings

**Priority:** P0 (Critical)

### US-5.8: UI/UX Polish
**As a** pet owner
**I want** a polished, professional interface
**So that** the app feels high-quality and enjoyable to use

**Acceptance Criteria:**
- Consistent design system:
  - Color palette (primary, secondary, error, success)
  - Typography scale
  - Spacing system (8px grid)
  - Border radius consistency
  - Shadow/elevation system
- Micro-interactions:
  - Button press animations
  - List item tap feedback
  - Smooth page transitions
  - Loading skeletons (not just spinners)
  - Success animations (checkmarks, celebrations)
- Empty states:
  - Illustrations for all empty states
  - Encouraging copy
  - Clear call-to-action buttons
- Icon consistency (Material Icons or custom set)
- Proper loading states everywhere
- Proper error states everywhere
- Accessibility:
  - Semantic labels for screen readers
  - Sufficient color contrast (WCAG AA)
  - Touch targets ≥44x44 dp
  - Focus indicators for keyboard navigation

**Priority:** P1 (High)

### US-5.9: Dark Mode Support
**As a** pet owner
**I want** a dark mode option
**So that** I can use the app comfortably in low light

**Acceptance Criteria:**
- Dark theme fully implemented
- Theme toggle in settings
- System theme option (follows OS setting)
- All screens support dark mode:
  - Proper background colors
  - Proper text colors (sufficient contrast)
  - Proper image/icon tinting
  - Charts readable in dark mode
- Images and photos display well in dark mode
- Theme changes instantly (no restart needed)
- Theme preference saved
- Default: System theme

**Priority:** P1 (High)

### US-5.10: App Branding & Assets
**As a** user
**I want** professional branding and visual identity
**So that** the app looks trustworthy and polished

**Acceptance Criteria:**
- App icon designed and implemented:
  - iOS: All required sizes
  - Android: Adaptive icon (foreground + background)
  - High quality, recognizable design
  - Pet food theme
- Splash screen:
  - App logo centered
  - Background color from theme
  - Fast loading (<1 second)
  - iOS and Android native splash
- App name finalized: "FlavorFetch"
- Tagline: "Track Your Pet's Food Preferences"
- About screen includes:
  - App logo
  - Version number
  - Copyright notice
  - Open source attribution
- Consistent branding across all screens

**Priority:** P2 (Medium)

## Technical Specifications

### Data Export/Import Service

**File:** `lib/data/services/export_import_service.dart`

```dart
import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ExportImportService {
  /// Export all data to JSON format
  Future<File> exportToJson({
    required List<Map<String, dynamic>> pets,
    required List<Map<String, dynamic>> products,
    required List<Map<String, dynamic>> feedingLogs,
    required Map<String, dynamic> settings,
    bool includePhotos = true,
  }) async {
    final exportData = {
      'version': '1.0',
      'exportDate': DateTime.now().toIso8601String(),
      'pets': pets,
      'products': products,
      'feedingLogs': feedingLogs,
      'settings': settings,
    };

    final jsonString = JsonEncoder.withIndent('  ').convert(exportData);

    if (includePhotos) {
      return await _createZipWithPhotos(jsonString, pets, feedingLogs);
    } else {
      return await _createJsonFile(jsonString);
    }
  }

  /// Export feeding logs to CSV
  Future<File> exportToCsv(List<Map<String, dynamic>> feedingLogs) async {
    final csvBuffer = StringBuffer();

    // Header
    csvBuffer.writeln('Date,Time,Pet,Product,Brand,Rating,Amount,Notes');

    // Rows
    for (final log in feedingLogs) {
      final date = DateTime.parse(log['feeding_date']);
      final rating = _getRatingLabel(log['rating']);

      csvBuffer.writeln([
        date.toIso8601String().split('T')[0],
        date.toIso8601String().split('T')[1].split('.')[0],
        log['pet_name'] ?? '',
        log['product_name'] ?? '',
        log['product_brand'] ?? '',
        rating,
        log['amount_fed'] ?? '',
        '"${log['notes'] ?? ''}"',
      ].join(','));
    }

    final directory = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().toIso8601String().split('.')[0].replaceAll(':', '-');
    final file = File(path.join(directory.path, 'FlavorFetch_Export_$timestamp.csv'));

    return await file.writeAsString(csvBuffer.toString());
  }

  /// Import data from JSON
  Future<ImportResult> importFromJson(File file) async {
    try {
      String jsonString;

      // Check if ZIP file
      if (path.extension(file.path) == '.zip') {
        final bytes = await file.readAsBytes();
        final archive = ZipDecoder().decodeBytes(bytes);

        // Find data.json in archive
        final dataFile = archive.findFile('data.json');
        if (dataFile == null) {
          throw Exception('Invalid export file: data.json not found');
        }

        jsonString = utf8.decode(dataFile.content as List<int>);
      } else {
        jsonString = await file.readAsString();
      }

      final data = json.decode(jsonString) as Map<String, dynamic>;

      // Validate structure
      _validateImportData(data);

      return ImportResult(
        pets: List<Map<String, dynamic>>.from(data['pets'] ?? []),
        products: List<Map<String, dynamic>>.from(data['products'] ?? []),
        feedingLogs: List<Map<String, dynamic>>.from(data['feedingLogs'] ?? []),
        settings: Map<String, dynamic>.from(data['settings'] ?? {}),
        photoFiles: await _extractPhotos(file),
      );
    } catch (e) {
      throw ImportException('Failed to import data: $e');
    }
  }

  Future<File> _createJsonFile(String jsonString) async {
    final directory = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().toIso8601String().split('.')[0].replaceAll(':', '-');
    final file = File(path.join(directory.path, 'FlavorFetch_Export_$timestamp.json'));

    return await file.writeAsString(jsonString);
  }

  Future<File> _createZipWithPhotos(
    String jsonString,
    List<Map<String, dynamic>> pets,
    List<Map<String, dynamic>> feedingLogs,
  ) async {
    final archive = Archive();

    // Add data.json
    archive.addFile(ArchiveFile('data.json', jsonString.length, jsonString.codeUnits));

    // Add pet photos
    for (final pet in pets) {
      final photoPath = pet['photo_path'] as String?;
      if (photoPath != null && await File(photoPath).exists()) {
        final photoFile = File(photoPath);
        final photoBytes = await photoFile.readAsBytes();
        final photoName = path.basename(photoPath);
        archive.addFile(ArchiveFile('photos/pets/$photoName', photoBytes.length, photoBytes));
      }
    }

    // Add feeding log photos
    for (final log in feedingLogs) {
      final photoPath = log['photo_path'] as String?;
      if (photoPath != null && photoPath.isNotEmpty) {
        final photoPaths = photoPath.split(',');
        for (final singlePath in photoPaths) {
          if (await File(singlePath).exists()) {
            final photoFile = File(singlePath);
            final photoBytes = await photoFile.readAsBytes();
            final photoName = path.basename(singlePath);
            archive.addFile(ArchiveFile('photos/logs/$photoName', photoBytes.length, photoBytes));
          }
        }
      }
    }

    // Encode to ZIP
    final zipBytes = ZipEncoder().encode(archive);

    final directory = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().toIso8601String().split('.')[0].replaceAll(':', '-');
    final file = File(path.join(directory.path, 'FlavorFetch_Export_$timestamp.zip'));

    return await file.writeAsBytes(zipBytes!);
  }

  Future<Map<String, File>> _extractPhotos(File zipFile) async {
    final photos = <String, File>{};

    if (path.extension(zipFile.path) != '.zip') {
      return photos;
    }

    final bytes = await zipFile.readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);
    final tempDir = await getTemporaryDirectory();

    for (final file in archive.files) {
      if (file.isFile && file.name.startsWith('photos/')) {
        final photoPath = path.join(tempDir.path, file.name);
        final photoFile = File(photoPath);
        await photoFile.create(recursive: true);
        await photoFile.writeAsBytes(file.content as List<int>);

        final relativeName = file.name.replaceFirst('photos/', '');
        photos[relativeName] = photoFile;
      }
    }

    return photos;
  }

  void _validateImportData(Map<String, dynamic> data) {
    if (!data.containsKey('version')) {
      throw Exception('Invalid export file: missing version');
    }

    if (!data.containsKey('pets') || !data.containsKey('feedingLogs')) {
      throw Exception('Invalid export file: missing required data');
    }
  }

  String _getRatingLabel(int value) {
    switch (value) {
      case 4:
        return 'Love it';
      case 3:
        return 'Like it';
      case 2:
        return 'Neutral';
      case 1:
        return 'Dislike it';
      default:
        return 'Unknown';
    }
  }
}

class ImportResult {
  final List<Map<String, dynamic>> pets;
  final List<Map<String, dynamic>> products;
  final List<Map<String, dynamic>> feedingLogs;
  final Map<String, dynamic> settings;
  final Map<String, File> photoFiles;

  ImportResult({
    required this.pets,
    required this.products,
    required this.feedingLogs,
    required this.settings,
    required this.photoFiles,
  });
}

class ImportException implements Exception {
  final String message;
  ImportException(this.message);

  @override
  String toString() => message;
}
```

### Settings Service

**File:** `lib/data/services/settings_service.dart`

```dart
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class SettingsService {
  static const String _themeKey = 'theme_mode';
  static const String _dateFormatKey = 'date_format';
  static const String _autoBackupKey = 'auto_backup';
  static const String _backupFrequencyKey = 'backup_frequency';
  static const String _includePhotosKey = 'include_photos_backup';
  static const String _analyticsDateRangeKey = 'analytics_date_range';
  static const String _onboardingCompletedKey = 'onboarding_completed';

  Future<ThemeMode> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_themeKey) ?? 'system';
    return ThemeMode.values.firstWhere((e) => e.name == value);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, mode.name);
  }

  Future<String> getDateFormat() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_dateFormatKey) ?? 'MM/dd/yyyy';
  }

  Future<void> setDateFormat(String format) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_dateFormatKey, format);
  }

  Future<bool> getAutoBackup() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_autoBackupKey) ?? false;
  }

  Future<void> setAutoBackup(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_autoBackupKey, enabled);
  }

  Future<String> getBackupFrequency() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_backupFrequencyKey) ?? 'weekly';
  }

  Future<void> setBackupFrequency(String frequency) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_backupFrequencyKey, frequency);
  }

  Future<bool> getIncludePhotosInBackup() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_includePhotosKey) ?? true;
  }

  Future<void> setIncludePhotosInBackup(bool include) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_includePhotosKey, include);
  }

  Future<int> getAnalyticsDateRange() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_analyticsDateRangeKey) ?? 30;
  }

  Future<void> setAnalyticsDateRange(int days) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_analyticsDateRangeKey, days);
  }

  Future<bool> isOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingCompletedKey) ?? false;
  }

  Future<void> setOnboardingCompleted(bool completed) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingCompletedKey, completed);
  }

  Future<Map<String, dynamic>> getAllSettings() async {
    return {
      'theme_mode': (await getThemeMode()).name,
      'date_format': await getDateFormat(),
      'auto_backup': await getAutoBackup(),
      'backup_frequency': await getBackupFrequency(),
      'include_photos_backup': await getIncludePhotosInBackup(),
      'analytics_date_range': await getAnalyticsDateRange(),
    };
  }

  Future<void> importSettings(Map<String, dynamic> settings) async {
    if (settings.containsKey('theme_mode')) {
      await setThemeMode(
        ThemeMode.values.firstWhere((e) => e.name == settings['theme_mode']),
      );
    }
    if (settings.containsKey('date_format')) {
      await setDateFormat(settings['date_format']);
    }
    if (settings.containsKey('auto_backup')) {
      await setAutoBackup(settings['auto_backup']);
    }
    if (settings.containsKey('backup_frequency')) {
      await setBackupFrequency(settings['backup_frequency']);
    }
    if (settings.containsKey('include_photos_backup')) {
      await setIncludePhotosInBackup(settings['include_photos_backup']);
    }
    if (settings.containsKey('analytics_date_range')) {
      await setAnalyticsDateRange(settings['analytics_date_range']);
    }
  }
}
```

### Presentation Layer

#### Settings Screen

**File:** `lib/presentation/screens/settings/settings_screen.dart`

**Key Components:**
- Grouped settings list
- Theme picker
- Date format picker
- Backup settings section
- Export/import buttons
- About section
- Clear cache button
- Delete all data button (with strong confirmation)

#### Onboarding Screen

**File:** `lib/presentation/screens/onboarding/onboarding_screen.dart`

**Key Components:**
- PageView for swipeable screens
- Page indicator dots
- Skip button
- Next/Get Started buttons
- Smooth animations
- Illustrations for each screen

#### Export Screen

**File:** `lib/presentation/screens/export/export_screen.dart`

**Key Components:**
- Format selector (JSON, CSV, PDF)
- Include photos checkbox
- Export button with progress
- Share sheet integration

#### Import Screen

**File:** `lib/presentation/screens/import/import_screen.dart`

**Key Components:**
- File picker
- Data preview
- Import mode selector
- Confirmation dialog
- Progress indicator
- Success/error messages

## Testing Requirements

### Unit Tests

**File:** `test/unit/export_import_service_test.dart`
- Test JSON export/import
- Test CSV export
- Test ZIP creation with photos
- Test data validation
- Mock file system

**File:** `test/unit/settings_service_test.dart`
- Test all settings getters/setters
- Test settings persistence
- Mock SharedPreferences

### Widget Tests

**File:** `test/widget/settings_screen_test.dart`
- Test settings UI rendering
- Test theme switching
- Test navigation to export/import

**File:** `test/widget/onboarding_screen_test.dart`
- Test page navigation
- Test skip functionality
- Test completion flow

### Integration Tests

**File:** `test/integration/export_import_flow_test.dart`
- Test complete export flow
- Test complete import flow
- Test backup/restore

**File:** `test/integration/onboarding_flow_test.dart`
- Test first-launch experience
- Test onboarding completion

## Definition of Done

- [ ] Export functionality (JSON, CSV) complete
- [ ] Import functionality complete with validation
- [ ] Automatic backup system implemented
- [ ] Settings screen with all preferences
- [ ] Onboarding flow complete
- [ ] Performance optimizations applied
- [ ] Error handling comprehensive
- [ ] UI polish complete (animations, micro-interactions)
- [ ] Dark mode fully supported
- [ ] App icon and splash screen finalized
- [ ] All unit tests passing with >80% coverage
- [ ] All widget tests passing
- [ ] Integration tests passing
- [ ] App tested on multiple devices/screen sizes
- [ ] Memory leaks checked and fixed
- [ ] Code reviewed and merged to main branch
- [ ] Release candidate built and tested

## Dependencies and Blockers

**Dependencies:**
- All previous sprints complete
- Design assets finalized (icon, splash, illustrations)

**Potential Blockers:**
- Large file export/import performance
- Platform-specific file picker issues
- Photo extraction from ZIP complexity

## Notes

- Consider adding cloud sync in future (Google Drive, iCloud)
- PDF export could be enhanced with better formatting
- Settings could include notification preferences for future
- Consider adding app rating prompt after X feeding logs
- Analytics export to include visualizations in PDF
- Consider GDPR compliance for data export/delete

## Additional Polish Tasks

- [ ] Add haptic feedback where appropriate
- [ ] Ensure all images have proper alt text
- [ ] Test with screen readers (TalkBack, VoiceOver)
- [ ] Test with different font sizes (accessibility)
- [ ] Add loading skeletons instead of spinners
- [ ] Ensure proper focus order for keyboard navigation
- [ ] Test on tablets and optimize layouts
- [ ] Verify app works offline (except API features)
- [ ] Add proper error boundaries
- [ ] Test deep linking (if applicable)
- [ ] Optimize app size (remove unused assets)
- [ ] Add app store screenshots and descriptions
- [ ] Prepare privacy policy and terms of service

## Resources

- [Flutter Archive Package](https://pub.dev/packages/archive)
- [Shared Preferences Package](https://pub.dev/packages/shared_preferences)
- [File Picker Package](https://pub.dev/packages/file_picker)
- [Flutter Splash Screen](https://docs.flutter.dev/platform-integration/android/splash-screen)
- [Flutter App Icon](https://pub.dev/packages/flutter_launcher_icons)
- [Material Design Guidelines](https://m3.material.io/)
- [iOS Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)
- [WCAG Accessibility Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)
