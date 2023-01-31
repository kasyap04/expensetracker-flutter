import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

const String FLAG = "expenses";

Future<dynamic> getCardExpense() async {
  var pref = await SharedPreferences.getInstance();
  var cardDetails = jsonDecode(pref.getString(FLAG).toString());
  print(cardDetails);
  List<Map<dynamic, dynamic>> allExpenses = [];

  for (dynamic cards in cardDetails['cards']) {
    cardDetails[cards].forEach((key, value) {
      for (var exp in value) {
        exp['time'] = "$key ${exp['time']}";
        exp['card'] = cards;
        allExpenses.add(exp);
      }
    });
  }

  allExpenses.sort(((a, b) => (DateFormat("yyy-MM-DD hh:mm a").parse(b['time']))
      .compareTo(DateFormat("yyy-MM-DD hh:mm a").parse(a['time']))));

  return allExpenses;
}
