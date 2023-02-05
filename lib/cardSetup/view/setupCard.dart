import 'package:flutter/material.dart';
import 'package:trackexpense/main.dart';
import 'package:trackexpense/trackexpenses/controller/common.dart';

import '../../trackexpenses/view/appBarView.dart';
import '../controller/cardSetupController.dart';

class SetupCard extends StatefulWidget {
  @override
  State<SetupCard> createState() => SetupCardState();
}

class SetupCardState extends State<SetupCard> {
  final _scaffolKey = GlobalKey<ScaffoldMessengerState>();
  final navigatorKey = GlobalKey<NavigatorState>();

  Color debitCardTextColor = const Color.fromARGB(110, 0, 0, 0),
      creditCardTextColor = const Color.fromARGB(110, 0, 0, 0);
  Color debitCardBg = const Color.fromARGB(31, 94, 47, 105),
      creditCardBg = const Color.fromARGB(31, 94, 47, 105);

  bool debitCardSelected = false, creditCardSelected = false;

  void debitCard() {
    setState(() {
      debitCardSelected = !debitCardSelected;
      if (debitCardSelected) {
        debitCardTextColor = Colors.white;
        debitCardBg = const Color.fromARGB(255, 94, 47, 105);
      } else {
        debitCardTextColor = const Color.fromARGB(110, 0, 0, 0);
        debitCardBg = const Color.fromARGB(31, 94, 47, 105);
      }
    });
  }

  void creditCard() {
    setState(() {
      creditCardSelected = !creditCardSelected;
      if (creditCardSelected) {
        creditCardBg = const Color.fromARGB(255, 94, 47, 105);
        creditCardTextColor = Colors.white;
      } else {
        creditCardTextColor = const Color.fromARGB(110, 0, 0, 0);
        creditCardBg = const Color.fromARGB(31, 94, 47, 105);
      }
    });
  }

  void configCards(BuildContext context) async {
    await setInitialCards(debitCardSelected, creditCardSelected).then((value) {
      print(value);
      if (value == true) {
        setState(() {
          final NavigatorState? navigator = navigatorKey.currentState;
          navigator!.pushReplacement(
              MaterialPageRoute(builder: (context) => MyApp()));
        });
      } else {
        const snackBar = SnackBar(
            content: Text("Something wend wrong, Please try again later"));

        final ScaffoldMessengerState? scaffold = _scaffolKey.currentState;
        scaffold!.showSnackBar(snackBar);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: _scaffolKey,
      navigatorKey: navigatorKey,
      home: Scaffold(
          appBar: AppBarView(),
          body: Center(
            child: ListView(
              padding: const EdgeInsets.all(10),
              children: [
                const Text(
                    "Select the cards that you want to track your expenses",
                    style: TextStyle(
                        color: Color.fromARGB(255, 121, 121, 121),
                        fontSize: 18)),
                const Padding(padding: EdgeInsets.only(bottom: 30)),
                SetCardBody(
                  debitCard: debitCard,
                  creditCard: creditCard,
                  debitCardBg: debitCardBg,
                  debitCardTextColor: debitCardTextColor,
                  creditCardBg: creditCardBg,
                  creditCardTextColor: creditCardTextColor,
                ),
                const Padding(padding: EdgeInsets.only(bottom: 50)),
                ElevatedButton(
                    onPressed: () {
                      configCards(context);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(10),
                      primary: const Color.fromARGB(255, 94, 47, 105),
                    ),
                    child: const Text(
                      "CONTINUE",
                      style: TextStyle(fontSize: 25),
                    ))
              ],
            ),
          )),
    );
  }
}

class SetCardBody extends StatefulWidget {
  final void Function() debitCard;
  final void Function() creditCard;
  final Color debitCardTextColor;
  final Color debitCardBg;
  final Color creditCardTextColor;
  final Color creditCardBg;
  SetCardBody(
      {required this.debitCard,
      required this.creditCard,
      required this.debitCardTextColor,
      required this.creditCardTextColor,
      required this.debitCardBg,
      required this.creditCardBg});

  @override
  State<SetCardBody> createState() => SetCardBodyState();
}

class SetCardBodyState extends State<SetCardBody> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height - 290 <= 300 ? 320 : size.height - 290,
      // color: Colors.lightGreenAccent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          CardView(
              label: "Debit card",
              selectCard: widget.debitCard,
              textColor: widget.debitCardTextColor,
              bg: widget.debitCardBg),
          CardView(
              label: "Credit card",
              selectCard: widget.creditCard,
              textColor: widget.creditCardTextColor,
              bg: widget.creditCardBg)
        ],
      ),
    );
  }
}

class CardView extends StatefulWidget {
  final String label;
  final Color textColor;
  final Color bg;
  final void Function() selectCard;
  CardView(
      {required this.label,
      required this.selectCard,
      required this.textColor,
      required this.bg});
  @override
  State<CardView> createState() => CardViewState();
}

class CardViewState extends State<CardView> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Material(
        child: InkWell(
          onDoubleTap: () {},
          onTap: widget.selectCard,
          // highlightColor: Color.fromARGB(45, 76, 175, 79),
          splashColor: const Color.fromARGB(200, 94, 47, 105),
          child: Ink(
            color: widget.bg,
            height: 160,
            width: size.width,
            child: Center(
                child: Text(
              widget.label,
              style: TextStyle(
                  color: widget.textColor,
                  fontSize: 35,
                  fontWeight: FontWeight.bold),
            )),
          ),
        ),
      ),
    );
  }
}
