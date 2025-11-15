# Sprint 3: Feeding Log Functionality

**Duration:** Weeks 6-7
**Status:** Not Started
**Dependencies:** Sprint 1 (Pet Management), Sprint 2 (Product Integration)

## Overview

Sprint 3 implements the core feeding log functionality that connects pets with products and tracks their reactions over time. This is the central feature that enables preference tracking and analysis.

## Goals

1. Implement feeding log entity with ratings and notes
2. Create feeding log repository with filtering and sorting
3. Build feeding log entry form with pet and product selection
4. Display feeding history for individual pets
5. Display feeding history for individual products
6. Implement rating system (love, like, neutral, dislike)
7. Add photo capture for feeding sessions
8. Enable editing and deletion of feeding logs

## User Stories

### US-3.1: Log Feeding Session
**As a** pet owner
**I want** to log when I feed my pet a specific product
**So that** I can track their food history and preferences

**Acceptance Criteria:**
- Feeding log creation accessible from:
  - Product detail screen (pre-selects product)
  - Pet detail screen (pre-selects pet)
  - Main navigation (no pre-selection)
- Form includes:
  - Pet selector (required, dropdown/search)
  - Product selector (required, with barcode scan option)
  - Feeding date/time (required, defaults to now)
  - Preference rating (required, 4-level scale)
  - Amount fed (optional, text field with unit)
  - Photo (optional, camera/gallery)
  - Notes (optional, multiline text, max 500 characters)
- Form validation for required fields
- Save button creates feeding log entry
- Success message after save
- Navigate to feeding log detail after save
- Quick-log option for repeat feedings (one-tap)

**Priority:** P0 (Critical)

### US-3.2: Rate Pet's Reaction
**As a** pet owner
**I want** to rate how my pet reacted to the food
**So that** I can identify their preferences over time

**Acceptance Criteria:**
- Rating system with 4 levels:
  - Love it (heart icon, green)
  - Like it (thumbs up icon, light green)
  - Neutral (minus icon, gray)
  - Dislike it (thumbs down icon, orange)
- Visual rating selector with icons and colors
- Rating required before saving
- Rating displayed consistently across app
- Rating can be changed after initial entry
- Rating influences analytics and recommendations

**Priority:** P0 (Critical)

### US-3.3: View Feeding History (Pet View)
**As a** pet owner
**I want** to view all feeding logs for a specific pet
**So that** I can see what they've been eating and their reactions

**Acceptance Criteria:**
- Feeding history accessible from pet detail screen
- Timeline view showing logs in reverse chronological order
- Each entry shows:
  - Product name and brand
  - Product thumbnail
  - Feeding date/time (relative time for recent, absolute for older)
  - Preference rating with icon/color
  - Amount fed (if logged)
  - Quick preview of notes (truncated)
- Filter options:
  - Date range (last week, month, 3 months, all)
  - Rating (show only specific ratings)
  - Product (show logs for specific product)
- Sort options:
  - Date (newest/oldest first)
  - Rating (best/worst first)
- Tap entry to view full details
- Pull-to-refresh
- Infinite scroll for large histories
- Empty state if no logs

**Priority:** P0 (Critical)

### US-3.4: View Feeding History (Product View)
**As a** pet owner
**I want** to view all feeding logs for a specific product
**So that** I can see how different pets reacted to it

**Acceptance Criteria:**
- Feeding history accessible from product detail screen
- List view showing logs grouped by pet
- Each entry shows:
  - Pet name and photo
  - Feeding date/time
  - Preference rating
  - Notes preview
- Summary statistics at top:
  - Total times fed
  - Rating distribution (% love/like/neutral/dislike)
  - Average rating visualization
- Filter by date range
- Sort by date or rating
- Tap entry to view full details
- Empty state if no logs

**Priority:** P1 (High)

### US-3.5: Edit Feeding Log
**As a** pet owner
**I want** to edit a feeding log entry
**So that** I can correct mistakes or add information later

