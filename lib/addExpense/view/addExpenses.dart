import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../controller/addExpenseController.dart';
import '../model/addExpenseMode.dart';
import 'cardWidgetView.dart';
import '../../trackexpenses/view/appBarView.dart';
import 'expenseFeildsView.dart';

class AddExpenses extends StatefulWidget {
  late Map<String, dynamic>? monthlyPlanCatData;
  late Map? editablemonthlyPlanCatData;
  // final String cardType;
  late Map? editableExpense;
  AddExpenses(
      {this.editableExpense,
      this.monthlyPlanCatData,
      this.editablemonthlyPlanCatData});
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

  int selectedCard = 0;

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

    if (widget.editablemonthlyPlanCatData != null) {
      expenseController.text = widget.editablemonthlyPlanCatData?['amount'];
      selectedCard = widget.editablemonthlyPlanCatData?['card'];
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

    getMonthlyExpenseByTimeFlag(
        expenseTime, widget.monthlyPlanCatData!['catId']);

    // getCardDetailsByTimeFlag(expenseTime, widget.cardType).then((value) {
    //   setState(() {
    //     totalExpense = value;
    //   });
    // }).catchError((error) => print(error));
  }

  void getMonthlyExpenseByTimeFlag(String expenseTime, int catId) async {
    getMonthlyExpenseByTimeFlagController(expenseTime, catId).then((value) {
      setState(() {
        widget.monthlyPlanCatData!['spend'] = value;
      });
    }).catchError((error) => print(error));
  }

  void itemSelected(String value) {
    expenseTime = value;
    if (widget.monthlyPlanCatData != null) {
      getMonthlyExpenseByTimeFlag(
          expenseTime, widget.monthlyPlanCatData!['catId']);
    }
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

  void dropdownSelected(int value) {
    selectedCard = value;
  }

  void setMonthlyPlanExpense(BuildContext context, int catId) async {
    try {
      if (formKey.currentState!.validate()) {
        double expense = double.parse(expenseController.text.trim());
        if (widget.monthlyPlanCatData != null) {
          Map<String, dynamic> monthlyExpense = {
            "name": widget.monthlyPlanCatData!["name"],
            "amount": expense,
            "card": selectedCard == 0 ? null : selectedCard,
            "category": widget.monthlyPlanCatData!["catId"],
            "type": 0,
            "monthly_plan": 1,
            "date": DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now())
          };

          // print(monthlyExpense);

          bool cardSaveStatus;
          if (widget.editablemonthlyPlanCatData != null) {
            monthlyExpense['id'] = widget.editablemonthlyPlanCatData!['id'];
            cardSaveStatus = await editExpende(monthlyExpense);
          } else {
            cardSaveStatus = await saveCardExpense(monthlyExpense);
          }

          if (widget.editablemonthlyPlanCatData == null && cardSaveStatus) {
            expenseController.text = "";
            tagController.text = "";
            categoryController.text = "";
            selectedCard = 0;
          }

          if (cardSaveStatus) {
            createSnackBar(
                context,
                (widget.editableExpense == null)
                    ? "New expense added"
                    : "Changes saved");

            // print(widget.monthlyPlanCatData);

            getMonthlyExpenseByTimeFlag(
                expenseTime, widget.monthlyPlanCatData!['catId']);
          } else {
            createSnackBar(
                context, "Could not add your expense, try again later");
          }
        } else {
          createSnackBar(
              context, "Something wend wrong! Please try again later");
        }
      }
    } catch (e) {
      print(e);
    }
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
        // int cardId = await getCardId(widget.cardType);

        Map<String, dynamic> expenseData = {
          "name": tag,
          "amount": expense,
          // 'card': cardId,
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
      }
    } catch (e) {
      print("ERROR => $e");
    }
  }

  void transactionSelected(int typeId) {
    setState(() {
      transactionType = typeId;
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
        body: ListView(
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 80),
          children: [
            CardWidget(
              monthlyPlan: widget.monthlyPlanCatData,
              menuPressed: () {},
              // cardType: widget.cardType,
              expense: totalExpense,
              expenseTime: expenseTime,
              itemSelected: (value) => itemSelected(value),
            ),
            Visibility(
                visible: widget.monthlyPlanCatData != null ? true : false,
                child: Form(
                  key: widget.monthlyPlanCatData != null ? formKey : null,
                  child: Column(
                    children: [
                      ExpenseView(
                          controller: expenseController, label: "Amount"),
                      const Padding(padding: EdgeInsets.only(bottom: 30)),
                      DropDownView(
                        dropdownSelected: (value) => dropdownSelected(value),
                        label: "Choose card",
                        cardId: selectedCard,
                      )
                    ],
                  ),
                )),
            // ExpenseFeild(
            //     formKey: formKey,
            //     expenseController: expenseController,
            //     tagController: tagController,
            //     categoryController: categoryController,
            //     expenseBgColor: expenseBgColor,
            //     expenseTextColor: expenseTextColor,
            //     incomBgColor: incomBgColor,
            //     incomeTextColor: incomeTextColor,
            //     transactionType: (id) => transactionSelected(id),
            //     callSnackbar: (msg) => createSnackBar(context, msg)),
          ],
        ),
        bottomSheet: Container(
          width: MediaQuery.of(context).size.width,
          // margin: const EdgeInsets.only(left: 10, bottom: 10),
          height: 50,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(0)),
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: const Color.fromARGB(255, 126, 42, 122)),
              onPressed: () {
                if (widget.monthlyPlanCatData != null) {
                  setMonthlyPlanExpense(
                      context, widget.monthlyPlanCatData!['catId']);
                } else {
                  setCardExpense(context);
                }
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
