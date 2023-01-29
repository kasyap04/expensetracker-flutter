// import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

const String FLAG = "expenses";

Future<dynamic> getCards() async {
  var pref = await SharedPreferences.getInstance();
  var data = jsonDecode(pref.getString(FLAG).toString());
  return data['cards'];
  // return ['debit'];
}