**Acceptance Criteria:**
- Edit option available from feeding log detail view
- Edit form pre-populated with existing data
- All fields editable except pet and product (would create confusion)
- To change pet/product, must delete and create new entry
- Rating can be updated (common use case: initial rating changes after observation)
- Notes can be edited/added
- Photos can be added, replaced, or removed
- Save button updates entry with new timestamp for modification
- Success message after update
- Return to detail view after save
- Cancel button discards changes with confirmation

**Priority:** P1 (High)

### US-3.6: Delete Feeding Log
**As a** pet owner
**I want** to delete incorrect feeding log entries
**So that** my data remains accurate

**Acceptance Criteria:**
- Delete option in feeding log detail menu
- Confirmation dialog: "Delete this feeding log? This cannot be undone."
- After confirmation, entry deleted from database
- Associated photo deleted from storage
- Success message shown
- Navigate back to previous screen (pet/product history)
- Undo option via snackbar (5 second window)

**Priority:** P1 (High)

### US-3.7: Quick-Log Repeat Feeding
**As a** pet owner
**I want** to quickly log repeat feedings of the same product
**So that** I can track routine meals efficiently

**Acceptance Criteria:**
- "Log Again" button on feeding log detail
- "Feed Again" button on product detail (uses last rating for this pet)
- Quick-log dialog shows:
  - Pre-filled pet and product
  - Current date/time
  - Previous rating (editable)
  - Optional notes field
  - Save button
- One-tap save creates new log entry
- Full form link available for more details
- Success message with undo option

**Priority:** P2 (Medium)

### US-3.8: Add Photos to Feeding Logs
**As a** pet owner
**I want** to attach photos to feeding logs
**So that** I can document feeding sessions and pet reactions

**Acceptance Criteria:**
- Photo capture option in feeding log form
- Multiple photos allowed (up to 5 per log)
- Photos from camera or gallery
- Photo preview in form before saving
- Photos compressed and stored locally
- Photos displayed in feeding log detail
- Photo viewer with swipe navigation
- Delete individual photos option
- Photos deleted when log deleted

**Priority:** P2 (Medium)

## Technical Specifications

### Data Layer

#### FeedingLog Entity

**File:** `lib/domain/entities/feeding_log.dart`

```dart
class FeedingLog {
  final String id;
  final String petId;
  final String productBarcode;
  final DateTime feedingDate;
  final PreferenceRating rating;
  final String? amountFed;
  final String? notes;
  final List<String> photoPath;
  final DateTime createdAt;
  final DateTime? updatedAt;

  FeedingLog({
    required this.id,
    required this.petId,
    required this.productBarcode,
    required this.feedingDate,
    required this.rating,
    this.amountFed,
    this.notes,
    this.photoPath = const [],
    required this.createdAt,
    this.updatedAt,
  });

  bool get hasPhotos => photoPath.isNotEmpty;
  bool get hasNotes => notes != null && notes!.isNotEmpty;
}

enum PreferenceRating {
  love(value: 4, label: 'Love it', color: 0xFF4CAF50, icon: 'favorite'),
  like(value: 3, label: 'Like it', color: 0xFF8BC34A, icon: 'thumb_up'),
  neutral(value: 2, label: 'Neutral', color: 0xFF9E9E9E, icon: 'remove'),
  dislike(value: 1, label: 'Dislike it', color: 0xFFFF9800, icon: 'thumb_down');

  const PreferenceRating({
    required this.value,
    required this.label,
    required this.color,
    required this.icon,
  });

  final int value;
  final String label;
  final int color;
  final String icon;

  static PreferenceRating fromValue(int value) {
    return PreferenceRating.values.firstWhere((r) => r.value == value);
  }
}
```

#### FeedingLog Model

**File:** `lib/data/models/feeding_log_model.dart`

