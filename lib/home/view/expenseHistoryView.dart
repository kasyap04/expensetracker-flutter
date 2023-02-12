import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/homeModel.dart';

class ExpenseHistoryHome extends StatefulWidget {
  final void Function(Map cardType) editExpense;
  final Future<bool> Function(int id) deleteExpenseAction;
  ExpenseHistoryHome(
      {required this.editExpense, required this.deleteExpenseAction});
  @override
  State<ExpenseHistoryHome> createState() => ExpenseHistoryHomeState();
}

class ExpenseHistoryHomeState extends State<ExpenseHistoryHome> {
  Future<bool> expenseDismiss(
      BuildContext context, DismissDirection direction, Map expData) async {
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
                      child: const Text("Not now")),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                        // await widget.deleteExpenseAction(expData['id']);
                      },
                      child: const Text("Yes, delete"))
                ],
                title: const Text("Delete?", textAlign: TextAlign.center),
                content: const Text(
                  "Are you sure you want to delete this?",
                  textAlign: TextAlign.center,
                ),
              )).then((value) async {
        status = value;
        if (value) {
          status = await widget.deleteExpenseAction(expData['id']);
        }
      });
    } else {
      widget.editExpense(expData);
      status = true;
    }
    return status;
  }

  @override
  Widget build(BuildContext context) {
    // return const Center(child: Text("ON THE WAY"));
    return FutureBuilder(
        future: getAllExpenses(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            List<Widget> myExpenses = [];

            dynamic allExpenses = snapshot.data;

            if (allExpenses.isNotEmpty) {
// print(allExpenses) ;
              String lastDate = "";

              for (var exp in allExpenses) {
                var formattedDate = DateFormat("HH:mm:ss")
                    .parse(exp['date'].substring(11, exp['date'].length));

                // print();

                String time = DateFormat("hh:ss a").format(formattedDate);
                String date = exp['date'].substring(0, 11);

                if (lastDate != date) {
                  lastDate = date;

                  myExpenses.add(DateChange(
                    date: lastDate,
                  ));
                }

                myExpenses.add(Dismissible(
                    confirmDismiss: (direction) async =>
                        await expenseDismiss(context, direction, exp),
                    resizeDuration: const Duration(seconds: 5),
                    secondaryBackground: const ColoredBox(
                        color: Colors.red,
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
                    background: const ColoredBox(
                        color: Colors.blue,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.all(15),
                            child: Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                          ),
                        )),
                    key: UniqueKey(),
                    child: ExpenseHistoryChild(
                      amount: "${exp['amount']}",
                      cardType: exp['card'],
                      tag: exp['spend'],
                      time: time,
                      transactionType: exp['type'],
                      category: exp['category'],
                    )));

                // myExpenses.add(D());
              }
              // myExpenses.removeLast();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Padding(padding: EdgeInsets.only(left: 10)),
                      Text(
                        "Expense history",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(17, 15, 103, 138),
                        borderRadius: BorderRadius.circular(10)),
                    width: MediaQuery.of(context).size.width - 20,
                    margin: const EdgeInsets.only(left: 10),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: myExpenses,
                    ),
                  ),
                ],
              );
            } else {
              return Center(
                  child: Text("You didn't make an expense yet",
                      style: TextStyle(color: Colors.grey)));
            }
          } else {
            return const CircularProgressIndicator();
          }
        }));
  }
}

class ExpenseHistoryChild extends StatelessWidget {
  final String cardType;
  final String tag;
  final String amount;
  final String time;
  final String category;
  final int transactionType;
  ExpenseHistoryChild(
      {required this.cardType,
      required this.tag,
      required this.amount,
      required this.time,
      required this.category,
      required this.transactionType});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: 40,
          width: 40,
          margin: const EdgeInsets.only(right: 5),
          decoration: BoxDecoration(
              color: const Color.fromARGB(255, 114, 24, 117),
              borderRadius: BorderRadius.circular(100)),
          child: Center(
              child: Text(
            "${cardType[0].toUpperCase()}C",
            style: const TextStyle(color: Colors.white),
          )),
        ),
        Container(
          padding: const EdgeInsets.only(top: 15, bottom: 15),
          width: MediaQuery.of(context).size.width - 85,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tag,
                    style: const TextStyle(fontSize: 20),
                  ),
                  const Padding(padding: EdgeInsets.only(bottom: 5)),
                  Text(
                    "${cardType[0].toUpperCase()}${cardType.substring(1).toLowerCase()} card | $category",
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  )
                ],
              ),
              Column(
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.currency_rupee,
                        size: 15,
                        color: Colors.grey,
                      ),
                      Text(
                        amount,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: transactionType == 0
                                ? Colors.red
                                : Colors.green),
                      ),
                      Icon(
                        transactionType == 0 ? Icons.remove : Icons.add,
                        size: 15,
                        color: transactionType == 0 ? Colors.red : Colors.green,
                      )
                    ],
                  ),
                  const Padding(padding: EdgeInsets.only(bottom: 5)),
                  Text(time,
                      style: const TextStyle(color: Colors.grey, fontSize: 12))
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}

class DateChange extends StatelessWidget {
  final String date;

  DateChange({required this.date});
  @override
  Widget build(BuildContext context) {
    var d = DateFormat("yyy-MM-DD").parse(date);
    DateTime today = DateTime.now();
    int dateDiff = today.difference(d).inDays;

    late String? dateFormate;
    if (dateDiff == 0) {
      dateFormate = "Today";
    } else if (dateDiff == 1) {
      dateFormate = "Yesterday";
    } else {
      dateFormate = DateFormat.yMMMd().format(d);
    }

    return Column(
      children: [
        const Padding(padding: EdgeInsets.only(top: 15)),
        Text(dateFormate),
      ],
    );
  }
}
