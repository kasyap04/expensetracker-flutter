import '../model/database.dart';

Future<dynamic> getUserData() async {
  return await Sql.checkDataSet();
}
