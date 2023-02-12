import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../controller/addExpenseController.dart';
import '../model/addExpenseMode.dart';
import 'cardWidgetView.dart';
import '../../trackexpenses/view/appBarView.dart';
import 'expenseFeildsView.dart';

class AddExpenses extends StatefulWidget {
  final String cardType;
  late Map? editableExpense;
  AddExpenses({required this.cardType, this.editableExpense});
  @override
  State<AddExpenses> createState() => AddExpensesState();
}

class AddExpensesState extends State<AddExpenses> {
  final formKey = GlobalKey<FormState>();
  final scaffolMessengerKey = GlobalKey<ScaffoldMessengerState>();

  TextEditingController expenseController = TextEditingController();
  TextEditingController tagController = TextEditingController();
  TextEditingController categoryController = TextEditingController();

  String totalExpense = "0";
  String expenseTime = "Today";

  String saveBtnText = "Save expense";
  int transactionType = 0;

  Color incomeTextColor = Colors.black;
  Color incomBgColor = const Color.fromARGB(255, 207, 207, 207);
  Color expenseTextColor = Colors.white;
  Color expenseBgColor = const Color.fromARGB(255, 103, 34, 112);

  @override
  void initState() {
    super.initState();

    if (widget.editableExpense != null) {
      transactionType = widget.editableExpense!['type'];
      expenseController.text = widget.editableExpense!['amount'].toString();
      tagController.text = widget.editableExpense!['spend'];
      categoryController.text = widget.editableExpense!['category'];
      saveBtnText = "Save changes";
    }

    if (transactionType == 0) {
      incomeTextColor = Colors.black;
      incomBgColor = const Color.fromARGB(255, 207, 207, 207);

      expenseTextColor = Colors.white;
      expenseBgColor = const Color.fromARGB(255, 103, 34, 112);
    } else {
      incomeTextColor = Colors.white;
      incomBgColor = const Color.fromARGB(255, 103, 34, 112);
      expenseTextColor = Colors.black;
      expenseBgColor = const Color.fromARGB(255, 207, 207, 207);
    }

    getCardDetailsByTimeFlag(expenseTime, widget.cardType).then((value) {
      setState(() {
        totalExpense = value;
      });
    }).catchError((error) => print(error));
  }

  void itemSelected(String value) {
    setState(() {
      expenseTime = value;
    });

    getCardDetailsByTimeFlag(expenseTime, widget.cardType).then((value) {
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
        String category = categoryController.text;

        var date;
        if (widget.editableExpense != null) {
          date = widget.editableExpense!['date'];
        } else {
          date = DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());
        }

        int categoryId = await getCatgoryId(category);
        int cardId = await getCardId(widget.cardType);

        Map<String, dynamic> expenseData = {
          "name": tag,
          "amount": expense,
          'card': cardId,
          'category': categoryId,
          "date": date,
          "type": transactionType
        };

        bool cardSaveStatus;

        if (widget.editableExpense != null) {
          expenseData['id'] = widget.editableExpense!['id'];
          cardSaveStatus = await editExpende(expenseData);
        } else {
          cardSaveStatus = await saveCardExpense(expenseData);
        }

        if (widget.editableExpense == null && cardSaveStatus) {
          expenseController.text = "";
          tagController.text = "";
          categoryController.text = "";
        }

        if (cardSaveStatus) {
          createSnackBar(
              context,
              (widget.editableExpense == null)
                  ? "New expense added"
                  : "Changes saved");
        } else {
          createSnackBar(
              context, "Could not add your expense, try again later");
        }

        getCardDetailsByTimeFlag("Today", widget.cardType).then((value) {
          setState(() => totalExpense = value);
        }).catchError((error) => print(error));
      }
    } catch (e) {
      print("ERROR => $e");
    }
  }

  void transactionSelected(int typeId) {
    setState(() {
      transactionType = typeId;
      print("type = $transactionType");
      if (typeId == 0) {
        incomeTextColor = Colors.black;
        incomBgColor = const Color.fromARGB(255, 207, 207, 207);

        expenseTextColor = Colors.white;
        expenseBgColor = const Color.fromARGB(255, 103, 34, 112);
      } else {
        incomeTextColor = Colors.white;
        incomBgColor = const Color.fromARGB(255, 103, 34, 112);
        expenseTextColor = Colors.black;
        expenseBgColor = const Color.fromARGB(255, 207, 207, 207);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: scaffolMessengerKey,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBarView(
          hasBackButton: true,
          prevContext: context,
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
                  expenseController: expenseController,
                  tagController: tagController,
                  categoryController: categoryController,
                  expenseBgColor: expenseBgColor,
                  expenseTextColor: expenseTextColor,
                  incomBgColor: incomBgColor,
                  incomeTextColor: incomeTextColor,
                  transactionType: (id) => transactionSelected(id),
                  callSnackbar: (msg) => createSnackBar(context, msg)),
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
              child: Text(
                saveBtnText,
                style: const TextStyle(fontSize: 26),
              )),
        ),
      ),
    );
  }
}
