import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:trackexpense/home/controller/homePageController.dart';

class CardView extends StatefulWidget {
  final void Function(String cardTyp) addExpensePressed;
  final void Function(String cardtype) cardPressed;
  CardView(
      {required this.addExpensePressed(String cardType),
      required this.cardPressed});

  @override
  State<CardView> createState() => CardViewState();
}

class CardViewState extends State<CardView> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getCards(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Widget> items = [];
            dynamic allCards = snapshot.data;

            for (var card in allCards) {
              items.add(ExpenseCard(
                expense: card['amount'].toString(),
                addExpenseClicked: (value) =>
                    widget.addExpensePressed(card['card']),
                cardClicked: () => widget.cardPressed(card['card']),
                cardType: card['card'],
              ));
            }

            return Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
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
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}

class ExpenseCard extends StatefulWidget {
  final String cardType;
  final void Function(String type) addExpenseClicked;
  final void Function() cardClicked;
  final String expense;
  ExpenseCard(
      {required this.cardType,
      required this.addExpenseClicked(String type),
      required this.cardClicked,
      required this.expense});
  @override
  State<ExpenseCard> createState() => ExpenseCardState();
}

class ExpenseCardState extends State<ExpenseCard> {
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
        child: InkWell(
          onTap: widget.cardClicked,
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
                  widget.expense,
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
                    style: const TextStyle(
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
                          onPressed: () =>
                              widget.addExpenseClicked(widget.cardType),
                          icon: const Icon(
                            Icons.add,
                            color: Color.fromARGB(255, 126, 42, 122),
                          )),
                    ),
                  )
                ],
              )
            ],
          ),
        ));
  }
}
