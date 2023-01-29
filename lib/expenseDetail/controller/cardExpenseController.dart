import 'package:shared_preferences/shared_preferences.dart';

const String FLAG = "expenses";

Future<void> getCardExpense() async {
  var pref = await SharedPreferences.getInstance();
  var cardDetails = pref.getString(FLAG);
  print(cardDetails);
}
