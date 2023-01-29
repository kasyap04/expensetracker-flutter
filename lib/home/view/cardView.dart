import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:trackexpense/addExpense/view/addExpenses.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:trackexpense/home/controller/homePageController.dart';

import '../../addExpense/controller/addExpenseController.dart';

class CardView extends StatelessWidget {
  const CardView({Key? key}) : super(key: key);

  void cardClicked(BuildContext context, String card) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddExpenses(
                  cardType: card,
                )));
  }

  @override
  Widget build(BuildContext context) {
    setCard();
    List<Widget> items = [
      ExpenseCard(
        cardClicked: (value) => cardClicked(context, value),
        cardType: "debit",
      ),
      ExpenseCard(
        cardClicked: (value) => cardClicked(context, value),
        cardType: "credit",
      )
    ];
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      height: 180,
      width: MediaQuery.of(context).size.width,
      child: CarouselSlider(
        items: items,
        options: CarouselOptions(
            height: 160,
            enableInfiniteScroll: false,
            viewportFraction: 0.85,
            enlargeCenterPage: true),
      ),
    );
  }
}

class ExpenseCard extends StatefulWidget {
  final String cardType;
  final void Function(String type) cardClicked;
  ExpenseCard({required this.cardType, required this.cardClicked(String type)});
  @override
  State<ExpenseCard> createState() => ExpenseCardState();
}

class ExpenseCardState extends State<ExpenseCard> {
  String expense = "0";
  @override
  void initState() {
    super.initState();
    getCardDetailsByTime("Today", widget.cardType).then((value) {
      setState(() {
        expense = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;

    return Container(
      // width: mediaQuery.width,
      // height: (mediaQuery.width / 2) - 60,
      height: 160,
      padding: const EdgeInsets.only(left: 10, top: 10, right: 0, bottom: 0),
      // margin: const EdgeInsets.only(left: 2, right: 2),
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 126, 42, 122),
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const [
              Text(
                "Today",
                style: TextStyle(color: Color.fromARGB(255, 170, 170, 170)),
              )
            ],
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
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
          ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${widget.cardType[0].toUpperCase()}${widget.cardType.substring(1).toLowerCase()} card",
                style: TextStyle(
                  color: Color.fromARGB(255, 170, 170, 170),
                ),
              ),
              Container(
                // padding: const EdgeInsets.all(0.5),
                // height: 30,
                // width: 30,
                margin: const EdgeInsets.only(right: 5, bottom: 5),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100)),
                child: Center(
                  child: IconButton(
                      onPressed: () => widget.cardClicked(widget.cardType),
                      icon: Icon(
                        Icons.add,
                        color: const Color.fromARGB(255, 126, 42, 122),
                      )),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