```dart
import '../../domain/entities/feeding_log.dart';

class FeedingLogModel {
  final String id;
  final String petId;
  final String productBarcode;
  final DateTime feedingDate;
  final int rating;
  final String? amountFed;
  final String? notes;
  final String? photoPath;
  final DateTime createdAt;
  final DateTime? updatedAt;

  FeedingLogModel({
    required this.id,
    required this.petId,
    required this.productBarcode,
    required this.feedingDate,
    required this.rating,
    this.amountFed,
    this.notes,
    this.photoPath,
    required this.createdAt,
    this.updatedAt,
  });

  factory FeedingLogModel.fromJson(Map<String, dynamic> json) {
    return FeedingLogModel(
      id: json['id'] as String,
      petId: json['pet_id'] as String,
      productBarcode: json['product_barcode'] as String,
      feedingDate: DateTime.parse(json['feeding_date'] as String),
      rating: json['rating'] as int,
      amountFed: json['amount_fed'] as String?,
      notes: json['notes'] as String?,
      photoPath: json['photo_path'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pet_id': petId,
      'product_barcode': productBarcode,
      'feeding_date': feedingDate.toIso8601String(),
      'rating': rating,
      'amount_fed': amountFed,
      'notes': notes,
      'photo_path': photoPath,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  FeedingLog toEntity() {
    return FeedingLog(
      id: id,
      petId: petId,
      productBarcode: productBarcode,
      feedingDate: feedingDate,
      rating: PreferenceRating.fromValue(rating),
      amountFed: amountFed,
      notes: notes,
      photoPath: photoPath?.split(',') ?? [],
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory FeedingLogModel.fromEntity(FeedingLog log) {
    return FeedingLogModel(
      id: log.id,
      petId: log.petId,
      productBarcode: log.productBarcode,
      feedingDate: log.feedingDate,
      rating: log.rating.value,
      amountFed: log.amountFed,
      notes: log.notes,
      photoPath: log.photoPath.join(','),
      createdAt: log.createdAt,
      updatedAt: log.updatedAt,
    );
  }
}
```

#### Database Schema Update

**File:** `lib/data/services/database_service.dart` (update)

```dart
// Add to _onCreate method:
await db.execute('''
  CREATE TABLE feeding_logs (
    id TEXT PRIMARY KEY,
    pet_id TEXT NOT NULL,
    product_barcode TEXT NOT NULL,
    feeding_date TEXT NOT NULL,
    rating INTEGER NOT NULL CHECK(rating >= 1 AND rating <= 4),
    amount_fed TEXT,
    notes TEXT,
    photo_path TEXT,
    created_at TEXT NOT NULL,
    updated_at TEXT,
    FOREIGN KEY (pet_id) REFERENCES pets (id) ON DELETE CASCADE,
    FOREIGN KEY (product_barcode) REFERENCES products (barcode) ON DELETE CASCADE
  )
''');

// Create indexes for common queries
await db.execute('CREATE INDEX idx_feeding_logs_pet_id ON feeding_logs(pet_id)');
await db.execute('CREATE INDEX idx_feeding_logs_product ON feeding_logs(product_barcode)');
await db.execute('CREATE INDEX idx_feeding_logs_date ON feeding_logs(feeding_date)');
await db.execute('CREATE INDEX idx_feeding_logs_rating ON feeding_logs(rating)');
```

#### FeedingLog Repository Interface

**File:** `lib/domain/repositories/feeding_log_repository.dart`

```dart
import '../entities/feeding_log.dart';

abstract class FeedingLogRepository {
  Future<FeedingLog> createLog(FeedingLog log);
  Future<FeedingLog> updateLog(FeedingLog log);
  Future<void> deleteLog(String id);
  Future<FeedingLog?> getLogById(String id);
  Future<List<FeedingLog>> getLogsByPetId(
    String petId, {
    DateTime? startDate,
    DateTime? endDate,
    PreferenceRating? rating,
  });
  Future<List<FeedingLog>> getLogsByProductBarcode(
    String barcode, {
    DateTime? startDate,
    DateTime? endDate,
  });
  Future<List<FeedingLog>> getAllLogs({
    DateTime? startDate,
    DateTime? endDate,
    String? orderBy,
  });
  Future<int> getLogCount({String? petId, String? productBarcode});
  Future<Map<PreferenceRating, int>> getRatingDistribution({
    String? petId,
    String? productBarcode,
  });
  Future<FeedingLog?> getLastLogForPetAndProduct(String petId, String barcode);
}
```

