class ProductoModel {
  String? slug;
  int? discountPercent;
  int? stock;
  String? name;
  String? image;
  String? description;
  String? price;
  String? id;
  int? typePro;
  int? priceOffer;
  String? units;
  List<String>? categories;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['slug'] = slug;
    data['discount_percent'] = discountPercent;
    data['stock'] = stock;
    data['type_pro'] = typePro;
    data['image'] = image;
    data['name'] = name;
    data['description'] = description;
    data['price'] = price;
    data['id'] = id;
    data['price_offer'] = priceOffer;
    data['units'] = units;
    data['categories'] = categories;

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
    discountPercent = json['discount_percent'];
    priceOffer = json['price_offer'];
    units = json['units'];
    categories = List<String>.from(json['categories']);
  }
}
