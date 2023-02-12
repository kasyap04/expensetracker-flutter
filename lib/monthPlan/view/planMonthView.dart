import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../trackexpenses/view/appBarView.dart';
import '../model/monthPlanModel.dart';

class PlanMonth extends StatefulWidget {
  @override
  State<PlanMonth> createState() => PlanMonthState();
}

class PlanMonthState extends State<PlanMonth> {
  final formKey = GlobalKey<FormState>();
  final scaffolMessengerKey = GlobalKey<ScaffoldMessengerState>();

  TextEditingController totalAmountController = TextEditingController();
  TextEditingController expenseNameController = TextEditingController();
  TextEditingController estimateAmountController = TextEditingController();
  DateRangePickerController dateController = DateRangePickerController();

  double totalAmount = 0, totalExpense = 0;
  int expenseIndex = 0;

  List<Map> expensedata = [];

  void removeFromExpenseData(int index) {
    setState(() {
      for (int i = 0; i < expensedata.length; i++) {
        if (expensedata[i]['id'] == index) {
          totalExpense -= double.parse(expensedata[i]['amount']);
          expensedata.removeAt(i);
        }
      }
    });
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

  void createExpenseView(String amount, String name) {
    expensedata.add({"id": expenseIndex, "name": name, "amount": amount});
    expenseIndex++;

    totalExpense += double.parse(amount);
  }

  void buttonAction(BuildContext context, String slug) async {
    String initialAmount = totalAmountController.text,
        expenseName = expenseNameController.text,
        estimateAmount = estimateAmountController.text;

    dynamic startDate = dateController.selectedRange?.startDate;
    dynamic endDate = dateController.selectedRange?.endDate;

    if (slug == "create-expense") {
      if (formKey.currentState!.validate()) {
        if (totalExpense + double.parse(estimateAmount) <= totalAmount) {
          setState(() {
            createExpenseView(estimateAmount, expenseName);
          });
          expenseNameController.text = "";
          estimateAmountController.text = "";
        } else {
          createSnackBar(context, "Your have reached your monthly limit");
        }
      }
    } else if (slug == "save-expense") {
      if (totalAmount == 0 || expensedata.isEmpty) {
        createSnackBar(context, "Please make your expense plan");
      } else {
        List<Map<String, dynamic>> planData = [];

        Map<String, dynamic> plan = {
          'total_amount': totalAmount,
          'start_date': DateFormat("yyy-MM-dd").format(startDate),
          'end_date': DateFormat("yyy-MM-dd").format(endDate)
        };

        // print(plan);

        int planId = 1;
        //await createMonthlyPlan(plan);

        if (planId == 0) {
          createSnackBar(
              context, "Something went wrong, Please try again later");
        } else {
          for (var exp in expensedata) {
            planData.add({
              'expense_name': exp['name'],
              'estimat_amount': exp['amount'],
              'spend_amount': 0,
              'plan_id': planId
            });
          }

          bool res = await createPlanData(planData);
          if (res) {
            createSnackBar(context, "Your montly plan is created");
            setState(() {
              expensedata.clear();
              totalAmountController.text = "";
              totalExpense = 0;
              totalAmount = 0;
            });
          } else {
            createSnackBar(
                context, "Something went wrong, Please try again later");
          }
        }
      }
    }
  }

  void totalAMountChange(String value) {
    setState(() {
      totalAmount = value.isEmpty ? 0 : double.parse(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: scaffolMessengerKey,
      home: Scaffold(
          appBar: AppBarView(
            prevContext: context,
            hasBackButton: true,
          ),
          body: Container(
            margin: const EdgeInsetsDirectional.all(10),
            child: ListView(
              children: [
                const Text("Plan your expenses for a month",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FeildPadding(padding: 30),
                        FeildLabel(label: "Select date range"),
                        FeildPadding(padding: 5),
                        SizedBox(
                          height: 250,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: SfDateRangePicker(
                              controller: dateController,
                              selectionMode:
                                  DateRangePickerSelectionMode.extendableRange,
                              backgroundColor:
                                  const Color.fromARGB(12, 139, 30, 134),
                              todayHighlightColor:
                                  const Color.fromARGB(255, 126, 42, 122),
                              selectionColor:
                                  const Color.fromARGB(255, 126, 42, 122),
                              startRangeSelectionColor:
                                  const Color.fromARGB(255, 126, 42, 122),
                              endRangeSelectionColor:
                                  const Color.fromARGB(255, 126, 42, 122),
                              rangeSelectionColor:
                                  const Color.fromARGB(19, 134, 41, 130),
                            ),
                          ),
                        ),
                        FeildPadding(padding: 30),
                        FeildLabel(label: "Total amount"),
                        FeildPadding(padding: 5),
                        NumberFeildView(
                            totalAMountChange: (value) =>
                                totalAMountChange(value),
                            controller: totalAmountController,
                            width: size.width - 20),
                        FeildPadding(padding: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FeildLabel(label: "Expense name"),
                                FeildPadding(padding: 5),
                                TextFeildView(
                                  controller: expenseNameController,
                                  width: size.width / 2 - 20,
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FeildLabel(label: "Estimate amount"),
                                FeildPadding(padding: 5),
                                NumberFeildView(
                                  totalAMountChange: (value) {},
                                  controller: estimateAmountController,
                                  width: size.width / 2 - 20,
                                ),
                              ],
                            ),
                          ],
                        ),
                        FeildPadding(padding: 10),
                        ButtonView(
                            buttonName: "Create expense",
                            isSecondary: true,
                            buttonAction: () =>
                                buttonAction(context, "create-expense")),
                        FeildPadding(padding: 15),
                        const Divider(
                          thickness: 1,
                          height: 4,
                        ),
                        FeildPadding(padding: 15),
                        NewExpenseView(
                          removeExpense: (index) =>
                              removeFromExpenseData(index),
                          balanceAmount:
                              (totalAmount - totalExpense).toString(),
                          expenseAmount: totalExpense.toString(),
                          totalAmount: totalAmount,
                          expensesData: expensedata,
                        ),
                        FeildPadding(padding: 30),
                        ButtonView(
                            buttonName: "Save plan",
                            buttonAction: () =>
                                buttonAction(context, "save-expense"))
                      ],
                    )),
              ],
            ),
          )),
    );
  }
}

