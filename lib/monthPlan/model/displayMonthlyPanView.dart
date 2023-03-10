import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../addExpense/view/addExpenses.dart';
import '../../trackexpenses/controller/colors.dart';
import '../../trackexpenses/view/appBarView.dart';
import '../controller/monthlyPlanController.dart';
import '../view/planMonthView.dart';

class DisplayMonthlyPlan extends StatefulWidget {
  final String action;
  DisplayMonthlyPlan({required this.action});
  @override
  State<DisplayMonthlyPlan> createState() => DisplayMonthlyPlanState();
}

class DisplayMonthlyPlanState extends State<DisplayMonthlyPlan> {
  final navigatorKey = GlobalKey<NavigatorState>();

  dynamic activeMonthlyPlan;
  dynamic activePlanCats;
  int selectedPlanId = 0;
  List<int> selectedCats = <int>[];

  String pageHeader = "My monthly plans";
  @override
  void initState() {
    super.initState();

    if (widget.action == "add") {
      pageHeader = "Add my expense";
    }
  }

  void showExpansesByPlan(int id) {
    setState(() {
      selectedCats.clear();
      selectedPlanId = id;
    });
  }

  void categoryPressed(
      int catId, Map<String, dynamic> monthlyPlanCatData) async {
    if (widget.action == "add") {
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AddExpenses(
                    monthlyPlanCatData: monthlyPlanCatData,
                  )));

      setState(() {});
    } else {
      setState(() {
        if (selectedCats.contains(catId)) {
          selectedCats.remove(catId);
        } else {
          selectedCats.add(catId);
        }
      });
    }
  }

  void createMonthlyPlanAction(BuildContext context) async {
    final NavigatorState? navigator = navigatorKey.currentState;
    var getBack = await navigator!
        .push(MaterialPageRoute(builder: (context) => PlanMonth()));

    if (getBack == null) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        home: Scaffold(
            appBar: AppBarView(
              prevContext: context,
              hasBackButton: true,
            ),
            body: FutureBuilder(
              future: getActiveMontlyPlan(selectedPlanId),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.isNotEmpty) {
                    activeMonthlyPlan = snapshot.data?[0];
                    activePlanCats = snapshot.data?[1];
                  }

                  if (selectedCats.isEmpty && snapshot.data.isNotEmpty) {
                    for (var cat in activePlanCats) {
                      if (!selectedCats.contains(cat['id'])) {
                        selectedCats.add(cat['id']);
                      }
                    }
                  }

                  snapshot.data?.clear();

                  if (snapshot.data.isEmpty) {
                    return NoMonthlyPlanView(
                      createMonthlyPlanButon: () =>
                          createMonthlyPlanAction(context),
                    );
                  } else {
                    return ListView(
                      padding: const EdgeInsets.all(10),
                      children: [
                        Text(
                          pageHeader,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        PlanListView(
                          planSelected: (int id) => showExpansesByPlan(id),
                          planList: activeMonthlyPlan,
                        ),
                        const Padding(padding: EdgeInsets.only(bottom: 40)),
                        ExpenseCategories(
                          selectedCats: selectedCats,
                          selectedPlan: activePlanCats,
                          categoryPressed:
                              (int catId, Map<String, dynamic> catData) =>
                                  categoryPressed(catId, catData),
                        ),
                        const Padding(padding: EdgeInsets.only(bottom: 40)),
                        Visibility(
                            visible: widget.action == "view" ? true : false,
                            child: ExpenseHistory()),
                      ],
                    );
                  }
                } else {
                  return CircularProgressIndicator();
                }
              },
            )));
  }
}

class ExpenseHistory extends StatefulWidget {
  @override
  State<ExpenseHistory> createState() => ExpenseHistoryState();
}

class ExpenseHistoryState extends State<ExpenseHistory> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text("Expense history",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class ExpenseCategories extends StatefulWidget {
  late dynamic selectedPlan;
  late List<int> selectedCats;
  late void Function(int catId, Map<String, dynamic> catData) categoryPressed;
  ExpenseCategories(
      {required this.selectedPlan,
      required this.selectedCats,
      required this.categoryPressed});
  @override
  State<ExpenseCategories> createState() => ExpenseCategoriesState();
}

class ExpenseCategoriesState extends State<ExpenseCategories> {
  void expensePressed(int id) {}

  @override
  Widget build(BuildContext context) {
    List<Widget> planList = <Widget>[];

    for (var plan_data in widget.selectedPlan) {
      // print(plan_data);
      planList.add(ExpenseCategoriesChild(
        selected: widget.selectedCats.contains(plan_data['id']) ? true : false,
        spend: plan_data['spend_amount'].toString(),
        total: plan_data['estimat_amount'].toString(),
        name: plan_data['expense_name'],
        expensePressed: (int id, Map<String, dynamic> catData) =>
            widget.categoryPressed(id, catData),
        planDataId: plan_data['id'],
      ));
    }

    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: (1 / .45),
      shrinkWrap: true,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: planList,
    );
  }
}

