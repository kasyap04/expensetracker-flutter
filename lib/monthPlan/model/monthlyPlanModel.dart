import '../../trackexpenses/model/database.dart';

Future<bool> deleteMonthlyPlan(int id) async {
  final db = await Sql.db();
  try {
    await db.delete('plan_data', where: "plan_id = ?", whereArgs: [id]);
    await db.delete('expense',
        where: "category = ? AND monthly_plan = ?", whereArgs: [id, 1]);
    await db.delete('plan', where: "id = ?", whereArgs: [id]);
    return true;
  } catch (e) {
    print(e);
    return false;
  }
}
