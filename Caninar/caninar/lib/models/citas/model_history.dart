import 'package:caninar/models/citas/model_data_cita.dart';

class HistoryModel {
  int? counter;
  List<DataCitaModel> dataCita = [];

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['counter'] = counter;
    data['data'] = dataCita.map((dataCita) => dataCita.toJson()).toList();

    return data;
  }

  HistoryModel.fromJson(Map<String, dynamic> json) {
    counter = json['counter'];
    if (json['data'] != null) {
      dataCita = List<DataCitaModel>.from(
          json['data'].map((dataCita) => DataCitaModel.fromJson(dataCita)));
    }
  }
}
