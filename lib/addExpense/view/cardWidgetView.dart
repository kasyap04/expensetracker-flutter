import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  final void Function() menuPressed;
  final String expenseTime;
  final String expense;
  final String cardType;

  CardWidget(
      {required this.menuPressed,
      required this.expenseTime,
      required this.expense,
      required this.cardType});

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
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.more_vert,
                    size: 20,
                    color: Color.fromARGB(255, 170, 170, 170),
                  ))
            ],
          ),
          const Padding(padding: EdgeInsets.only(bottom: 15)),
          Text(
            expense,
            style: const TextStyle(
                fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold),
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
