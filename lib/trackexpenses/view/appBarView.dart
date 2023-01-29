import 'package:flutter/material.dart';

class AppBarView extends StatelessWidget implements PreferredSizeWidget {
  late IconData? icon;
  late void Function()? iconClicked;
  late bool? hasBackButton;
  late BuildContext? prevContext;
  AppBarView(
      {this.icon, this.iconClicked, this.hasBackButton, this.prevContext});

  void goBack() {
    Navigator.of(prevContext!).pop();
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
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
        "Track your expeses",
        style: TextStyle(
            fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
      ),
      elevation: 0,
      actions: [
        IconButton(
          onPressed: iconClicked,
          icon: Icon(icon),
          color: Colors.black,
        )
      ],
    );
  }
}
