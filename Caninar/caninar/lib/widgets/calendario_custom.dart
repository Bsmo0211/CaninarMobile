import 'package:caninar/constants/principals_colors.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CalendarioCustom extends StatefulWidget {
  int type;
  Function(List<DateTime>)? onDiasSeleccionado;

  CalendarioCustom({
    Key? key,
    required this.type,
    this.onDiasSeleccionado,
  }) : super(key: key);

  @override
  _CalendarioCustomState createState() => _CalendarioCustomState();
}

class _CalendarioCustomState extends State<CalendarioCustom> {
  List<DateTime> selectedDays = [];

  @override
  Widget build(BuildContext context) {
    /*   print('object');
    print(widget.type); */
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
                  if (widget.type == 1) {
                    selectedDays.clear();
                    selectedDays.add(args.value);
                  } else if (widget.type == 2) {
                    selectedDays.clear();
                    selectedDays.addAll(args.value);
                  }
                  if (widget.onDiasSeleccionado != null) {
                    widget.onDiasSeleccionado!(selectedDays);
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
                  : DateRangePickerSelectionMode
                      .multiple, // Selección única o múltiple
            ),
          ),
        ),
      ),
    );
  }
}
