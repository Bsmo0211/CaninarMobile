class CoverageModel {
  String? idDistrict;
  String? deliveryCost;
  String? deliveryTime;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id_District'] = idDistrict;
    data['delivery_cost'] = deliveryCost;
    data['delivery_time'] = deliveryTime;
    return data;
  }

  CoverageModel.fromJson(Map<String, dynamic> json) {
    idDistrict = json['id_district'];
    deliveryCost = json['delivery_cost'];
    deliveryTime = json['delivery_time'];
  }
}
