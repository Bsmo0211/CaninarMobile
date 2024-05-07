import 'package:caninar/constants/principals_colors.dart';
import 'package:flutter/material.dart';

class HorarioAtencion extends StatefulWidget {
  Map<String, List<Map<String, String>>> schedule;
  HorarioAtencion({super.key, required this.schedule});

  @override
  State<HorarioAtencion> createState() => _HorarioAtencionState();
}

class _HorarioAtencionState extends State<HorarioAtencion> {
  final orderedDays = ['L', 'M', 'X', 'J', 'V', 'S', 'D'];

  Widget _buildCellDays(String text) {
    return Container(
      padding: const EdgeInsets.all(5),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 9),
      ),
    );
  }

  Widget _buildCellHours(String text) {
    return Container(
      padding: const EdgeInsets.all(3),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 8.7),
      ),
    );
  }

  Widget _buildAvailableCell(
      String time, List<Map<String, String>> workingHours) {
    for (var hours in workingHours) {
      DateTime currentTime;
      DateTime initTime = DateTime.parse('2024-01-01 ${hours['init']}:00');
      DateTime endTime = DateTime.parse('2024-01-01 ${hours['end']}:00');
      if (time.length == 4) {
        currentTime = DateTime.parse('2024-01-01 0$time:00');
      } else {
        currentTime = DateTime.parse('2024-01-01 $time:00');
      }

      if ((currentTime.isAtSameMomentAs(initTime) ||
              currentTime.isAfter(initTime)) &&
          (currentTime.isBefore(endTime) ||
              currentTime.isAtSameMomentAs(endTime))) {
        return Container(
          color: PrincipalColors.blue,
          height: 3,
        );
      }
    }
    return Container(
      color: Colors.white,
      height: 10.0,
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Table(
      border: const TableBorder(
        horizontalInside: BorderSide(width: 2),
        verticalInside: BorderSide(color: Colors.white),
        top: BorderSide(width: 1),
        left: BorderSide(width: 1),
        right: BorderSide(width: 1),
        bottom: BorderSide(width: 1),
      ),
      defaultVerticalAlignment: TableCellVerticalAlignment.intrinsicHeight,
      children: [
        TableRow(
          children: [
            _buildCellDays(' '),
            for (var day in orderedDays)
              if (widget.schedule.containsKey(day)) _buildCellDays(day),
          ],
        ),
        for (var hour = 6; hour <= 24; hour++)
          TableRow(
            children: [
              _buildCellHours('$hour:00'),
              for (var day in orderedDays)
                if (widget.schedule.containsKey(day))
                  _buildAvailableCell('$hour:00', widget.schedule[day]!),
            ],
          ),
      ],
    );
  }
}
