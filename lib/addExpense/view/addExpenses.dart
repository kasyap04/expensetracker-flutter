import 'package:flutter/material.dart';
import 'package:trackexpense/addExpense/controller/addExpenseController.dart';
import 'package:trackexpense/addExpense/view/cardWidgetView.dart';
import '../../trackexpenses/view/appBarView.dart';
import 'expenseFeildsView.dart';
import 'package:intl/intl.dart';

class AddExpenses extends StatefulWidget {
  final String cardType;
  AddExpenses({required this.cardType});
  @override
  State<AddExpenses> createState() => AddExpensesState();
}

class AddExpensesState extends State<AddExpenses> {
  final formKey = GlobalKey<FormState>();

  TextEditingController expenseController = TextEditingController();
  TextEditingController tagController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // getCardDetails("today", widget.cardType);
  }

  void setCardExpense() {
    try {
      if (formKey.currentState!.validate()) {
        double expense = double.parse(expenseController.text.trim());
        String tag = tagController.text.trim();
        String description = descriptionController.text.trim();

        print("$expense  $tag  $description");
        var today = DateTime.now();
        print(DateFormat("yyyy-MM-dd").format(today));
        print(DateFormat("hh:mm a").format(today));
      }
    } catch (e) {
      print("ERROR => $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBarView(
          hasBackButton: true,
        ),
        body: Center(
          child: ListView(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 80),
            children: [
              CardWidget(
                menuPressed: () {},
                cardType: widget.cardType,
                expense: "12345",
                expenseTime: "Today",
              ),
              ExpenseFeild(
                  formKey: formKey,
                  descriptionController: descriptionController,
                  expenseController: expenseController,
                  tagController: tagController),
            ],
          ),
        ),
        bottomSheet: Container(
          width: MediaQuery.of(context).size.width - 20,
          margin: const EdgeInsets.only(left: 10, bottom: 10),
          height: 50,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: const Color.fromARGB(255, 126, 42, 122)),
              onPressed: setCardExpense,
              child: const Text(
                "Save expense",
                style: TextStyle(fontSize: 26),
              )),
        ),
      ),
    );
  }
}
