// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';

// class TableDb {
//   static Database? _database;

//   Future<Database> get database async {
//     if (_database != null) return _database!;

//     _database = await initDatabase();
//     return _database!;
//   }

//   Future<Database> initDatabase() async {
//     String path = await getDatabasesPath();
//     return openDatabase(
//       join(path, 'your_database.db'),
//       onCreate: (db, version) {
//         return db.execute(
//           "CREATE TABLE entries(id INTEGER PRIMARY KEY AUTOINCREMENT, amount TEXT, month TEXT, category TEXT)",
//         );
//       },
//       version: 1,
//     );
//   }

//   Future<void> insertEntry(Map<String, dynamic> entry) async {
//     final db = await database;
//     await db.insert(
//       'entries',
//       entry,
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//   }

//   // Future<void> updateEntry(Map<String, String> updatedEntry) async {
//   //   final db = await database;

//   //   // Prepare the update values
//   //   String amount = updatedEntry['amount']!;
//   //   String month = updatedEntry['month']!;
//   //   String category = updatedEntry['category']!;

//   //   // Define the where clause to identify the record to update
//   //   String whereClause = 'amount = ? AND month = ? AND category = ?';
//   //   List<dynamic> whereArgs = [amount, month, category];

//   //   // Perform the update operation
//   //   await db.update(
//   //     'entries',
//   //     updatedEntry,
//   //     where: whereClause,
//   //     whereArgs: whereArgs,
//   //   );
//   // }
//   Future<void> updateEntry(int id, Map<String, dynamic> updatedEntry) async {
//     final db = await database;
//     await db.update(
//       'entries',
//       updatedEntry,
//       where: 'id = ?',
//       whereArgs: [id],
//     );
//   }

//   Future<void> deleteEntry(String amount, String month, String category) async {
//     final db = await database;
//     await db.delete(
//       'entries',
//       where: 'amount = ? AND month = ? AND category = ?',
//       whereArgs: [amount, month, category],
//     );
//   }

//   Future<List<Map<String, dynamic>>> getAllEntries() async {
//     final db = await database;
//     return db.query('entries');
//   }
// }
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TableDb {
  Future<Database> get database async {
    return openDatabase(
      join(await getDatabasesPath(), 'budget.db'),
      onCreate: (db, version) {
        return db.execute(
          '''
          CREATE TABLE budget_entries (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            amount TEXT,
            month TEXT,
            year TEXT,
            category TEXT
          )
          ''',
        );
      },
      version: 1,
    );
  }

  Future<void> insertEntry(Map<String, String> entry) async {
    final db = await database;
    await db.insert(
      'budget_entries',
      {
        'amount': entry['amount'],
        'month': entry['month'],
        'year': entry['year'],
        'category': entry['category'],
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateEntry(int id, Map<String, String> entry) async {
    final db = await database;
    await db.update(
      'budget_entries',
      {
        'amount': entry['amount'],
        'month': entry['month'],
        'year': entry['year'],
        'category': entry['category'],
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteEntry(
      String amount, String month, String category, String year) async {
    final db = await database;
    await db.delete(
      'budget_entries',
      where: 'amount = ? AND month = ? AND category = ? AND year = ?',
      whereArgs: [amount, month, category, year],
    );
  }

  Future<List<Map<String, dynamic>>> fetchEntries() async {
    final db = await database;
    return await db.query('budget_entries');
  }
}
