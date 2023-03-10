// import 'package:trackexpense/addExpense/model/addExpenseMode.dart';
import '../../addExpense/controller/addExpenseController.dart';
import '../../trackexpenses/model/database.dart';

Future<List> getSavedCards() async {
  final db = await Sql.db();
  final result = await db.query('card', where: "active = ?", whereArgs: [1]);

  return result;
}

Future<dynamic> getAllExpenses() async {
  final db = await Sql.db();
  final expenses = await db.rawQuery("""
  SELECT ex.id, ex.name as spend, ex.amount, ex.date, ex.type, c.name AS card, cat.name AS category FROM expense AS ex
  JOIN card AS c ON c.id = ex.card 
  JOIN category AS cat ON cat.id = ex.category ORDER BY ex.date DESC
""");

  return expenses;
}
