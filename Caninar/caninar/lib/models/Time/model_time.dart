import 'package:caninar/models/Time/model_hours.dart';

class TimeModel {
  String? date;
  HourModel? hour;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['date'] = date;
    if (hour != null) {
      data['hour'] = hour!.toJson();
    }
    return data;
  }

  TimeModel.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    if (json['hour'] != null) {
      hour = HourModel.fromJson(json['hour']);
    }
  }
}
