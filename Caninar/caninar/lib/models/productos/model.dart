class ProductoModel {
  String? slug;
  int? stock;
  String? name;
  String? image;
  String? description;
  String? price;
  String? id;
  int? typePro;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['slug'] = slug;
    data['stock'] = stock;
    data['type_pro'] = typePro;
    data['image'] = image;
    data['name'] = name;
    data['description'] = description;
    data['price'] = price;
    data['id'] = id;

    return data;
  }

  ProductoModel.fromJson(Map<String, dynamic> json) {
    slug = json['slug'];
    if (json['stock'].runtimeType == String) {
      stock = int.parse(json['stock']);
    } else {
      stock = json['stock'];
    }
    if (json['type_pro'].runtimeType == String) {
      typePro = int.parse(json['type_pro']);
    } else {
      typePro = json['type_pro'];
    }
    image = json['image'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
    id = json['id'];
  }
}