#### FeedingLog Repository Implementation

**File:** `lib/data/repositories/feeding_log_repository_impl.dart`

```dart
import 'package:sqflite/sqflite.dart';
import '../../domain/entities/feeding_log.dart';
import '../../domain/repositories/feeding_log_repository.dart';
import '../models/feeding_log_model.dart';
import '../services/database_service.dart';

class FeedingLogRepositoryImpl implements FeedingLogRepository {
  final DatabaseService _databaseService;

  FeedingLogRepositoryImpl(this._databaseService);

  @override
  Future<FeedingLog> createLog(FeedingLog log) async {
    final db = await _databaseService.database;
    final model = FeedingLogModel.fromEntity(log);

    await db.insert(
      'feeding_logs',
      model.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return log;
  }

  @override
  Future<FeedingLog> updateLog(FeedingLog log) async {
    final db = await _databaseService.database;
    final model = FeedingLogModel.fromEntity(log);

    await db.update(
      'feeding_logs',
      model.toJson(),
      where: 'id = ?',
      whereArgs: [log.id],
    );

    return log;
  }

  @override
  Future<void> deleteLog(String id) async {
    final db = await _databaseService.database;

    await db.delete(
      'feeding_logs',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<FeedingLog?> getLogById(String id) async {
    final db = await _databaseService.database;
    final maps = await db.query(
      'feeding_logs',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isEmpty) return null;
    return FeedingLogModel.fromJson(maps.first).toEntity();
  }

  @override
  Future<List<FeedingLog>> getLogsByPetId(
    String petId, {
    DateTime? startDate,
    DateTime? endDate,
    PreferenceRating? rating,
  }) async {
    final db = await _databaseService.database;

    String whereClause = 'pet_id = ?';
    List<dynamic> whereArgs = [petId];

    if (startDate != null) {
      whereClause += ' AND feeding_date >= ?';
      whereArgs.add(startDate.toIso8601String());
    }

    if (endDate != null) {
      whereClause += ' AND feeding_date <= ?';
      whereArgs.add(endDate.toIso8601String());
    }

    if (rating != null) {
      whereClause += ' AND rating = ?';
      whereArgs.add(rating.value);
    }

    final maps = await db.query(
      'feeding_logs',
      where: whereClause,
      whereArgs: whereArgs,
      orderBy: 'feeding_date DESC',
    );

    return maps.map((map) => FeedingLogModel.fromJson(map).toEntity()).toList();
  }

  @override
  Future<List<FeedingLog>> getLogsByProductBarcode(
    String barcode, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final db = await _databaseService.database;

    String whereClause = 'product_barcode = ?';
    List<dynamic> whereArgs = [barcode];

    if (startDate != null) {
      whereClause += ' AND feeding_date >= ?';
      whereArgs.add(startDate.toIso8601String());
    }

    if (endDate != null) {
      whereClause += ' AND feeding_date <= ?';
      whereArgs.add(endDate.toIso8601String());
    }

    final maps = await db.query(
      'feeding_logs',
      where: whereClause,
      whereArgs: whereArgs,
      orderBy: 'feeding_date DESC',
    );

    return maps.map((map) => FeedingLogModel.fromJson(map).toEntity()).toList();
  }

  @override
  Future<List<FeedingLog>> getAllLogs({
    DateTime? startDate,
    DateTime? endDate,
    String? orderBy,
  }) async {
    final db = await _databaseService.database;

    String? whereClause;
    List<dynamic> whereArgs = [];

    if (startDate != null || endDate != null) {
      whereClause = '';
      if (startDate != null) {
        whereClause += 'feeding_date >= ?';
        whereArgs.add(startDate.toIso8601String());
      }
      if (endDate != null) {
        if (whereClause.isNotEmpty) whereClause += ' AND ';
        whereClause += 'feeding_date <= ?';
        whereArgs.add(endDate.toIso8601String());
      }
    }

    final maps = await db.query(
      'feeding_logs',
      where: whereClause,
      whereArgs: whereArgs.isNotEmpty ? whereArgs : null,
      orderBy: orderBy ?? 'feeding_date DESC',
    );

    return maps.map((map) => FeedingLogModel.fromJson(map).toEntity()).toList();
  }

  @override
  Future<int> getLogCount({String? petId, String? productBarcode}) async {
    final db = await _databaseService.database;

    String? whereClause;
    List<dynamic>? whereArgs;

    if (petId != null) {
      whereClause = 'pet_id = ?';
      whereArgs = [petId];
    } else if (productBarcode != null) {
      whereClause = 'product_barcode = ?';
      whereArgs = [productBarcode];
    }

    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM feeding_logs${whereClause != null ? ' WHERE $whereClause' : ''}',
      whereArgs,
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  @override
  Future<Map<PreferenceRating, int>> getRatingDistribution({
    String? petId,
    String? productBarcode,
  }) async {
    final db = await _databaseService.database;

    String? whereClause;
    List<dynamic>? whereArgs;

    if (petId != null) {
      whereClause = 'pet_id = ?';
      whereArgs = [petId];
    } else if (productBarcode != null) {
      whereClause = 'product_barcode = ?';
      whereArgs = [productBarcode];
    }

    final result = await db.rawQuery(
      'SELECT rating, COUNT(*) as count FROM feeding_logs${whereClause != null ? ' WHERE $whereClause' : ''} GROUP BY rating',
      whereArgs,
    );

    final distribution = <PreferenceRating, int>{};
    for (final rating in PreferenceRating.values) {
      distribution[rating] = 0;
    }

    for (final row in result) {
      final rating = PreferenceRating.fromValue(row['rating'] as int);
      distribution[rating] = row['count'] as int;
    }

    return distribution;
  }

  @override
  Future<FeedingLog?> getLastLogForPetAndProduct(
    String petId,
    String barcode,
  ) async {
    final db = await _databaseService.database;
    final maps = await db.query(
      'feeding_logs',
      where: 'pet_id = ? AND product_barcode = ?',
      whereArgs: [petId, barcode],
      orderBy: 'feeding_date DESC',
      limit: 1,
    );

    if (maps.isEmpty) return null;
    return FeedingLogModel.fromJson(maps.first).toEntity();
  }
}
```