class ExpenseCategoriesChild extends StatelessWidget {
  final bool selected;
  final String spend, total, name;
  final int planDataId;
  final void Function(int id, Map<String, dynamic> catData) expensePressed;
  ExpenseCategoriesChild(
      {required this.selected,
      required this.spend,
      required this.total,
      required this.expensePressed,
      required this.planDataId,
      required this.name});
  @override
  Widget build(BuildContext context) {
    // print("GET DATA = $name");
    return Container(
      decoration: BoxDecoration(
          color:
              selected == true ? AppColor().secondary : AppColor().mildPrimary,
          borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        onTap: () => expensePressed(planDataId, {
          "spend": spend,
          "total": total,
          "name": name,
          "catId": planDataId
        }),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.currency_rupee,
                    size: 13, color: AppColor().montlyPlanCatColor),
                Text(
                  spend,
                  style: TextStyle(
                      fontSize: 18,
                      color: selected == true
                          ? AppColor().white
                          : AppColor().black),
                ),
                Text("/",
                    style: TextStyle(
                        color: AppColor().montlyPlanCatColor, fontSize: 20)),
                Icon(Icons.currency_rupee,
                    size: 10, color: AppColor().montlyPlanCatColor),
                Text(total,
                    style: TextStyle(
                        fontSize: 13,
                        color: selected == true
                            ? AppColor().rupeeOnPrimaryColor
                            : AppColor().black)),
              ],
            ),
            const Padding(padding: EdgeInsets.only(bottom: 5)),
            Text(
              name,
              style:
                  TextStyle(fontSize: 12, color: AppColor().montlyPlanCatColor),
            ),
          ],
        ),
      ),
    );
  }
}

class PlanListView extends StatefulWidget {
  final dynamic planList;
  final void Function(int planId) planSelected;
  PlanListView({required this.planList, required this.planSelected});
  @override
  State<PlanListView> createState() => PlanListViewState();
}

class PlanListViewState extends State<PlanListView> {
  int selectedId = 0;

  String formatDate(String date) {
    var d = DateFormat("yyy-MM-DD").parse(date);
    return DateFormat.yMMMd().format(d);
  }

  void planPressed(int id) {
    setState(() {
      selectedId = id;
    });
    widget.planSelected(id);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> planList = <Widget>[];

    int index = 0;
    for (var i in widget.planList) {
      planList.add(PlanListChild(
          selected: selectedId == 0
              ? (index == 0 ? true : false)
              : selectedId == i['id']
                  ? true
                  : false,
          planId: i['id'],
          fromDate: formatDate(i['start_date']),
          toDate: formatDate(i['end_date']),
          totalAMount: i['total_amount'].toString(),
          planPressed: (int id) => planPressed(id)));
      index++;
    }
    return Container(
      constraints: const BoxConstraints(maxHeight: 100, minHeight: 10),
      margin: const EdgeInsets.only(top: 20),
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: planList,
      ),
    );
  }
}

class PlanListChild extends StatelessWidget {
  final String fromDate, toDate, totalAMount;
  final int planId;
  bool? selected = false;
  final void Function(int id) planPressed;
  PlanListChild(
      {required this.fromDate,
      required this.toDate,
      required this.totalAMount,
      required this.planId,
      this.selected,
      required this.planPressed});

  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.only(left: 5, right: 5),
      constraints: const BoxConstraints(maxHeight: 100, minHeight: 10),
      decoration: BoxDecoration(
          color: AppColor().mildPrimary,
          borderRadius: BorderRadius.circular(8),
          border: selected == true
              ? Border.all(width: 2, color: AppColor().primary)
              : Border.all(width: 2, color: Colors.transparent)),
      child: InkWell(
        onTap: () => planPressed(planId),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.calendar_month,
                  color: AppColor().primary,
                  size: 18,
                ),
                Text("From $fromDate", style: const TextStyle(fontSize: 12))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.currency_rupee,
                  color: AppColor().lightgrey,
                  size: 15,
                ),
                Text(totalAMount, style: const TextStyle(fontSize: 20))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.calendar_month,
                  color: AppColor().primary,
                  size: 18,
                ),
                Text(
                  "To $toDate",
                  style: const TextStyle(fontSize: 12),
                )
              ],
            )
          ],
        ),
      ));
}

class NoMonthlyPlanView extends StatelessWidget {
  final void Function() createMonthlyPlanButon;
  NoMonthlyPlanView({required this.createMonthlyPlanButon});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("You don't have a monthly plan",
              style: TextStyle(color: AppColor().lightgrey)),
          const Padding(padding: EdgeInsets.only(bottom: 10)),
          ElevatedButton(
            onPressed: createMonthlyPlanButon,
            child: const Text("Create monthly plan"),
          )
        ],
      ),
    );
  }
}
