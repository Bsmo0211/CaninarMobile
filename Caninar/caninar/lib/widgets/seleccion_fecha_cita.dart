import 'package:caninar/API/APi.dart';
import 'package:caninar/constants/principals_colors.dart';
import 'package:caninar/widgets/boton_custom.dart';
import 'package:caninar/widgets/calendario_custom.dart';
import 'package:caninar/widgets/custom_appBar.dart';
import 'package:caninar/widgets/home_adriestrador.dart';
import 'package:caninar/widgets/mis_citas.dart';
import 'package:caninar/widgets/redireccion_atras.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class SeleccionFechaCita extends StatefulWidget {
  String idSchedule;
  SeleccionFechaCita({super.key, required this.idSchedule});

  @override
  State<SeleccionFechaCita> createState() => _SeleccionFechaCitaState();
}

class _SeleccionFechaCitaState extends State<SeleccionFechaCita> {
  TextEditingController datosOpcionalesCtrl = TextEditingController();
  List<int> selectedHours = [1];
  List<int> hours = List.generate(23, (index) => index + 1);
  String? horaInicial;
  String? horaFinal;
  String? formattedDateMain;
  updateSchedule() async {
    Map<String, dynamic> updateSchdeule = {
      "date": formattedDateMain,
      "hour": {
        "star": horaInicial,
        "end": horaFinal,
      }
    };

    API().updateScheduleById(widget.idSchedule, updateSchdeule);
  }

  void recibirDiasSeleccionadosWrapper(List<DateTime> selectedDays) {
    String formattedDate = DateFormat('dd/MM/yyyy').format(selectedDays.first);
    setState(() {
      formattedDateMain = formattedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Column(
        children: [
          RedireccionAtras(nombre: 'Agendar una cita'),
          Expanded(
            child: ListView(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 20, top: 15),
                  child: Text(
                    'Selecciona una fecha:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                CalendarioCustom(
                  type: 1,
                  onDiasSeleccionado: recibirDiasSeleccionadosWrapper,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 20, top: 15, bottom: 15),
                  child: Text(
                    'Elige un horario:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Column(
                  children: [
                    for (int index = 0; index < selectedHours.length; index++)
                      Container(
                        decoration: BoxDecoration(
                          color: PrincipalColors.blueDrops,
                        ),
                        child: DropdownButton<int>(
                          padding: const EdgeInsets.only(left: 25, right: 25),
                          value: selectedHours[index],
                          items: hours.map((hour) {
                            return DropdownMenuItem<int>(
                              value: hour,
                              child: Text(
                                '$hour:00 - ${hour + 1}:00',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedHours[index] = value!;
                              int horainicialTemp = selectedHours[index];
                              int horafinalTemp = horainicialTemp + 1;

                              horaInicial = '$horainicialTemp:00';
                              horaFinal = '$horafinalTemp:00';
                            });
                          },
                        ),
                      ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 20, top: 15, bottom: 5),
                  child: Text(
                    'Comentario:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: TextFormField(
                    maxLines: 5,
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1.5,
                          color: PrincipalColors.blueDrops,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      hintText: '¿Algo que necesitemos saber previamente?',
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 5.0,
                        horizontal: 15.0,
                      ),
                      labelStyle: const TextStyle(
                        color: Colors.black,
                      ),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 3,
                        ),
                      ),
                    ),
                    controller: datosOpcionalesCtrl,
                    validator: (datosOpcionalesCtrl) {
                      if (datosOpcionalesCtrl == null ||
                          datosOpcionalesCtrl.isEmpty) {
                        return 'El campo es obligatorio';
                      } else {}
                      return null;
                    },
                  ),
                ),
                Center(
                  child: BotonCustom(
                      funcion: () {
                        if (formattedDateMain != null && horaInicial != null) {
                          showDialog(
                            context: context,
                            builder: (contextDialog) {
                              return AlertDialog(
                                title: const Center(
                                  child: Text(
                                    'Programar Cita',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                content: const Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Estás a punto de programar una nueva cita.',
                                      textAlign: TextAlign.justify,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 5),
                                      child: Text(
                                        '¿Deseas Continuar?',
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                                actions: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: PrincipalColors
                                              .blue, // Color del contenedor "Sí"
                                        ),
                                        child: TextButton(
                                          onPressed: () async {
                                            await updateSchedule();
                                            Navigator.pop(contextDialog);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      MisCitas(
                                                        drawer: true,
                                                      )),
                                            );
                                          },
                                          child: const Text(
                                            'Sí',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: Colors.grey,
                                        ),
                                        child: TextButton(
                                          onPressed: () {
                                            Navigator.pop(contextDialog);
                                          },
                                          child: const Text(
                                            'No',
                                            style: TextStyle(
                                                color: Colors
                                                    .white), // Color opcional para el texto del botón "No"
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          Fluttertoast.showToast(
                              msg: 'Debes llenar los campos requeridos',
                              backgroundColor: Colors.red,
                              textColor: Colors.black);
                        }
                      },
                      texto: 'Programar cita'),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
