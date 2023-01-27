import 'package:flutter/material.dart';
import 'package:trackexpense/cardSetup/view/setupCard.dart';
import 'trackexpenses/controller/common.dart';
import 'home/view/homePage.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUserData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data == false) {
            return SetupCard();
          } else {
            return HomePage();
          }
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