### Presentation Layer

#### FeedingLog Provider

**File:** `lib/presentation/providers/feeding_log_provider.dart`

```dart
import 'package:flutter/foundation.dart';
import '../../domain/entities/feeding_log.dart';
import '../../domain/repositories/feeding_log_repository.dart';

class FeedingLogProvider extends ChangeNotifier {
  final FeedingLogRepository _repository;

  List<FeedingLog> _logs = [];
  FeedingLog? _selectedLog;
  bool _isLoading = false;
  String? _error;

  FeedingLogProvider(this._repository);

  List<FeedingLog> get logs => _logs;
  FeedingLog? get selectedLog => _selectedLog;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadLogsForPet(
    String petId, {
    DateTime? startDate,
    DateTime? endDate,
    PreferenceRating? rating,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _logs = await _repository.getLogsByPetId(
        petId,
        startDate: startDate,
        endDate: endDate,
        rating: rating,
      );
    } catch (e) {
      _error = 'Failed to load feeding logs: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadLogsForProduct(
    String barcode, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _logs = await _repository.getLogsByProductBarcode(
        barcode,
        startDate: startDate,
        endDate: endDate,
      );
    } catch (e) {
      _error = 'Failed to load feeding logs: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createLog(FeedingLog log) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final created = await _repository.createLog(log);
      _selectedLog = created;
      return true;
    } catch (e) {
      _error = 'Failed to create feeding log: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateLog(FeedingLog log) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _repository.updateLog(log);
      _selectedLog = log;
      return true;
    } catch (e) {
      _error = 'Failed to update feeding log: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteLog(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _repository.deleteLog(id);
      _logs.removeWhere((log) => log.id == id);
      if (_selectedLog?.id == id) {
        _selectedLog = null;
      }
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to delete feeding log: $e';
      notifyListeners();
      return false;
    }
  }

  Future<Map<PreferenceRating, int>> getRatingDistribution({
    String? petId,
    String? productBarcode,
  }) async {
    try {
      return await _repository.getRatingDistribution(
        petId: petId,
        productBarcode: productBarcode,
      );
    } catch (e) {
      _error = 'Failed to get rating distribution: $e';
      notifyListeners();
      return {};
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
```

