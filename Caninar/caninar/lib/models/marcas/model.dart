import 'package:caninar/models/certificados/model.dart';
import 'package:caninar/models/coverage/model.dart';
import 'package:caninar/models/direcciones/model.dart';

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
  int? ruc;
  String? minOrderAmount;
  String? minAmountFreeDelivery;
  List<CertificadosModel>? certificates;
  List<CoverageModel>? coverage;
  List<DireccionModel> addresses = [];
  List<String>? categories;

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
    data['certificates'] = certificates;
    data['coverage'] = coverage;
    data['RUC'] = ruc;
    data['min_order_amount'] = minOrderAmount;
    data['min_amount_free_delivery'] = minAmountFreeDelivery;
    data['addresses'] =
        addresses.map((direccion) => direccion.toJson()).toList();
    data['categories'] = categories;

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
    ruc = json['RUC'];
    telephone = json['telephone'];
    id = json['id'];
    minOrderAmount = json['min_order_amount'];
    minAmountFreeDelivery = json['min_amount_free_delivery'];
    certificates = (json['certificates'] as List<dynamic>?)
        ?.map((cert) => CertificadosModel.fromJson(cert))
        .toList();
    coverage = (json['coverage'] as List<dynamic>?)
        ?.map((cov) => CoverageModel.fromJson(cov))
        .toList();

    if (json['addresses'] != null) {
      addresses = List<DireccionModel>.from(json['addresses']
          .map((direccion) => DireccionModel.fromJson(direccion)));
    }
    categories = List<String>.from(json['categories']);
  }
}
