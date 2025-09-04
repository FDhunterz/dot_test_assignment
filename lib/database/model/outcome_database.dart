import 'package:dot_test/models/outcome/outcome.dart';
import 'package:sql_query/builder/query_builder.dart';
import 'package:sql_query/database_model.dart';

class OutcomeDatabase {
  static const String table = 'outcome_database';
  static const String name = 'name';
  static const String id = 'id';
  static const String price = 'price';
  static const String date = 'date';
  static const String type = 'type';

  static tables() {
    return TableDatabase(
      tableName: "outcome_database",
      column: [
        ColumnDatabase(name: name, typeData: DataType.text),
        ColumnDatabase(name: id, typeData: DataType.text, primaryKey: true),
        ColumnDatabase(name: price, typeData: DataType.double),
        ColumnDatabase(name: date, typeData: DataType.text),
        ColumnDatabase(name: type, typeData: DataType.text),
      ],
    );
  }

  static Future<List<Map<String, dynamic>>> get() async {
    final q = DB.table(table);
    return await q.get();
  }

  static Future<List<Map<String, dynamic>>> insert(Outcome data) async {
    final q = DB.table(table);
    q.data(data.toJson()); // add your data here
    return await q.insert();
  }

  static Future<List<Map<String, dynamic>>> update(Outcome data) async {
    final q = DB.table(table);
    q.data(data.toJsonUpdate());
    q.where(id, '=', data.id);
    return await q.update();
  }

  static Future<List<Map<String, dynamic>>> delete(Outcome data) async {
    final q = DB.table(table);
    q.where(id, '=', data.id);
    return await q.delete();
  }
}
