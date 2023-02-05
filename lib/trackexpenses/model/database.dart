import 'package:sqflite/sqflite.dart';

class Sql {
  static Future<Database> db() async {
    return openDatabase(
      'expense.db',
      version: 1,
      onCreate: (Database db, int version) async {
        await createTableCategory(db);
        await createTableCard(db);
        await createTableExpense(db);
      },
    );
  }

  static Future<void> createTableExpense(Database database) async {
    await database.execute(""" 
      CREATE TABLE expense(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        amount FLOAT NOT NULL,
        card INT,
        category INT,
        date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }

  static Future<void> createTableCard(Database database) async {
    await database.execute("""
    CREATE TABLE card(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      active INT NOT NULL DEFAULT 1
    )
      """);
  }

  static Future<void> createTableCategory(Database database) async {
    await database.execute("""
    CREATE TABLE category (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      active INT NOT NULL DEFAULT 1
    )
    """);
  }

  static Future<bool> checkDataSet() async {
    final db = await Sql.db();
    var checkCards = await db.query('card', groupBy: "id");
    if (checkCards.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }
}
