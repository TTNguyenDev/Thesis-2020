import 'dart:ffi';


class Medicine {
  String contain;
  String display_name;
  String morning;
  String afternoon;
  String evening;
  String info;
  String line;
  Medicine(this.contain, this.display_name, this.morning, this.afternoon, this.evening,
      this.info, this.line);

  factory Medicine.fromJson(dynamic json) {
    var medicine = Medicine(json['contain'], json['display_name'], json['morning'], json['afternoon'], json['evening'], json['info'], json['line']);
    return medicine;
  }
  Map<String, dynamic> toJson() => {
    "name": contain == null ? null : contain,
    "accuracy": display_name == null ? null : display_name,
    "morning": morning == null ? null : morning,
    "afternoon": afternoon == null ? null : afternoon,
    "evening": evening == null ? null : evening,
    "info": info == null ? null : info,
    "line": line == null ? null : line,
  };

  @override
  String toString() {
    return '{ ${this.contain}, ${this.display_name}, ${this.morning} ${this.afternoon}, ${this.evening}, ${this.info}, ${this.line} }';
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
