import '../../trackexpenses/model/database.dart';

Future<int> createMonthlyPlan(Map<String, dynamic> plan) async {
  try {
    final db = await Sql.db();
    int id = await db.insert('plan', plan);
    return id;
  } catch (e) {
    print("ERROR createMonthlyPlan => $e");

    return 0;
  }
}

Future<bool> createPlanData(List<Map<String, dynamic>> planData) async {
  try {
    final db = await Sql.db();

    for (int i = 0; i < planData.length; i++) {
      print(planData[i]);
      await db.insert('plan_data', planData[i]);
    }
    return true;
  } catch (e) {
    print("ERROR createPlanData => $e");
    return false;
  }
}

Future<dynamic> monthlyPlan(String date) async {
  try {
    final db = await Sql.db();
    // var res = await db.rawQuery(
    //     "SELECT * FROM plan AS p JOIN plan_data AS pd ON p.id = pd.plan_id WHERE p.start_date <= '$date' AND p.end_date >= '$date'");

    var res = await db.query('plan',
        where: "start_date <= ? AND end_date  >= ?", whereArgs: [date, date]);

    return res;
  } catch (e) {
    print("ERROR monthlyPlan => $e");
  }
}

Future<dynamic> getPlanData(int id) async {
  try {
    final db = await Sql.db();

    var res =
        await db.query('plan_data', where: "plan_id = ?", whereArgs: [id]);

    return res;
  } catch (e) {
    print("ERROR monthlyPlan => $e");
  }
}