class NewExpenseView extends StatelessWidget {
  final String balanceAmount;
  final String expenseAmount;
  final double totalAmount;
  final void Function(int index) removeExpense;
  List<Map> expensesData;
  NewExpenseView(
      {required this.balanceAmount,
      required this.expenseAmount,
      required this.totalAmount,
      required this.expensesData,
      required this.removeExpense});

  final Widget initialExpenseMsg = const Text(
    "Nothing to show",
    style: TextStyle(color: Colors.grey),
  );

  @override
  Widget build(BuildContext context) {
    List<Widget> expense = [];
    for (var exp in expensesData) {
      expense.add(Container(
        width: 150,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 88, 24, 80),
            borderRadius: BorderRadius.circular(8)),
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              InkWell(
                onTap: () => removeExpense(exp['id']),
                child: const Icon(
                  Icons.close,
                  size: 18,
                  color: Colors.white,
                ),
              )
            ]),
            FeildPadding(padding: 10),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Icon(
                Icons.currency_rupee,
                size: 12,
                color: Color.fromARGB(255, 184, 184, 184),
              ),
              Text(
                exp['amount'],
                style: const TextStyle(fontSize: 20, color: Colors.white),
              )
            ]),
            FeildPadding(padding: 5),
            Text(exp['name'],
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 14, color: Color.fromARGB(255, 184, 184, 184)))
          ],
        ),
      ));
    }

    Color checkBalanceAmout(double balance) {
      Color fineColor = const Color.fromARGB(255, 16, 146, 4);
      Color warningColor = const Color.fromARGB(255, 228, 170, 64);
      Color alertColor = const Color.fromARGB(255, 255, 137, 2);
      Color dangerColor = const Color.fromARGB(255, 245, 4, 4);
      Color normalColor = Colors.black;

      double perc = (balance / totalAmount) * 100;
      if (perc <= 30) {
        return fineColor;
      } else if (perc > 30 && perc < 80) {
        return warningColor;
      } else if (perc >= 80 && perc < 100) {
        return alertColor;
      } else if (perc >= 100) {
        return dangerColor;
      }
      return normalColor;
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 241, 241, 241),
          borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text("Balance : ",
                      style: TextStyle(color: Colors.grey)),
                  Icon(
                    Icons.currency_rupee,
                    size: 12,
                    color: checkBalanceAmout(double.parse(expenseAmount)),
                  ),
                  Text(
                    balanceAmount,
                    style: TextStyle(
                        color: checkBalanceAmout(double.parse(expenseAmount))),
                  )
                ],
              ),
              Row(
                children: [
                  const Text(
                    "Expense : ",
                    style: TextStyle(color: Colors.grey),
                  ),
                  const Icon(
                    Icons.currency_rupee,
                    size: 12,
                  ),
                  Text(expenseAmount)
                ],
              ),
            ],
          ),
          FeildPadding(padding: 10),
          expense.isNotEmpty
              ? GridView.count(
                  primary: false,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  children: expense)
              : initialExpenseMsg
        ],
      ),
    );
  }
}

