class ReleModel {
  String name;
  int id;

  Map<String, dynamic> toMap() => {'name': name, 'id': id};

  ReleModel.fromMap(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'];
}
