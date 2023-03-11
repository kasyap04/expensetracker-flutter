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

    var result = [];

    for (var plan_data in res) {
      var totalExpenseQry = await db.rawQuery(
          "SELECT SUM(amount) AS sum FROM expense WHERE category = ? AND type = 0",
          [plan_data['id']]);

      String totalExpense = "0";

      if (totalExpenseQry[0]['sum'] == null) {
        totalExpense = "0";
      } else {
        totalExpense = totalExpenseQry[0]['sum'].toString();
      }

      result.add({
        "id": plan_data["id"],
        "expense_name": plan_data["expense_name"],
        "spend_amount": totalExpense,
        "estimat_amount": plan_data["estimat_amount"],
        "plan_id": plan_data["plan_id"]
      });
    }

    return result;
  } catch (e) {
    print("ERROR monthlyPlan => $e");
  }
}

Future<dynamic> getExpenseList(List expList) async {
  try {
    final db = await Sql.db();
    dynamic result = [];
    var res = await db.query('expense',
        where: "monthly_plan = ? AND category IN (${expList.join(',')})",
        whereArgs: [1]);

    for (var exp in res) {
      List card = await db.query('card',
          columns: ['name'], where: "id = ?", whereArgs: [exp['card']]);
      result.add({
        'id': exp['id'],
        'name': exp['name'],
        'amount': exp['amount'],
        'card': exp['card'],
        'card_name': card.isEmpty ? "" : card[0]['name'],
        'date': exp['date'],
        'catId': exp['category']
      });
    }

    return result;
  } catch (e) {
    print(e);
  }
}