class ButtonView extends StatelessWidget {
  final void Function() buttonAction;
  final String buttonName;
  late bool? isSecondary;
  ButtonView(
      {required this.buttonAction, this.isSecondary, required this.buttonName});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              elevation: 0,
              primary: isSecondary == true
                  ? const Color.fromARGB(26, 163, 63, 158)
                  : const Color.fromARGB(255, 126, 42, 122)),
          onPressed: () => buttonAction(),
          child: Text(
            buttonName,
            style: TextStyle(
                fontSize: 24,
                color: isSecondary == true
                    ? const Color.fromARGB(255, 129, 59, 126)
                    : Colors.white),
          )),
    );
  }
}

class NumberFeildView extends StatelessWidget {
  final controller;
  final double width;
  final void Function(String value) totalAMountChange;
  NumberFeildView(
      {required this.controller,
      required this.width,
      required this.totalAMountChange});

  dynamic expendeValidator(dynamic value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an amount';
    } else if (double.tryParse(value) == null || double.parse(value) <= 0) {
      return 'Please enther valid amount';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextFormField(
        onChanged: (value) => totalAMountChange(value),
        controller: controller,
        keyboardType: TextInputType.number,
        validator: (value) => expendeValidator(value),
        textCapitalization: TextCapitalization.sentences,
        style: const TextStyle(fontSize: 18),
        decoration: InputDecoration(
            prefix: const Icon(
              Icons.currency_rupee,
              size: 12,
              color: Colors.grey,
            ),
            enabledBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: Color.fromARGB(255, 126, 42, 122)),
                borderRadius: BorderRadius.circular(6)),
            focusedBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: Color.fromARGB(255, 126, 42, 122)),
                borderRadius: BorderRadius.circular(6)),
            border: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: Color.fromARGB(255, 126, 42, 122)),
                borderRadius: BorderRadius.circular(6))),
      ),
    );
  }
}

class TextFeildView extends StatelessWidget {
  final controller;
  final double width;
  TextFeildView({required this.controller, required this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextFormField(
        controller: controller,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please fill this field';
          } else {
            return null;
          }
        },
        textCapitalization: TextCapitalization.sentences,
        style: const TextStyle(fontSize: 18),
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: Color.fromARGB(255, 126, 42, 122)),
                borderRadius: BorderRadius.circular(6)),
            focusedBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: Color.fromARGB(255, 126, 42, 122)),
                borderRadius: BorderRadius.circular(6)),
            border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(6))),
      ),
    );
  }
}

class FeildLabel extends StatelessWidget {
  final String label;
  FeildLabel({required this.label});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Padding(padding: EdgeInsets.only(left: 7)),
        Text(
          label,
          style: const TextStyle(color: Colors.grey),
        )
      ],
    );
  }
}

class FeildPadding extends StatelessWidget {
  final double padding;
  FeildPadding({required this.padding});
  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.only(bottom: padding));
  }
}
