class DistritosModel {
  String? slug;
  String? name;
  int? idDepartament;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['slug'] = slug;
    data['name'] = name;
    data['id_deparment'] = idDepartament;

    return data;
  }

  DistritosModel.fromJson(Map<String, dynamic> json) {
    slug = json['slug'];
    name = json['name'];
    idDepartament = json['id_deparment'];
  }
}
