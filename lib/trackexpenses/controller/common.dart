import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

const String FLAG = "expenses";

Future<dynamic> getUserData() async {
  var pref = await SharedPreferences.getInstance();
  // pref.remove(FLAG);
  var value = pref.getString(FLAG) ?? false;
  // print("VALUE = $value");
  return value;
}

Future<void> removeAll() async {
  var pref = await SharedPreferences.getInstance();
  pref.remove(FLAG);
  print("REMOVED");
}

Future<bool> setCards(bool debit, bool credit) async {
  try {
    if (credit || debit) {
      var pref = await SharedPreferences.getInstance();
      Map<String, Map<String, String>> cards = {};
      if (debit) {
        cards['debit'] = {};
      }

      if (credit) {
        cards['credit'] = {};
      }
      pref.setString('expenses', json.encode(cards));
    }
    return true;
  } catch (e) {
    return false;
  }
  // pref.remove(FLAG);
  // print(pref.getString(FLAG));
  // return true;
}
