import 'package:flutter/material.dart';
import 'package:trackexpense/addExpense/view/addExpenses.dart';
import '../../addExpense/model/addExpenseMode.dart';
import '../../expenseDetail/view/cardExpensesView.dart';
import '../../trackexpenses/controller/common.dart';
import 'cardView.dart';
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
              cardType: card,
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
              cardType: expData['card'],
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      home: Scaffold(
          appBar: AppBarView(
            icon: Icons.settings,
            iconClicked: () {},
          ),
          body: ListView(
            // padding: const EdgeInsets.only(left: 10, right: 10),
            children: [
              CardView(
                  cardPressed: (value) => cardClicked(context, value),
                  addExpensePressed: (value) =>
                      addExpenseClicked(context, value)),
              const Padding(padding: EdgeInsets.only(bottom: 20, top: 20)),
              ExpenseHistoryHome(
                deleteExpenseAction: (id) async =>
                    await deleteExpenseAction(context, id),
                editExpense: (expData) => editExpense(context, expData),
              )
            ],
          )),
    );
  }
}
