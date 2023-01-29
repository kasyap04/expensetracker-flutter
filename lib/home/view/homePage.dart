import 'package:flutter/material.dart';
import 'package:trackexpense/addExpense/view/addExpenses.dart';
// import 'package:trackexpense/trackexpenses/controller/common.dart';
import 'cardView.dart';
import '../../trackexpenses/view/appBarView.dart';
import 'expenseHostoryView.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // removeAll();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBarView(
            icon: Icons.settings,
            iconClicked: () {},
          ),
          body: ListView(
            // padding: const EdgeInsets.only(left: 10, right: 10),
            children: [
              const CardView(),
              const Padding(padding: EdgeInsets.only(bottom: 20, top: 20)),
              ExpenseHistoryHome()
            ],
          )),
    );
  }
}
