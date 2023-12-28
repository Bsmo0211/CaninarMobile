class DistritosModel {
 String? slug;
  String? name;

   Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['slug'] = slug;
    data['name'] = name;

    return data;
  }

   DistritosModel.fromJson(Map<String, dynamic> json) {
    slug = json['slug'];
    name = json['name'];
  }
}