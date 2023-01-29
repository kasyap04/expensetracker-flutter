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

DateTime toDateTime(String date) => DateTime.parse(date);

Future<String> getCardDetailsByTime(String time, String cartType) async {
  double expenseSum = 0;
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
    var start_date, end_date;
    if (time == "This week") {
      var weekday = date.weekday == 7 ? 0 : date.weekday;
      start_date = date.subtract(Duration(days: weekday));
      end_date = date.add(Duration(days: DateTime.daysPerWeek - weekday - 1));
      start_date = DateTime(start_date.year, start_date.month, start_date.day);
      end_date = DateTime(end_date.year, end_date.month, end_date.day);
    } else if (time == "This month") {
      start_date = DateTime(date.year, date.month, 1);
      end_date = DateTime(date.year, date.month + 1, 0);
    }

    card[cartType].keys.forEach((key) {
      DateTime datetime = toDateTime(key);
      if ((datetime.isAfter(start_date) ||
              datetime.isAtSameMomentAs(start_date)) &&
          (datetime.isBefore(end_date) ||
              datetime.isAtSameMomentAs(end_date))) {
        for (var expense in card[cartType][key]) {
          expenseSum += expense['amount'];
        }
      }
    });
  }

  if (expenseSum == 0) {
    return "0";
  }
  return expenseSum.toString();
}
