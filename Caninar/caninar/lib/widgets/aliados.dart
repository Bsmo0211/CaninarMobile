import 'package:caninar/constants/principals_colors.dart';
import 'package:caninar/widgets/boton_custom.dart';
import 'package:caninar/widgets/custom_appBar.dart';
import 'package:caninar/widgets/custom_drawer.dart';
import 'package:caninar/widgets/redireccion_atras.dart';
import 'package:flutter/material.dart';

class Alidados extends StatefulWidget {
  Alidados({Key? key}) : super(key: key);

  @override
  _AlidadosState createState() => _AlidadosState();
}

class _AlidadosState extends State<Alidados> {
  String dropdownValueTipoPersona = 'Persona Natural';
  List<String> dropdownTipoPersona = ['Persona Natural', 'Persona Jurídica'];

  String dropdownValueActividad = 'Paseador/Adiestrador Canino';
  List<String> dropdownActividad = [
    'Paseador/Adiestrador Canino',
    'Petshop',
    'Veterinaria'
  ];

  final formKey1 = GlobalKey<FormState>();
  TextEditingController nombresCtrl = TextEditingController();
  TextEditingController apellidosCtrl = TextEditingController();
  TextEditingController correoCtrl = TextEditingController();
  TextEditingController telefonoCtrl = TextEditingController();
  TextEditingController numeroRucCtrl = TextEditingController();

  Widget buildFormBasedOnDropdown() {
    if (dropdownValueTipoPersona.contains('Persona Natural')) {
      return Form(
        key: formKey1,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Nombres'),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 12),
                child: TextFormField(
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1.5,
                        color: PrincipalColors.blue,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1.5,
                        color: PrincipalColors.blue,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
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
                  controller: nombresCtrl,
                  validator: (nombresCtrl) {
                    if (nombresCtrl == null || nombresCtrl.isEmpty) {
                      return 'El campo es obligatorio';
                    } else {}
                    return null;
                  },
                ),
              ),
              const Text('Apellidos'),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 12),
                child: TextFormField(
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1.5,
                        color: PrincipalColors.blue,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1.5,
                        color: PrincipalColors.blue,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
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
                  controller: apellidosCtrl,
                  validator: (apellidosCtrl) {
                    if (apellidosCtrl == null || apellidosCtrl.isEmpty) {
                      return 'El campo es obligatorio';
                    } else {}
                    return null;
                  },
                ),
              ),
              const Text('Correo Electrónico'),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 12),
                child: TextFormField(
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1.5,
                        color: PrincipalColors.blue,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1.5,
                        color: PrincipalColors.blue,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
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
                  controller: correoCtrl,
                  validator: (correoCtrl) {
                    if (correoCtrl == null || correoCtrl.isEmpty) {
                      return 'El campo es obligatorio';
                    } else {}
                    return null;
                  },
                ),
              ),
              const Text('Teléfono'),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: TextFormField(
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1.5,
                        color: PrincipalColors.blue,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1.5,
                        color: PrincipalColors.blue,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
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
            ],
          ),
        ),
      );
    } else {
      return Form(
        key: formKey1,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Razón Social'),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 12),
                child: TextFormField(
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1.5,
                        color: PrincipalColors.blue,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1.5,
                        color: PrincipalColors.blue,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
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
                  controller: nombresCtrl,
                  validator: (nombresCtrl) {
                    if (nombresCtrl == null || nombresCtrl.isEmpty) {
                      return 'El campo es obligatorio';
                    } else {}
                    return null;
                  },
                ),
              ),
              const Text('Número de RUC'),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 12),
                child: TextFormField(
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1.5,
                        color: PrincipalColors.blue,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1.5,
                        color: PrincipalColors.blue,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
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
                  controller: numeroRucCtrl,
                  validator: (numeroRucCtrl) {
                    if (numeroRucCtrl == null || numeroRucCtrl.isEmpty) {
                      return 'El campo es obligatorio';
                    } else {}
                    return null;
                  },
                ),
              ),
              const Text('Correo Electrónico'),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 12),
                child: TextFormField(
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1.5,
                        color: PrincipalColors.blue,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1.5,
                        color: PrincipalColors.blue,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
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
                  controller: correoCtrl,
                  validator: (correoCtrl) {
                    if (correoCtrl == null || correoCtrl.isEmpty) {
                      return 'El campo es obligatorio';
                    } else {}
                    return null;
                  },
                ),
              ),
              const Text('Teléfono'),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: TextFormField(
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1.5,
                        color: PrincipalColors.blue,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1.5,
                        color: PrincipalColors.blue,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
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
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: CustomDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RedireccionAtras(nombre: 'Quiero ser un aliado'),
          Expanded(
            child: ListView(
              children: [
                Center(
                  child: Container(
                    padding: const EdgeInsets.only(left: 50, right: 50),
                    decoration: BoxDecoration(
                      color: PrincipalColors.blueDrops,
                    ),
                    child: DropdownButton(
                      dropdownColor: Colors.grey.shade200,
                      underline: Container(),
                      value: dropdownValueTipoPersona,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: dropdownTipoPersona.map((String item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Text(
                            item,
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValueTipoPersona = newValue!;
                        });
                      },
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 20, top: 20, bottom: 20),
                  child: Text(
                    'Actividad',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Center(
                  child: Container(
                    padding: const EdgeInsets.only(left: 50, right: 50),
                    decoration: BoxDecoration(
                      color: PrincipalColors.blueDrops,
                    ),
                    child: DropdownButton(
                      dropdownColor: Colors.grey.shade200,
                      underline: Container(),
                      value: dropdownValueActividad,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: dropdownActividad.map((String item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Text(
                            item,
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValueActividad = newValue!;
                        });
                      },
                    ),
                  ),
                ),
                buildFormBasedOnDropdown(),
                const Padding(
                  padding: EdgeInsets.only(left: 20, bottom: 15),
                  child: Text(
                    'Distritos de cobertura',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 15),
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: PrincipalColors.blue,
                        width: 2.0,
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'Contenido',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
                BotonCustom(
                  funcion: () {
                    print('object');
                  },
                  texto: 'Enviar Solicitud',
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
