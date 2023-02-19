import 'package:flutter/material.dart';
import '../../trackexpenses/controller/colors.dart';

class TotalExpenseView extends StatelessWidget {
  final String expenseTime;
  final String expense;
  final String expenseType;

  final void Function(String value) itemSelected;
  final void Function(String value) expenseTypeButtonAction;

  TotalExpenseView({
    required this.expenseTime,
    required this.expense,
    required this.expenseType,
    required this.itemSelected(String value),
    required this.expenseTypeButtonAction(String value),
  });

  Color selectedExpenseButtonColor = const Color.fromARGB(206, 255, 255, 255);
  Color unselectExpenseButtonColor = const Color.fromARGB(185, 158, 158, 158);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10),
      margin: const EdgeInsets.only(bottom: 30),
      decoration: BoxDecoration(
          color: AppColor().primary, borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                expenseTime,
                style:
                    const TextStyle(color: Color.fromARGB(255, 170, 170, 170)),
              ),
              PopupMenuButton(
                  iconSize: 20,
                  icon: const Icon(
                    Icons.more_vert,
                    color: Color.fromARGB(255, 170, 170, 170),
                  ),
                  onSelected: (choice) {
                    itemSelected(choice.toString());
                  },
                  itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: "Today",
                          child: Text("Today"),
                        ),
                        const PopupMenuItem(
                          value: "This week",
                          child: Text("This week"),
                        ),
                        const PopupMenuItem(
                          value: "This month",
                          child: Text("This month"),
                        ),
                      ])
            ],
          ),
          const Padding(padding: EdgeInsets.only(bottom: 15)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.currency_rupee,
                color: Color.fromARGB(146, 216, 216, 216),
              ),
              Text(
                expense,
                style: const TextStyle(
                    fontSize: 40,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
          const Padding(padding: EdgeInsets.only(bottom: 30)),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: () => expenseTypeButtonAction("normal"),
                  child: Text(
                    "Normal expense",
                    style: TextStyle(
                        fontSize: 11,
                        color: expenseType == "normal"
                            ? selectedExpenseButtonColor
                            : unselectExpenseButtonColor),
                  )),
              TextButton(
                  onPressed: () => expenseTypeButtonAction("monthly"),
                  child: Text(
                    "Monthly expense",
                    style: TextStyle(
                        fontSize: 11,
                        color: expenseType == "monthly"
                            ? selectedExpenseButtonColor
                            : unselectExpenseButtonColor),
                  )),
              const Padding(padding: EdgeInsets.only(left: 10))
            ],
          )
        ],
      ),
    );
  }
}