#### Feeding Log Form Screen

**File:** `lib/presentation/screens/feeding_log_form/feeding_log_form_screen.dart`

**Key Components:**
- Pet selector (dropdown or search)
- Product selector (with scan button)
- Date/time picker
- Rating selector (visual buttons)
- Amount field with unit selector
- Photo capture button
- Notes text field
- Save/cancel buttons
- Form validation

#### Feeding Log Detail Screen

**File:** `lib/presentation/screens/feeding_log_detail/feeding_log_detail_screen.dart`

**Key Components:**
- Pet and product information (tappable)
- Feeding date/time
- Rating display with icon/color
- Amount fed
- Photo gallery (if photos exist)
- Notes display
- Edit button
- Delete option
- "Log Again" quick action

#### Feeding History List Widget

**File:** `lib/presentation/widgets/feeding_history_list.dart`

**Key Components:**
- Timeline/list view of feeding logs
- Filter options (date, rating)
- Sort options
- Empty state
- Loading shimmer
- Infinite scroll
- Pull-to-refresh

## Testing Requirements

### Unit Tests

**File:** `test/unit/feeding_log_repository_test.dart`
- Test CRUD operations
- Test filtering by pet, product, date, rating
- Test rating distribution calculation
- Test query performance with large datasets

**File:** `test/unit/feeding_log_model_test.dart`
- Test JSON serialization
- Test entity conversion
- Test rating enum conversion

**File:** `test/unit/feeding_log_provider_test.dart`
- Test state management
- Test loading/error states
- Mock repository

### Widget Tests

**File:** `test/widget/feeding_log_form_test.dart`
- Test form validation
- Test rating selector
- Test date/time picker
- Test photo capture

**File:** `test/widget/feeding_history_list_test.dart`
- Test list rendering
- Test filtering
- Test sorting
- Test empty state

### Integration Tests

**File:** `test/integration/feeding_log_flow_test.dart`
- Test complete flow: scan product → select pet → rate → save
- Test editing existing log
- Test deleting log
- Test quick-log feature

## Definition of Done

- [ ] FeedingLog entity and model complete
- [ ] Database schema with feeding_logs table and indexes
- [ ] FeedingLog repository with all query methods
- [ ] Feeding log provider with state management
- [ ] Feeding log form with validation
- [ ] Rating system with visual feedback
- [ ] Photo capture and storage
- [ ] Feeding history views (pet and product)
- [ ] Filtering and sorting functionality
- [ ] Edit and delete operations
- [ ] Quick-log feature
- [ ] All unit tests passing with >80% coverage
- [ ] All widget tests passing
- [ ] Integration tests passing
- [ ] Code reviewed and merged to develop

## Dependencies and Blockers

**Dependencies:**
- Sprint 1 (Pet Management) complete
- Sprint 2 (Product Integration) complete

**Potential Blockers:**
- Database foreign key constraints
- Photo storage management
- Query performance with thousands of logs

## Notes

- Consider adding reminders for regular feeding times in future
- Could implement feeding schedule templates
- Rating system could be expanded with more granular options
- Consider adding tags or categories for different meal types
- Photo management should have size limits and cleanup routines

## Resources

- [SQLite Foreign Keys](https://www.sqlitetutorial.net/sqlite-foreign-key/)
- [Date/Time Picker Flutter](https://pub.dev/packages/flutter_datetime_picker)
- [Image Gallery Flutter](https://pub.dev/packages/photo_view)
