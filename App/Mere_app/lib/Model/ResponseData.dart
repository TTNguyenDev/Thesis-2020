import 'dart:ffi';

class Medicine {
  String name;
  String accuracy;
  String morning;
  String afternoon;
  String evening;
  String info;

  Medicine(this.name, this.accuracy, this.morning, this.afternoon, this.evening,
      this.info);

  factory Medicine.fromJson(dynamic json) {
    var medicine = Medicine(json['name'], json['accuracy'], json['morning'], json['afternoon'], json['evening'], json['info']);
    return medicine;
  }
  Map<String, dynamic> toJson() => {
    "name": name == null ? null : name,
    "accuracy": accuracy == null ? null : accuracy,
    "morning": morning == null ? null : morning,
    "afternoon": afternoon == null ? null : afternoon,
    "evening": evening == null ? null : evening,
    "info": info == null ? null : info
  };


  @override
  String toString() {
    return '{ ${this.name}, ${this.morning} ${this.afternoon}, ${this.evening}, ${this.info} }';
  }
}
