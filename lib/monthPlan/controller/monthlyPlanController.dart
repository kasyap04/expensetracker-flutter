import 'package:intl/intl.dart';

import '../model/monthPlanModel.dart';

Future<dynamic> getActiveMontlyPlan(int planId) async {
  var today = DateFormat("yyy-MM-dd").format(DateTime.now());
  dynamic monthlyPlanData = await monthlyPlan(today);

  if (planId == 0 && monthlyPlanData.isNotEmpty) {
    planId = monthlyPlanData[0]['id'];
  }

  dynamic expensecategoies = await getPlanData(planId);

  return [monthlyPlanData, expensecategoies];
}

Future<dynamic> getPlanDataByPlanId(int planid) async {
  return await getPlanData(planid);
}
