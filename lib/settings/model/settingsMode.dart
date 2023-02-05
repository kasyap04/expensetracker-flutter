import 'package:sqflite/sqflite.dart';

import '../../trackexpenses/model/database.dart';

Future<dynamic> getCategories() async {
  final db = await Sql.db();
  var res = await db.query('category');
  // print(res);
  return res;
}

Future<int> addNewCategory(String name) async {
  final db = await Sql.db();
  final checkCategory = await db.query('category',
      columns: ['id'], where: "name = ?", whereArgs: [name.trim()]);
  if (checkCategory.isEmpty) {
    return await db.insert('category', {'name': name.trim()},
        conflictAlgorithm: ConflictAlgorithm.replace);
  } else {
    return 0;
  }
}
