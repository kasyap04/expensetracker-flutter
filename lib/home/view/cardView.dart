import 'package:flutter/material.dart';
import 'package:trackexpense/addExpense/view/addExpenses.dart';

class CardView extends StatelessWidget {
  const CardView({Key? key}) : super(key: key);

  void debitCardClicked(context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddExpenses(
                  cardType: "debit",
                )));
  }

  void creditCardClicked(context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddExpenses(
                  cardType: "credit",
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        ExpenseCard(
            cardType: "debit",
            cardClicked: () {
              debitCardClicked(context);
            }),
        ExpenseCard(
          cardType: "credit",
          cardClicked: () {
            creditCardClicked(context);
          },
        )
      ],
    );
  }
}

class ExpenseCard extends StatefulWidget {
  final String cardType;
  final void Function() cardClicked;
  ExpenseCard({required this.cardType, required this.cardClicked});
  @override
  State<ExpenseCard> createState() => ExpenseCardState();
}

class ExpenseCardState extends State<ExpenseCard> {
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;

    return Container(
      width: (mediaQuery.width / 2) - 30,
      height: (mediaQuery.width / 2) - 60,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 126, 42, 122),
          borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: widget.cardClicked,
      ),
    );
  }
}
