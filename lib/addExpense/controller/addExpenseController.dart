import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

import '../model/addExpenseMode.dart';

// Future<dynamic> getFullCardDetails() async {
//   var pref = await SharedPreferences.getInstance();
//   var cardData = jsonDecode(pref.getString(FLAG).toString());
//   return cardData;
// }

DateTime toDateTime(String date) => DateTime.parse(date);

List getStartEndDateFromTimeFlag(String time) {
  var start_date, end_date;

  if (time == "Today") {
    String today = DateFormat("yyy-MM-dd").format(DateTime.now());
    start_date = "$today 00:00:00";
    end_date = "$today 23:59:59";
  } else if (time == "This week" || time == "This month") {
    var date = DateTime.now();
    if (time == "This week") {
      var weekday = date.weekday == 7 ? 0 : date.weekday;
      start_date = date.subtract(Duration(days: weekday));
      end_date = date.add(Duration(days: DateTime.daysPerWeek - weekday - 1));
      start_date = DateTime(start_date.year, start_date.month, start_date.day)
          .toString();
      end_date =
          DateTime(end_date.year, end_date.month, end_date.day).toString();
    } else if (time == "This month") {
      start_date = DateTime(date.year, date.month, 1).toString();
      end_date = DateTime(date.year, date.month + 1, 0).toString();
    }
    end_date = "${end_date.substring(0, 10)} 23:59:59";
  }

  return [start_date, end_date];
}

// Future<String> getCardDetailsByTimeFlag(String time, String cartType) async {
//   var dateStartEnd = getStartEndDateFromTimeFlag(time);
//   final expenseSum =
//       await getExpenseByTime(cartType, dateStartEnd[0], dateStartEnd[1]);

//   return expenseSum.toString();
// }

Future<String> getMonthlyExpenseByTimeFlagController(
    String time, int catId) async {
  var dateStartEnd = getStartEndDateFromTimeFlag(time);
  final expenseSum =
      await getMonthlyExpenseByTime(dateStartEnd[0], dateStartEnd[1], catId);

  return expenseSum.toString();
}
