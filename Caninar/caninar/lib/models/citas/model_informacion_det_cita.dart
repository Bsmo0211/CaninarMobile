import 'package:caninar/models/Time/model_time.dart';

class InformacionDetalladaCitaModel {
  String? categoryId;
  String? petId;
  String? status;
  String? supplierId;
  String? idUser;
  String? id;
  TimeModel? time;
  String? direccion;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['category_id'] = categoryId;
    data['pet_id'] = petId;
    data['sh_status'] = status;
    data['supplier_id'] = supplierId;
    data['id_user'] = idUser;
    data['id'] = id;
    if (time != null) {
      data['time'] = time!.toJson();
    }
    data['name_adress'] = direccion;
    return data;
  }

  InformacionDetalladaCitaModel.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'];
    petId = json['pet_id'];
    status = json['sh_status'];
    supplierId = json['supplier_id'];
    idUser = json['id_user'];
    id = json['id'];
    if (json['time'] != null) {
      time = TimeModel.fromJson(json['time']);
    }
    direccion = json['name_adress'];
  }
}
