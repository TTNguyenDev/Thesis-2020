import 'dart:ffi';

class Medicine {
  String contains;
  String display_name;
  String morning;
  String afternoon;
  String evening;
  String info;
  String line;
  Medicine(this.contains, this.display_name, this.morning, this.afternoon, this.evening,
      this.info, this.line);

  factory Medicine.fromJson(dynamic json) {
    var medicine = Medicine(json['contains'], json['display_name'], json['morning'], json['afternoon'], json['evening'], json['info'], json['line']);
    return medicine;
  }
  Map<String, dynamic> toJson() => {
    "contains": contains == null ? null : contains,
    "display_name": display_name == null ? null : display_name,
    "morning": morning == null ? null : morning,
    "afternoon": afternoon == null ? null : afternoon,
    "evening": evening == null ? null : evening,
    "info": info == null ? null : info,
    "line": line == null ? null : line,
  };

  @override
  String toString() {
    return '{ ${this.contains}, ${this.display_name}, ${this.morning} ${this.afternoon}, ${this.evening}, ${this.info}, ${this.line} }';
  }
}
// class ListMedicine{
//   List <Medicine> listmedicine ;
//   ListMedicine(this.listmedicine);
//   // factory ListMedicine.fromJson(dynamic json){
//   //   var ListMedicine =
//   // }
//   }
//
// }
