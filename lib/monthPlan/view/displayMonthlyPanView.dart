import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../addExpense/model/addExpenseMode.dart';
import '../../addExpense/view/addExpenses.dart';
import '../../trackexpenses/controller/colors.dart';
import '../../trackexpenses/view/appBarView.dart';
import '../../trackexpenses/view/commonWidget.dart';
import '../controller/monthlyPlanController.dart';
import '../model/monthlyPlanModel.dart';
import 'planMonthView.dart';

class DisplayMonthlyPlan extends StatefulWidget {
  final String action;
  DisplayMonthlyPlan({required this.action});
  @override
  State<DisplayMonthlyPlan> createState() => DisplayMonthlyPlanState();
}

class DisplayMonthlyPlanState extends State<DisplayMonthlyPlan> {
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
    var getBack = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => PlanMonth()));

    if (getBack == null) {
      setState(() {});
    }
  }

  void monthlyPlanPopupAction(choice) async {
    if (choice == 2) {
      dynamic res = await deleteMonthlyPlan(selectedPlanId);
      if (res != null) {
        setState(() {
          selectedPlanId = 0;
        });
      }
    }
  }

  Future<bool> onDismissExpense(BuildContext context,
      DismissDirection direction, Map expData, int catId) async {
    bool status = false;
    if (direction == DismissDirection.endToStart) {
      // status = false;
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      child: Text("Not now",
                          style: TextStyle(color: AppColor().lightgrey))),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                        // await widget.deleteExpenseAction(expData['id']);
                      },
                      child: Text(
                        "Yes, delete",
                        style: TextStyle(color: AppColor().primary),
                      ))
                ],
                title: const Text("Delete?", textAlign: TextAlign.center),
                content: const Text(
                  "Are you sure you want to delete this?",
                  textAlign: TextAlign.center,
                ),
              )).then((value) async {
        status = value;
        if (value) {
          status = await deleteExpense(expData['id']);
          setState(() {});
        }
      });
    } else {
      Map<String, dynamic> monthlyPlan = {};
      for (var cat in activePlanCats) {
        if (cat['id'] == catId) {
          monthlyPlan['spend'] = cat['spend_amount'].toString();
          monthlyPlan['total'] = cat['estimat_amount'].toString();
          monthlyPlan['name'] = cat['expense_name'];
          monthlyPlan['catId'] = catId;
        }
      }
      // print(monthlyPlan);

      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AddExpenses(
                    editablemonthlyPlanCatData: expData,
                    monthlyPlanCatData: monthlyPlan,
                  )));
      status = false;
      setState(() {});
    }
    return status;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBarView(
              prevContext: context,
              hasBackButton: true,
              pageSlug: "vewaddmonthlyplan",
              actionPopup: MonthlyPlanPopUp(
                  monthlyPlanPopupAction: (choice) =>
                      monthlyPlanPopupAction(choice)),
            ),
            body: FutureBuilder(
              future: getActiveMontlyPlan(selectedPlanId),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.isEmpty && selectedPlanId == 0) {
                    return NoMonthlyPlanView(
                      createMonthlyPlanButon: () =>
                          createMonthlyPlanAction(context),
                    );
                  }
                  if (snapshot.data.isNotEmpty) {
                    activeMonthlyPlan = snapshot.data?[0];
                    activePlanCats = snapshot.data?[1];
                  }

                  if (selectedPlanId == 0) {
                    selectedPlanId = activeMonthlyPlan[0]['id'];
                  }

                  if (selectedCats.isEmpty && snapshot.data.isNotEmpty) {
                    for (var cat in activePlanCats) {
                      if (!selectedCats.contains(cat['id'])) {
                        selectedCats.add(cat['id']);
                      }
                    }
                  }

                  snapshot.data?.clear();

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
                          child: ExpenseHistory(
                            selectedCat: selectedCats,
                            expenseDismiss: (direction, expData, catId) async =>
                                await onDismissExpense(
                                    context, direction, expData, catId),
                          )),
                    ],
                  );
                  // }
                } else {
                  return CircularProgressIndicator();
                }
              },
            )));
  }
}

class ExpenseHistory extends StatefulWidget {
  final List selectedCat;
  final Future<bool> Function(
      DismissDirection direction, Map expData, int catId) expenseDismiss;
  ExpenseHistory({required this.selectedCat, required this.expenseDismiss});
  @override
  State<ExpenseHistory> createState() => ExpenseHistoryState();
}

