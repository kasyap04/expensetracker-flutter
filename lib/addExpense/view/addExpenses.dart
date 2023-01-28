import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../controller/addExpenseController.dart';
import 'cardWidgetView.dart';
import '../../trackexpenses/view/appBarView.dart';
import 'expenseFeildsView.dart';

class AddExpenses extends StatefulWidget {
  final String cardType;
  AddExpenses({required this.cardType});
  @override
  State<AddExpenses> createState() => AddExpensesState();
}

class AddExpensesState extends State<AddExpenses> {
  final formKey = GlobalKey<FormState>();
  final scaffolMessengerKey = GlobalKey<ScaffoldMessengerState>();

  TextEditingController expenseController = TextEditingController();
  TextEditingController tagController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  String totalExpense = "0";
  String expenseTime = "Today";

  @override
  void initState() {
    super.initState();
    getCardDetailsByTime(expenseTime, widget.cardType).then((value) {
      setState(() {
        totalExpense = value;
      });
    }).catchError((error) => print(error));
  }

  void itemSelected(String value) {
    setState(() {
      expenseTime = value;
    });

    getCardDetailsByTime(expenseTime, widget.cardType).then((value) {
      setState(() {
        totalExpense = value;
      });
    }).catchError((error) => print(error));
  }

  void createSnackBar(BuildContext context, String msg) {
    final snackBar = SnackBar(
      elevation: 1,
      backgroundColor: Colors.white,
      behavior: SnackBarBehavior.floating,
      content: Text(
        msg,
        style: const TextStyle(color: Colors.black),
      ),
      // margin: const EdgeInsets.only(bottom: 100),
    );
    scaffolMessengerKey.currentState!.showSnackBar(snackBar);
  }

  void setCardExpense(BuildContext context) async {
    try {
      if (formKey.currentState!.validate()) {
        double expense = double.parse(expenseController.text.trim());
        String tag = tagController.text.trim();
        String description = descriptionController.text.trim();

        var today = DateTime.now();
        var date = DateFormat("yyyy-MM-dd").format(today);
        var time = DateFormat("hh:mm a").format(today);

        Map<String, dynamic> expenseData = {
          "amount": expense,
          "tag": tag,
          "desc": description,
          "date": date,
          "time": time
        };
        bool cardSaveStatus =
            await saveCardExpense(expenseData, widget.cardType);

        expenseController.text = "";
        tagController.text = "";
        descriptionController.text = "";

        if (cardSaveStatus) {
          createSnackBar(context, "New expense added");
        } else {
          createSnackBar(
              context, "Could not add your expense, try again later");
        }

        getCardDetailsByTime("Today", widget.cardType).then((value) {
          setState(() => totalExpense = value);
        }).catchError((error) => print(error));
      }
    } catch (e) {
      print("ERROR => $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: scaffolMessengerKey,
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
                expense: totalExpense,
                expenseTime: expenseTime,
                itemSelected: (value) => itemSelected(value),
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
              onPressed: () {
                setCardExpense(context);
              },
              child: const Text(
                "Save expense",
                style: TextStyle(fontSize: 26),
              )),
        ),
      ),
    );
  }
}
