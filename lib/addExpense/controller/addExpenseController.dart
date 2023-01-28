import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

const String FLAG = "expenses";

Future<dynamic> getFullCardDetails() async {
  var pref = await SharedPreferences.getInstance();
  var cardData = jsonDecode(pref.getString(FLAG).toString());
  return cardData;
}

Future<bool> saveCardExpense(
    Map<String, dynamic> expenseData, String cardType) async {
  try {
    String date = expenseData['date'];
    Map<String, dynamic> newExpense = {
      'amount': expenseData['amount'],
      'tag': expenseData['tag'],
      'desc': expenseData['desc'],
      'time': expenseData['time']
    };

    Map card = await getFullCardDetails();
    if (card[cardType].containsKey(date)) {
      card[cardType][date].add(newExpense);
    } else {
      card[cardType][date] = [newExpense];
    }

    var pref = await SharedPreferences.getInstance();
    pref.setString(FLAG, jsonEncode(card));

    return true;
  } catch (e) {
    return false;
  }
}

Future<String> getCardDetailsByTime(String time, String cartType) async {
  double expenseSum = 0;
  print("$time $cartType");
  var card = await getFullCardDetails();

  if (time == "Today") {
    String today = DateFormat("yyy-MM-DD").format(DateTime.now());
    if (card[cartType].containsKey(today)) {
      List todayExpenses = card[cartType][today];

      for (var expense in todayExpenses) {
        expenseSum += expense['amount'];
      }
    }
  } else if (time == "This week" || time == "This month") {
    var date = DateTime.now();
    if (time == "This week") {
      var start_date = date.subtract(Duration(days: date.weekday));
      var end_date =
          date.add(Duration(days: DateTime.daysPerWeek - date.weekday - 1));
      print(start_date);
      print(end_date);
    } else if (time == "This month") {
      var start_date = DateTime(date.year, date.month, 1);
      var end_date = DateTime(date.year, date.month + 1, 0);
      print(start_date);
      print(end_date);
    }

    print(card[cartType]);
  }

  // print(expenseSum);
  if (expenseSum == 0) {
    return "0";
  }
  return expenseSum.toString();
}
