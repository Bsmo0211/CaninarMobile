import 'package:caninar/models/direcciones/model.dart';

class UserLoginModel {
  String? documentType;
  int? createdAt;
  int? status;
  String? documentNumber;
  String? email;
  String? profilePhoto;
  String? googleProviderId;
  String? gender;
  int? updatedAt;
  String? lastName;
  String? firstName;
  String? telephone;
  String? id;
  String? idCart;
  int? type;
  String? idSupplier;
  List<DireccionModel> addresses = [];

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['document_type'] = documentType;
    data['document_number'] = documentNumber;
    data['email'] = email;
    data['profile_photo'] = profilePhoto;
    data['last_name'] = lastName;
    data['first_name'] = firstName;
    data['telephone'] = telephone;
    data['id'] = id;
    data['id_cart'] = idCart;
    data['gender'] = gender;
    data['addresses'] =
        addresses.map((direccion) => direccion.toJson()).toList();
    data['type'] = type;
    data['id_supplier'] = idSupplier;
    return data;
  }

  UserLoginModel.fromJson(Map<String, dynamic> json) {
    documentType = json['document_type'];
    documentNumber = json['document_number'];
    email = json['email'];
    idCart = json['id_cart'];
    profilePhoto = json['profile_photo'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    telephone = json['telephone'];
    gender = json['gender'];
    id = json['id'];
    if (json['addresses'] != null) {
      addresses = List<DireccionModel>.from(json['addresses']
          .map((direccion) => DireccionModel.fromJson(direccion)));
    }
    type = json['type'];
    idSupplier = json['id_supplier'];
  }

  addAdress(String address, String optionalData, String district) {
    addresses.add(DireccionModel(
      idDistrict: district,
      name: address,
      inside: optionalData,
    ));
  }
}
