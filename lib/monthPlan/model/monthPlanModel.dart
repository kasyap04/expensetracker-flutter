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
