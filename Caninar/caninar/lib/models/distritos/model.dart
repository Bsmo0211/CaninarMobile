class DistritosModel {
  String? id;
  String? slug;
  String? name;
  int? idDepartament;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['slug'] = slug;
    data['name'] = name;
    data['id_deparment'] = idDepartament;

    return data;
  }

  DistritosModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    slug = json['slug'];
    name = json['name'];
    idDepartament = json['id_deparment'];
  }
}
