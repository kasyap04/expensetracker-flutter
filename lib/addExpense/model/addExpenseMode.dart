import '../../trackexpenses/model/database.dart';

Future<dynamic> getExpenseByTime(
    String cardType, String startDate, String endDate) async {
  int cardId = await getCardId(cardType);
  final db = await Sql.db();
  final List<Map<String, dynamic>> result = await db.rawQuery(
      "SELECT SUM(amount) AS sum FROM expense WHERE date >= ? AND date<= ? AND card = ? AND type = 0",
      [startDate, endDate, cardId]);

  if (result[0]['sum'] == null) {
    return 0;
  } else {
    return result[0]['sum'];
  }
}

Future<dynamic> getMonthlyExpenseByTime(
    String startDate, String endDate, int catId) async {
  final db = await Sql.db();
  final List<Map<String, dynamic>> result = await db.rawQuery(
      "SELECT SUM(amount) AS sum FROM expense WHERE date >= ? AND date<= ? AND category = ? AND type = 0",
      [startDate, endDate, catId]);

  if (result[0]['sum'] == null) {
    return 0;
  } else {
    return result[0]['sum'];
  }
}

Future<int> getCatgoryId(String name) async {
  final db = await Sql.db();
  List cat = await db.query('category',
      columns: ['id'], where: "name = ?", whereArgs: [name.trim()]);
  return cat[0]['id'];
}

Future<int> getCardId(String name) async {
  final db = await Sql.db();
  List cat = await db.query('card',
      columns: ['id'], where: "name = ?", whereArgs: [name.trim()]);
  return cat[0]['id'];
}

Future<bool> saveCardExpense(Map<String, dynamic> expense) async {
  try {
    final db = await Sql.db();
    await db.insert('expense', expense);
    return true;
  } catch (e) {
    print("ERROR => $e");
    return false;
  }
}

Future<bool> editExpende(Map<String, dynamic> expense) async {
  try {
    final db = await Sql.db();
    await db.update('expense', expense,
        where: "id = ?", whereArgs: [expense['id']]);
    return true;
  } catch (e) {
    return false;
  }
}

Future<bool> deleteExpense(int id) async {
  try {
    final db = await Sql.db();
    await db.delete('expense', where: "id = ?", whereArgs: [id]);
    return true;
  } catch (e) {
    return false;
  }
}
