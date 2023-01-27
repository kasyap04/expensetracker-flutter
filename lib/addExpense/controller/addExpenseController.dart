import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

const String FLAG = "expenses";

Future<void> getCardDetails(String time, String cardType) async {
  var pref = await SharedPreferences.getInstance();
  var cardData = jsonDecode(pref.getString(FLAG).toString());
  print(cardData);
}

Future<void> saveCardExpense(
    BuildContext context, GlobalKey<FormState> formKey, String cardType) async {
  if (formKey.currentState!.validate()) {}
}
