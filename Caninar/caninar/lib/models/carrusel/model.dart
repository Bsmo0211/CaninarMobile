class CarruselModel {
  String? imageMobile;
  int? order;
  String? title;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['image'] = imageMobile;
    data['image_mobile'] = order;
    data['name'] = title;

    return data;
  }

  CarruselModel.fromJson(Map<String, dynamic> json) {
    imageMobile = json['image_mobile'];
    order = json['order'];
    title = json['name'];
  }
}
