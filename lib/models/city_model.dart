class CityModel {
  String id;
  String name;

  CityModel();

  Map<String, dynamic> toMap() => {'id': id, 'name': name};

  CityModel.fromMap(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'];
}
