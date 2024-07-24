import 'package:drp_dwn_check/model/category_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class CategoryDatabase {
  static final CategoryDatabase _instance = CategoryDatabase._internal();
  factory CategoryDatabase() => _instance;
  CategoryDatabase._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'categories.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        description TEXT,
        colorName TEXT
      )
    ''');
  }

  Future<void> insertCategory(Category category) async {
    final db = await database;
    await db.insert('categories', category.toMap());
  }

  Future<void> deleteCategory(int id) async {
    final db = await database;
    await db.delete('categories', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateCategory(Category category) async {
    final db = await database;
    await db.update('categories', category.toMap(),
        where: 'id = ?', whereArgs: [category.id]);
  }

////on july23 function
  Future<List<Category>> getCategoryById(String categoryId) async {
    // Get a reference to the database
    final db = await database;

    // Query the database for categories with the given ID
    final List<Map<String, dynamic>> maps = await db
        .rawQuery('SELECT * FROM categories WHERE id = ?', [categoryId]);

    // Generate and return a list of Category objects from the query results
    return List.generate(maps.length, (i) {
      return Category.fromMap(maps[i]);
    });
  }

  Future<List<Category>> getCategories() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('categories');
    return List.generate(maps.length, (i) {
      return Category.fromMap(maps[i]);
    });
  }
}
