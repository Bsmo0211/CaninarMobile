class DireccionModel {
  String? name;
  String? inside;
  String? idDistrict;

  DireccionModel({
    required this.name,
    required this.inside,
    required this.idDistrict,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['inside'] = inside;
    data['name'] = name;
    data['id_district'] = idDistrict;

    return data;
  }

  DireccionModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    inside = json['inside'];
    idDistrict = json['id_district'];
  }
}
