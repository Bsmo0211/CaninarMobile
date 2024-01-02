import 'package:caninar/client/mapa.dart';
import 'package:caninar/constants/principals_colors.dart';
import 'package:caninar/widgets/boton_custom.dart';
import 'package:caninar/widgets/calendario_custom.dart';
import 'package:caninar/widgets/carrito.dart';
import 'package:caninar/widgets/custom_appBar.dart';
import 'package:caninar/widgets/custom_drawer.dart';
import 'package:caninar/widgets/modal_map.dart';
import 'package:caninar/widgets/redireccion_atras.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class FechaPaseosCaninos extends StatefulWidget {
  FechaPaseosCaninos({Key? key}) : super(key: key);

  @override
  _FechaPaseosCaninosState createState() => _FechaPaseosCaninosState();
}

class _FechaPaseosCaninosState extends State<FechaPaseosCaninos> {
  DateTime? diaSeleccionado;
  LatLng? initialCenter;
  TextEditingController telefonoCtrl = TextEditingController();
  bool isApiCallProcess = false;

  List<int> hours = List.generate(23, (index) => index + 1);
  int selectedHour = 1;
  int? selectedOption;

  getUbicacion() async {
    LatLng ubicacionActual = await Mapa().getLocation();
    setState(() {
      initialCenter = ubicacionActual;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isApiCallProcess) {
      EasyLoading.show(status: 'Cargando');
    } else {
      EasyLoading.dismiss();
    }
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: const CustomAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RedireccionAtras(nombre: '1 Paseo Canino'),
          Expanded(
            child: ListView(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Text(
                    'Un paseo de 1 hora a cargo de un profesional certificado de APAI K9.',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
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
                CalendarioCustom(diaSeleccionado: diaSeleccionado),
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
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: PrincipalColors
                          .blueDrops, // Color de fondo del cuadro
                      // Bordes redondeados
                    ),
                    child: DropdownButton<int>(
                      padding: const EdgeInsets.only(left: 25, right: 25),
                      value: selectedHour,
                      items: hours.map((hour) {
                        return DropdownMenuItem<int>(
                          value: hour,
                          child: Text(
                            '$hour:00 - ${hour + 1}:00',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedHour = value!;
                        });
                      },
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 20, top: 15, bottom: 5),
                  child: Text(
                    'Dirección de recojo:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                //column map para mas de una dirección
                ListTile(
                  title: const Text('Direccion'),
                  leading: Radio(
                    activeColor: Colors.black,
                    value: 1,
                    groupValue: selectedOption,
                    onChanged: (value) {
                      setState(() {
                        selectedOption = value as int?;
                        print("Button value: $value");
                      });
                    },
                  ),
                ),
                Center(
                  child: GestureDetector(
                    onTap: () async {
                      setState(() {
                        isApiCallProcess = true;
                      });
                      await getUbicacion();
                      setState(() {
                        isApiCallProcess = false;
                      });

                      // ignore: use_build_context_synchronously
                      showDialog(
                        context: context,
                        builder: ((BuildContext context) {
                          return ModalMap(
                            initialCenter: initialCenter,
                          );
                        }),
                      );
                    },
                    child: Text(
                      'Cambiar dirección',
                      style: TextStyle(
                        color: PrincipalColors.orange,
                        fontSize: 11,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(
                    left: 20,
                    top: 15,
                    bottom: 5,
                  ),
                  child: Text(
                    'Seleccionar mascota:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                //map para perros
                ListTile(
                  title: Row(
                    children: [
                      ClipOval(
                        child: Image.asset(
                          'assets/images/wpp.png',
                          width: 70, // Ajusta el tamaño según tus necesidades
                          height: 70,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const Text('Perro 1')
                    ],
                  ),
                  leading: Radio(
                    activeColor: Colors.black,
                    value: 1,
                    groupValue: selectedOption,
                    onChanged: (value) {
                      setState(() {
                        selectedOption = value as int?;
                        print("Button value: $value");
                      });
                    },
                  ),
                ),
                Center(
                  child: GestureDetector(
                    onTap: () async {},
                    child: Text(
                      '+ Añadir Mascota',
                      style: TextStyle(
                        color: PrincipalColors.orange,
                        fontSize: 11,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
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
                    controller: telefonoCtrl,
                    validator: (telefonoCtrl) {
                      if (telefonoCtrl == null || telefonoCtrl.isEmpty) {
                        return 'El campo es obligatorio';
                      } else {}
                      return null;
                    },
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 20,
                                    bottom: 10,
                                  ),
                                  child: Text(
                                    'Cant.',
                                    style: TextStyle(
                                      color: PrincipalColors.orange,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(
                                    top: 5,
                                    bottom: 20,
                                  ),
                                  child: Text(
                                    '1',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 20,
                                    bottom: 10,
                                  ),
                                  child: Text(
                                    'Producto.',
                                    style: TextStyle(
                                      color: PrincipalColors.orange,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(
                                    top: 5,
                                    bottom: 20,
                                  ),
                                  child: Text(
                                    'Paseo Canino',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20, bottom: 10),
                                  child: Text(
                                    'Precio S/',
                                    style: TextStyle(
                                      color: PrincipalColors.orange,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(top: 5, bottom: 20),
                                  child: Text(
                                    '35.00',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                BotonCustom(
                  funcion: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CarritoCompras(),
                      ),
                    );
                  },
                  texto: 'Agregar al carrito',
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
