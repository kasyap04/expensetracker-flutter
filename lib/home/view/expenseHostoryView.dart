import 'package:flutter/material.dart';

import '../../expenseDetail/controller/cardExpenseController.dart';

class ExpenseHistoryHome extends StatefulWidget {
  @override
  State<ExpenseHistoryHome> createState() => ExpenseHistoryHomeState();
}

class ExpenseHistoryHomeState extends State<ExpenseHistoryHome> {
  @override
  Widget build(BuildContext context) {
    getCardExpense();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Padding(padding: EdgeInsets.only(left: 10)),
            Text(
              "Expense history",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            )
          ],
        ),
        ExpenseHistory(),
      ],
    );
  }
}

class ExpenseHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Color.fromARGB(28, 15, 103, 138),
          borderRadius: BorderRadius.circular(10)),
      width: MediaQuery.of(context).size.width - 20,
      margin: EdgeInsets.only(left: 10),
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 40,
                width: 40,
                margin: EdgeInsets.only(right: 5),
                child: Center(
                    child: Text(
                  "DC",
                  style: TextStyle(color: Colors.white),
                )),
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 114, 24, 117),
                    borderRadius: BorderRadius.circular(100)),
              ),
              Container(
                padding: EdgeInsets.only(top: 15, bottom: 15),
                width: MediaQuery.of(context).size.width - 85,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Tea",
                          style: TextStyle(fontSize: 25),
                        ),
                        Padding(padding: EdgeInsets.only(bottom: 5)),
                        Text(
                          "12:34 AM",
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        )
                      ],
                    ),
                    Text(
                      "13",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    )
                  ],
                ),
              ),
            ],
          ),
          Divider(
            height: 2,
            thickness: 1,
          ),
        ],
      ),
    );
  }
}
