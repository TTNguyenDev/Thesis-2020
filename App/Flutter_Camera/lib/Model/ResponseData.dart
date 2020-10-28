class User {
  int id;
  int px;
  int py;
  int width;
  int height;
  String accuracy;
  String name;

  User(this.id, this.px, this.py, this.width, this.height, this.accuracy,
      this.name);

  factory User.fromJson(dynamic json) {
    return User(
        json['id'] as int,
        json['px'] as int,
        json['py'] as int,
        json['width'] as int,
        json['height'] as int,
        json['accuracy'] as String,
        json['name'] as String);
  }

  @override
  String toString() {
    return '{ ${this.id}, ${this.name} }';
  }
}
