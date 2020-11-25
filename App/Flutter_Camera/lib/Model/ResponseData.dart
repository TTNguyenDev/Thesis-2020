import 'dart:ffi';

class Medicine {
  final String id;
  final String name;
  final String accuracy;
  final String info;
  final String time;

  Medicine(this.id, this.name, this.accuracy, this.info, this.time);

  factory Medicine.fromJson(dynamic json) {
    return Medicine(
      json['id'] as String,
      json['name'] as String,
      json['accuracy'] as String,
      json['info'] as String,
      json['time'] as String,
    );
  }
}
