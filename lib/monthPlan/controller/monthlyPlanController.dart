import 'package:intl/intl.dart';

import '../view/monthPlanModel.dart';

Future<dynamic> getActiveMontlyPlan(int planId) async {
  var today = DateFormat("yyy-MM-dd").format(DateTime.now());
  dynamic monthlyPlanData = await monthlyPlan(today);

  if (monthlyPlanData.isNotEmpty) {
    if (planId == 0) {
      planId = monthlyPlanData[0]['id'];
    }
    dynamic expensecategoies = await getPlanData(planId);
    return [monthlyPlanData, expensecategoies];
  } else {
    return [];
  }
}

Future<dynamic> getPlanDataByPlanId(int planid) async {
  return await getPlanData(planid);
}

Future<dynamic> getMonthlyExpenseList(List expList) async {
  return await getExpenseList(expList);
}
