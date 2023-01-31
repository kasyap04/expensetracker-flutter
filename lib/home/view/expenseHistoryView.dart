import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../expenseDetail/controller/cardExpenseController.dart';

class ExpenseHistoryHome extends StatefulWidget {
  @override
  State<ExpenseHistoryHome> createState() => ExpenseHistoryHomeState();
}

class ExpenseHistoryHomeState extends State<ExpenseHistoryHome> {
  // List<Widget> myExpenses = [];
  // @override
  // void initState() {
  //   setState(() {
  //     getCardExpense().then((value) {
  //       dynamic allExpenses = value;
  //       // print(allExpenses) ;
  //       String lastDate = "";

  //       for (var exp in allExpenses) {
  //         String time = exp['time'].substring(11, exp['time'].length);
  //         String date = exp['time'].substring(0, 11);

  //         if (lastDate != date) {
  //           lastDate = date;
  //           myExpenses.add(DateChange(
  //             date: lastDate,
  //           ));
  //         }

  //         myExpenses.add(ExpenseHistoryChild(
  //           amount: "${exp['amount']}",
  //           cardType: exp['card'],
  //           tag: exp['tag'],
  //           time: "$date $time",
  //         ));

  //         myExpenses.add(D());
  //       }
  //       myExpenses.removeLast();
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // return Column(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [
    //     Row(
    //       children: const [
    //         Padding(padding: EdgeInsets.only(left: 10)),
    //         Text(
    //           "Expense history",
    //           style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
    //         )
    //       ],
    //     ),
    //     Container(
    //       decoration: BoxDecoration(
    //           color: const Color.fromARGB(28, 15, 103, 138),
    //           borderRadius: BorderRadius.circular(10)),
    //       width: MediaQuery.of(context).size.width - 20,
    //       margin: const EdgeInsets.only(left: 10),
    //       padding: const EdgeInsets.all(10),
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: myExpenses,
    //       ),
    //     ),
    //   ],
    // );

    return FutureBuilder(
        future: getCardExpense(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            List<Widget> myExpenses = [];

            dynamic allExpenses = snapshot.data;
            // print(allExpenses) ;
            String lastDate = "";

            for (var exp in allExpenses) {
              String time = exp['time'].substring(11, exp['time'].length);
              String date = exp['time'].substring(0, 11);

              if (lastDate != date) {
                lastDate = date;

                myExpenses.add(DateChange(
                  date: lastDate,
                ));
              }

              myExpenses.add(ExpenseHistoryChild(
                amount: "${exp['amount']}",
                cardType: exp['card'],
                tag: exp['tag'],
                time: time,
              ));

              myExpenses.add(D());
            }
            myExpenses.removeLast();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Padding(padding: EdgeInsets.only(left: 10)),
                    Text(
                      "Expense history",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(28, 15, 103, 138),
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
  ExpenseHistoryChild(
      {required this.cardType,
      required this.tag,
      required this.amount,
      required this.time});

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
                    "${cardType[0].toUpperCase()}${cardType.substring(1).toLowerCase()} card | $time",
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  )
                ],
              ),
              Row(
                children: [
                  const Icon(
                    Icons.currency_rupee,
                    size: 15,
                    color: Colors.grey,
                  ),
                  Text(
                    amount,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  )
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

class D extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 2,
      thickness: 1,
    );
  }
}

// class ExpenseHistory extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//           color: Color.fromARGB(28, 15, 103, 138),
//           borderRadius: BorderRadius.circular(10)),
//       width: MediaQuery.of(context).size.width - 20,
//       margin: EdgeInsets.only(left: 10),
//       padding: EdgeInsets.all(10),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               Container(
//                 height: 40,
//                 width: 40,
//                 margin: EdgeInsets.only(right: 5),
//                 child: Center(
//                     child: Text(
//                   "DC",
//                   style: TextStyle(color: Colors.white),
//                 )),
//                 decoration: BoxDecoration(
//                     color: const Color.fromARGB(255, 114, 24, 117),
//                     borderRadius: BorderRadius.circular(100)),
//               ),
//               Container(
//                 padding: EdgeInsets.only(top: 15, bottom: 15),
//                 width: MediaQuery.of(context).size.width - 85,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Tea",
//                           style: TextStyle(fontSize: 25),
//                         ),
//                         Padding(padding: EdgeInsets.only(bottom: 5)),
//                         Text(
//                           "12:34 AM",
//                           style: TextStyle(color: Colors.grey, fontSize: 12),
//                         )
//                       ],
//                     ),
//                     Text(
//                       "13",
//                       style:
//                           TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
//                     )
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           Divider(
//             height: 2,
//             thickness: 1,
//           ),
//         ],
//       ),
//     );
//   }
// }
