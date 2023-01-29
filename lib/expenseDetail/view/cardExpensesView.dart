import 'package:flutter/material.dart';
import 'package:trackexpense/trackexpenses/view/appBarView.dart';

class CardExpenses extends StatefulWidget {
  final String cardType;
  CardExpenses({required this.cardType});

  @override
  State<CardExpenses> createState() => CardExpensesState();
}

class CardExpensesState extends State<CardExpenses> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBarView(
            hasBackButton: true,
            prevContext: context,
          ),
          body: Center(
            child: Text("ALL YOUR EXPENSES ${widget.cardType}"),
          ),
        ));
  }
}
