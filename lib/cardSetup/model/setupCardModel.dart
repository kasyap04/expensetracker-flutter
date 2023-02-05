import 'package:sqflite/sqflite.dart';
import '../../trackexpenses/model/database.dart';

class SetupCardModel {
  static Future<int> addCard(String cardName) async {
    final db = await Sql.db();

    var checkCard = await db.query('card',
        columns: ['name'], where: "name = ?", whereArgs: [cardName]);

    if (checkCard.isEmpty) {
      final data = {'name': cardName};
      final id = await db.insert('card', data,
          conflictAlgorithm: ConflictAlgorithm.replace);
      return id;
    } else {
      return 0;
    }
  }
}
