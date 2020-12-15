import 'dart:ffi';

class Medicine {
  final String name;
  final String accuracy;
  String morning;
  String afternoon;
  String evening;
  final String info;

  Medicine(this.name, this.accuracy, this.morning, this.afternoon, this.evening,
      this.info);

  factory Medicine.fromJson(dynamic json) {
    return Medicine(
      json['name'] as String,
      json['accuracy'] as String,
      json['morning'] as String,
      json['afternoon'] as String,
      json['evening'] as String,
      json['info'] as String,
    );
  }
}
