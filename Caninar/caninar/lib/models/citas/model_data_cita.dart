import 'package:caninar/models/citas/model_informacion_det_cita.dart';

class DataCitaModel {
  String? name;
  String? image;
  List<InformacionDetalladaCitaModel> infoDetalladaCita = [];

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['image'] = image;
    data['data'] = infoDetalladaCita
        .map((detalladaCita) => detalladaCita.toJson())
        .toList();
    return data;
  }

  DataCitaModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'];
    if (json['data'] != null) {
      infoDetalladaCita = List<InformacionDetalladaCitaModel>.from(json['data']
          .map((detalladaCita) =>
              InformacionDetalladaCitaModel.fromJson(detalladaCita)));
    }
  }
}
