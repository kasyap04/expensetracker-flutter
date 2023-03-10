import 'package:flutter/material.dart';

class AppBarView extends StatelessWidget implements PreferredSizeWidget {
  late void Function(int value)? popUpClicked;
  late String? pageSlug;
  late bool? hasBackButton;
  late BuildContext? prevContext;
  late Widget? actionPopup;
  AppBarView(
      {this.popUpClicked,
      this.hasBackButton,
      this.prevContext,
      this.pageSlug,
      this.actionPopup});

  void goBack() {
    Navigator.of(prevContext!).pop();
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    List<Widget> appBarAction = [];

    if (pageSlug == "homepage") {
      appBarAction
          .add(HomePagePopUp(popUpClicked: (value) => popUpClicked!(value)));
    } else if (pageSlug == "vewaddmonthlyplan") {
      appBarAction.add(actionPopup!);
    }

    return AppBar(
      leading: hasBackButton == true
          ? IconButton(
              onPressed: () {
                goBack();
              },
              icon: const Icon(Icons.arrow_back, color: Colors.black))
          : null,
      centerTitle: true,
      backgroundColor: Colors.white,
      title: const Text(
        "Track your expenses",
        style: TextStyle(
            fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
      ),
      elevation: 0,
      actions: appBarAction,
    );
  }
}

class HomePagePopUp extends StatelessWidget {
  final void Function(int value) popUpClicked;
  HomePagePopUp({required this.popUpClicked});
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        iconSize: 20,
        icon: const Icon(
          Icons.more_vert,
          color: Color.fromARGB(255, 0, 0, 0),
          size: 24,
        ),
        onSelected: (choice) {
          popUpClicked(choice);
        },
        itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: Row(children: const [
                  Icon(
                    Icons.addchart_rounded,
                    color: Color.fromARGB(255, 99, 99, 99),
                    size: 20,
                  ),
                  Padding(padding: EdgeInsets.only(left: 12)),
                  Text("Plan your month")
                ]),
              ),
            ]);
  }
}
