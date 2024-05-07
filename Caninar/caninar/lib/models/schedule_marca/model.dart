class ScheduleModel {
  final Map<String, List<Map<String, String>>> schedule;

  ScheduleModel({required this.schedule});

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    final scheduleJson = json['schedule'] as Map<String, dynamic>;
    final Map<String, List<Map<String, String>>> schedule = {};
    scheduleJson.forEach((key, value) {
      schedule[key] = List<Map<String, String>>.from(
          value.map((item) => Map<String, String>.from(item)));
    });
    return ScheduleModel(schedule: schedule);
  }
}
