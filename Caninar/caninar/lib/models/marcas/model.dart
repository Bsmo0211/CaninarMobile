class MarcasModel {
  String? deliveryTime;
  String? bussinesName;
  String? contact;
  String? slug;
  int? rating;
  String? name;
  String? image;
  String? telephone;
  String? id;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['deliveryTime'] = deliveryTime;
    data['bussinesName'] = bussinesName;
    data['contact'] = contact;
    data['slug'] = slug;
    data['rating'] = rating;
    data['image'] = image;
    data['name'] = name;
    data['telephone'] = telephone;
    data['id'] = id;

    return data;
  }

  MarcasModel.fromJson(Map<String, dynamic> json) {
    deliveryTime = json['deliveryTime'];
    bussinesName = json['bussinesName'];
    contact = json['contact'];
    slug = json['slug'];
    if (json['rating'].runtimeType == String) {
      rating = int.parse(json['rating']);
    } else {
      rating = json['rating'];
    }
    image = json['image'];
    name = json['name'];
    telephone = json['telephone'];
    id = json['id'];
  }
}
