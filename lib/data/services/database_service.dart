import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/// Service for managing the SQLite database.
///
/// This service handles database initialization, migrations,
/// and provides access to the database instance.
class DatabaseService {
  static Database? _database;
  static const String _dbName = 'flavor_fetch.db';
  static const int _dbVersion = 1;

  /// Gets the database instance, initializing it if necessary.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Initializes the database.
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  /// Creates the database schema on first run.
  Future<void> _onCreate(Database db, int version) async {
    // Create pets table
    await db.execute('''
      CREATE TABLE pets (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        type TEXT NOT NULL,
        breed TEXT,
        birth_date TEXT,
        photo_path TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // Create index for common queries (alphabetical ordering)
    await db.execute('CREATE INDEX idx_pets_name ON pets(name)');

    // Create products table (for future sprints)
    await db.execute('''
      CREATE TABLE products (
        barcode TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        brand TEXT,
        ingredients TEXT,
        protein_source TEXT,
        flavor TEXT,
        nutrition_facts TEXT,
        image_url TEXT,
        cached_at TEXT NOT NULL
      )
    ''');

    // Create feeding_logs table (for future sprints)
    await db.execute('''
      CREATE TABLE feeding_logs (
        id TEXT PRIMARY KEY,
        pet_id TEXT NOT NULL,
        product_barcode TEXT NOT NULL,
        timestamp TEXT NOT NULL,
        rating TEXT NOT NULL,
        notes TEXT,
        created_at TEXT NOT NULL,
        FOREIGN KEY (pet_id) REFERENCES pets (id) ON DELETE CASCADE,
        FOREIGN KEY (product_barcode) REFERENCES products (barcode)
      )
    ''');

    // Create indexes for feeding_logs
    await db.execute(
      'CREATE INDEX idx_feeding_logs_pet_id ON feeding_logs(pet_id)',
    );
    await db.execute(
      'CREATE INDEX idx_feeding_logs_product ON feeding_logs(product_barcode)',
    );
    await db.execute(
      'CREATE INDEX idx_feeding_logs_date ON feeding_logs(timestamp)',
    );
  }

  /// Handles database schema migrations.
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle future migrations
    // Example:
    // if (oldVersion < 2) {
    //   await db.execute('ALTER TABLE pets ADD COLUMN weight REAL');
    // }
  }

  /// Closes the database connection.
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }

  /// Deletes the database (useful for testing).
  Future<void> deleteDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);
    await databaseFactory.deleteDatabase(path);
    _database = null;
  }
}
