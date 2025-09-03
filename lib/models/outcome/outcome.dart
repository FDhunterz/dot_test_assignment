import 'dart:convert';

import 'package:dot_test/material/helper/currency.dart';
import 'package:dot_test/models/outcome/outcome_type.dart';

class Outcome {
  String? name, id;
  double? price;
  DateTime? date;
  OutcomeType? type;

  Map<String, String> toJson() {
    return {
      'name': name ?? '',
      'price': (price ?? '').toString(),
      'date': date?.toIso8601String() ?? '',
      'type': jsonEncode(type?.toJson()),
      'id': id ?? '',
    };
  }

  static Outcome fromJson(data) {
    final d = jsonDecode(data['type']);
    return Outcome(
      id: data['id'],
      date: DateTime.parse(data['date']),
      name: data['name'],
      price: toDoubleSafe(data['price']),
      type: OutcomeType.fromJson(d),
    );
  }

  Outcome({this.date, this.name, this.price, this.type, this.id}) {
    id ??= DateTime.now().microsecondsSinceEpoch.toString();
  }
}
