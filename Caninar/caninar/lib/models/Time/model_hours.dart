class HourModel {
  String? start;
  String? end;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['star'] = start;
    data['end'] = end;
    return data;
  }

  HourModel.fromJson(Map<String, dynamic> json) {
    start = json['star'];
    end = json['end'];
  }
}
