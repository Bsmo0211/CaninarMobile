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
  //TODO:terminan modelo
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

    return data;
  }

  UserLoginModel.fromJson(Map<String, dynamic> json) {
    documentType = json['document_type'];
    documentNumber = json['document_number'];
    email = json['email'];
    idCart = json['id_cart'];
    profilePhoto = json['profile_photo'];
    lastName = json['last_name'];
    telephone = json['telephone'];
    id = json['id'];
    firstName = json['first_name'];
  }
}