class ExpenseHistoryState extends State<ExpenseHistory> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Expense history",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const Padding(padding: EdgeInsets.only(bottom: 15)),
        FutureBuilder(
            future: getMonthlyExpenseList(widget.selectedCat),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // print(snapshot.data);

                if (snapshot.data.isNotEmpty) {
                  List<Widget> listChildren = <Widget>[];

                  for (var exp in snapshot.data) {
                    var formattedDate = DateFormat("HH:mm:ss")
                        .parse(exp['date'].substring(11, exp['date'].length));

                    String time = DateFormat("hh:ss a").format(formattedDate);
                    String date = exp['date'].substring(0, 11);

                    listChildren.add(ExpenseListView(
                      id: exp['id'],
                      amount: exp['amount'].toString(),
                      category: exp['name'],
                      card: exp['card'] ?? 0,
                      cardName: exp['card_name'],
                      date: DateFormat.yMMMd()
                          .format(DateFormat("yyy-MM-DD").parse(date)),
                      time: time,
                      expenseDismiss: (direction, expData) async => await widget
                          .expenseDismiss(direction, expData, exp['catId']),
                    ));
                  }

                  return Container(
                    decoration: BoxDecoration(
                        color: AppColor().mildPrimary,
                        borderRadius: BorderRadius.circular(8)),
                    child: ListView(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      children: listChildren,
                    ),
                  );
                } else {
                  return Center(
                    child: Text(
                      "No epxneses to show",
                      style: TextStyle(color: AppColor().lightgrey),
                    ),
                  );
                }
              } else {
                return CircularProgressIndicator();
              }
            })
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
      physics: NeverScrollableScrollPhysics(),
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
          PrimaryButton(
            action: createMonthlyPlanButon,
            buttonLabel: "Create monthly plan",
          )
        ],
      ),
    );
  }
}

class MonthlyPlanPopUp extends StatelessWidget {
  final void Function(int choice) monthlyPlanPopupAction;
  MonthlyPlanPopUp({required this.monthlyPlanPopupAction});
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        iconSize: 20,
        icon: const Icon(
          Icons.more_vert,
          color: Color.fromARGB(255, 0, 0, 0),
          size: 24,
        ),
        onSelected: (choice) => monthlyPlanPopupAction(choice),
        itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: Row(children: [
                  Icon(
                    Icons.edit,
                    color: AppColor().lightgrey,
                    size: 20,
                  ),
                  const Padding(padding: EdgeInsets.only(left: 12)),
                  const Text("Edit selected plan")
                ]),
              ),
              PopupMenuItem(
                value: 2,
                child: Row(children: [
                  Icon(
                    Icons.delete,
                    color: AppColor().lightgrey,
                    size: 20,
                  ),
                  const Padding(padding: EdgeInsets.only(left: 12)),
                  const Text("Delete selected plan")
                ]),
              ),
            ]);
  }
}

class ExpenseListView extends StatelessWidget {
  final int id;
  final String category;
  final String amount;
  final String date;
  final String time;
  final int card;
  final String cardName;
  final Future<bool> Function(DismissDirection direction, Map expData)
      expenseDismiss;
  ExpenseListView(
      {required this.category,
      required this.id,
      required this.amount,
      required this.date,
      required this.card,
      required this.cardName,
      required this.expenseDismiss,
      required this.time});
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> expData = {'id': id, 'amount': amount, 'card': card};
    List<Widget> firstColum = <Widget>[
      Text(
        "$category",
        style: const TextStyle(fontSize: 17),
      )
    ];

    if (cardName.isNotEmpty) {
      firstColum.add(const Padding(padding: EdgeInsets.only(bottom: 2)));
      firstColum.add(Text(
        "${cardName[0].toUpperCase()}${cardName.substring(1).toLowerCase()} card",
        style: TextStyle(color: AppColor().lightgrey, fontSize: 12),
      ));
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Dismissible(
        key: UniqueKey(),
        confirmDismiss: (direction) async =>
            await expenseDismiss(direction, expData),
        secondaryBackground: const ColoredBox(
            color: Colors.redAccent,
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
            )),
        background: ColoredBox(
            color: AppColor().secondary,
            child: const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
              ),
            )),
        child: Container(
          margin: const EdgeInsets.only(bottom: 7, top: 7),
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: firstColum),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Icon(
                    Icons.currency_rupee,
                    size: 15,
                  ),
                  Text(amount, style: const TextStyle(fontSize: 17))
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(date),
                  const Padding(padding: EdgeInsets.only(bottom: 2)),
                  Text(
                    time,
                    style: const TextStyle(fontSize: 12),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
