import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  final void Function() menuPressed;
  final String expenseTime;
  final String expense;
  final String cardType;

  final void Function(String value) itemSelected;

  CardWidget(
      {required this.menuPressed,
      required this.expenseTime,
      required this.expense,
      required this.cardType,
      required this.itemSelected(String value)});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10, bottom: 10),
      margin: const EdgeInsets.only(bottom: 20),
      // width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 126, 42, 122),
          borderRadius: BorderRadius.circular(10)),
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
              Text(
                "${cardType[0].toUpperCase()}${cardType.substring(1).toLowerCase()} card",
                style:
                    const TextStyle(color: Color.fromARGB(255, 170, 170, 170)),
              ),
              const Padding(padding: EdgeInsets.only(left: 10))
            ],
          )
        ],
      ),
    );
  }
}
