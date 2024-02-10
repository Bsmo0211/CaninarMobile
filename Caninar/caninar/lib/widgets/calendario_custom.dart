import 'package:caninar/constants/principals_colors.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CalendarioCustom extends StatefulWidget {
  int type;

  Function(DateTime selectedDay)? onDiaSeleccionado;
  CalendarioCustom({
    Key? key,
    required this.type,
    this.onDiaSeleccionado,
  }) : super(key: key);

  @override
  _CalendarioCustomState createState() => _CalendarioCustomState();
}

class _CalendarioCustomState extends State<CalendarioCustom> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Card(
          elevation: 7,
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: SfDateRangePicker(
              backgroundColor: Colors.white,
              showNavigationArrow: true,
              monthViewSettings: const DateRangePickerMonthViewSettings(
                weekendDays: [6, 7],
              ),
              selectableDayPredicate: (DateTime date) {
                return date.weekday != DateTime.saturday &&
                    date.weekday != DateTime.sunday;
              },
              onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                setState(() {
                  if (args.value is DateTime) {
                    if (widget.onDiaSeleccionado != null) {
                      // Añade esta condición
                      widget.onDiaSeleccionado!(args.value); // Añade esta línea
                    }
                  } else if (args.value is List<DateTime>) {
                    // Handle multiple selection if needed
                  }
                });
              },
              monthCellStyle: DateRangePickerMonthCellStyle(
                weekendDatesDecoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  shape: BoxShape.circle,
                ),
                cellDecoration: BoxDecoration(
                  color: PrincipalColors.blueDrops,
                  shape: BoxShape.circle,
                ),
                todayTextStyle: const TextStyle(
                  color: Colors.black,
                ),
                disabledDatesDecoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  shape: BoxShape.circle,
                ),
              ),
              view: DateRangePickerView.month,
              headerStyle: const DateRangePickerHeaderStyle(
                textAlign: TextAlign.center,
              ),
              enablePastDates: false,
              selectionMode: widget.type == 1
                  ? DateRangePickerSelectionMode.single
                  : DateRangePickerSelectionMode.multiple,
            ),
          ),
        ),
      ),
    );
  }
}
