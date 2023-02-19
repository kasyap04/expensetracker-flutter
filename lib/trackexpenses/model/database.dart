import 'package:sqflite/sqflite.dart';

class Sql {
  static Future<bool> checkDataSet() async {
    final db = await Sql.db();
    var checkCards = await db.query('card', groupBy: "id");
    if (checkCards.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  static Future<Database> db() async {
    return openDatabase(
      'expense.db',
      version: 1,
      onCreate: (Database db, int version) async {
        await createTableCategory(db);
        await createTableCard(db);
        await createTableExpense(db);
        await createTablePlan(db);
        await createTablePlanData(db);
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
        type INT NOT NULL, 
        monthly_plan INT,     
        date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """); // type => expense = 0; income = 1 :::   monthly_plan => true = 1 ;  false = (0/NULL)
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

  static Future<void> createTablePlan(Database database) async {
    await database.execute("""
    CREATE TABLE plan(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      total_amount FLOAT,
      start_date TIMESTAMP,
      end_date TIMESTAMP
    )
""");
  }

  static Future<void> createTablePlanData(Database database) async {
    await database.execute("""
      CREATE TABLE plan_data(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        expense_name TEXT,
        spend_amount FLOAT,
        estimat_amount FLOAT,
        plan_id int
      )
""");
  }
}
