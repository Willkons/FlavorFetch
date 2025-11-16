import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/// Service for managing SQLite database operations
class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() => _instance;

  DatabaseService._internal();

  /// Get database instance, creating it if necessary
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Initialize the database
  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'flavor_fetch.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  /// Create database tables
  Future<void> _onCreate(Database db, int version) async {
    // Products table
    await db.execute('''
      CREATE TABLE products (
        barcode TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        brand TEXT,
        image_url TEXT,
        local_image_path TEXT,
        ingredients TEXT,
        nutrition_facts TEXT,
        categories TEXT,
        is_manual_entry INTEGER DEFAULT 0,
        created_at TEXT NOT NULL,
        last_updated TEXT
      )
    ''');

    // Create indexes for better query performance
    await db.execute('CREATE INDEX idx_products_name ON products(name)');
    await db.execute('CREATE INDEX idx_products_brand ON products(brand)');
    await db.execute(
        'CREATE INDEX idx_products_updated ON products(last_updated)');
  }

  /// Handle database upgrades
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Database migration logic will be added here in future versions
    // For example:
    // if (oldVersion < 2) {
    //   await db.execute('ALTER TABLE products ADD COLUMN new_field TEXT');
    // }
  }

  /// Close the database connection
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }

  /// Delete the database (useful for testing)
  Future<void> deleteDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'flavor_fetch.db');
    await databaseFactory.deleteDatabase(path);
    _database = null;
  }
}
