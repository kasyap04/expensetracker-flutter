import 'package:flutter/material.dart';
import 'package:trackexpense/addExpense/view/addExpenses.dart';
import 'package:trackexpense/home/view/totalExpenseView.dart';
import '../../addExpense/model/addExpenseMode.dart';
// import '../../addExpense/view/cardWidgetView.dart';
import '../../expenseDetail/view/cardExpensesView.dart';
import '../../monthPlan/model/displayMonthlyPanView.dart';
import '../../monthPlan/view/planMonthView.dart';
// import '../../monthPlan/view/showMonthlyPlanView.dart';
// import '../../trackexpenses/controller/common.dart';
import 'NavSectionView.dart';
// import 'cardView.dart';
import '../../trackexpenses/view/appBarView.dart';
import 'expenseHistoryView.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final navigatorKey = GlobalKey<NavigatorState>();

  void addExpenseClicked(BuildContext context, String card) async {
    final NavigatorState? navigator = navigatorKey.currentState;
    var getBack = await navigator!.push(MaterialPageRoute(
        builder: (context) => AddExpenses(
            // cardType: card,
            )));

    if (getBack == null) {
      setState(() {});
    }
  }

  void cardClicked(BuildContext context, String card) async {
    final NavigatorState? navigator = navigatorKey.currentState;

    var getBack = await navigator!.push(MaterialPageRoute(
        builder: (context) => CardExpenses(
              cardType: card,
            )));
    if (getBack == null) {
      setState(() {});
    }
  }

  void editExpense(BuildContext context, Map expData) async {
    final NavigatorState? navigator = navigatorKey.currentState;
    var getBack = await navigator!.push(MaterialPageRoute(
        builder: (context) => AddExpenses(
              // cardType: expData['card'],
              editableExpense: expData,
            )));

    if (getBack == null) {
      setState(() {});
    }
  }

  Future<bool> deleteExpenseAction(BuildContext context, int id) async {
    bool status = false;
    status = await deleteExpense(id);

    if (status) {
      setState(() {});
    }
    return status;
  }

  void popUpClicked(int value) async {
    final NavigatorState? navigator = navigatorKey.currentState;
    var getBack = await navigator!
        .push(MaterialPageRoute(builder: (context) => PlanMonth()));

    if (getBack == null) {
      setState(() {});
    }
  }

  void optionPressed(int index) async {
    final NavigatorState? navigator = navigatorKey.currentState;
    var getBack;
    if (index == 1) {
      getBack = await navigator!
          .push(MaterialPageRoute(builder: (context) => PlanMonth()));
    } else if (index == 2) {
      getBack = await navigator!.push(MaterialPageRoute(
          builder: (context) => DisplayMonthlyPlan(
                action: "add",
              )));
    } else if (index == 3) {
      getBack = await navigator!.push(MaterialPageRoute(
          builder: (context) => DisplayMonthlyPlan(action: "view")));
    }

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
            pageSlug: "homepage",
            popUpClicked: (value) => popUpClicked(value),
          ),
          body: ListView(
            padding: const EdgeInsets.only(left: 10, right: 10),
            children: [
              TotalExpenseView(
                  expenseType: "normal",
                  expense: "2342",
                  expenseTime: "Today",
                  expenseTypeButtonAction: (val) {},
                  itemSelected: (val) {}),
              NavSectionView(
                optionPressed: (index) => optionPressed(index),
                navheader: "Plan my month",
                slug: "monthly",
              ),
              const Padding(padding: EdgeInsets.only(bottom: 20)),
              NavSectionView(
                optionPressed: (index) => optionPressed(index),
                navheader: "Other expense",
                slug: "normal",
              ),
              // ViewAllMonthlyExpense(),
              // CardView(
              //     cardPressed: (value) => cardClicked(context, value),
              //     addExpensePressed: (value) =>
              //         addExpenseClicked(context, value)),
              // const Padding(padding: EdgeInsets.only(bottom: 20, top: 20)),
              // ExpenseHistoryHome(
              //   deleteExpenseAction: (id) async =>
              //       await deleteExpenseAction(context, id),
              //   editExpense: (expData) => editExpense(context, expData),
              // )
            ],
          )),
    );
  }
}
