import 'dart:convert';

import 'package:caninar/API/APi.dart';
import 'package:caninar/constants/principals_colors.dart';
import 'package:caninar/models/distritos/model.dart';
import 'package:caninar/pages/home.dart';
import 'package:caninar/widgets/boton_custom.dart';
import 'package:caninar/widgets/custom_appBar.dart';
import 'package:caninar/widgets/custom_drawer.dart';
import 'package:caninar/widgets/redireccion_atras.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Alidados extends StatefulWidget {
  Alidados({Key? key}) : super(key: key);

  @override
  _AlidadosState createState() => _AlidadosState();
}

class _AlidadosState extends State<Alidados> {
  String dropdownValueTipoPersona = 'Persona Natural';
  List<DropdownMenuItem<DistritosModel>> distritos = [];
  List<String> dropdownTipoPersona = ['Persona Natural', 'Persona Jurídica'];
  DistritosModel? dropdownValueDistrito;
  List<String?> selectedValues = [];
  String dropdownValueActividad = 'Paseador/Adiestrador Canino';
  List<String> dropdownActividad = [
    'Paseador/Adiestrador Canino',
    'Petshop',
    'Veterinaria'
  ];

  submit() async {
    Dio dio = Dio();

    Map<String, dynamic> createAliado = {
      "first_name": nombresCtrl.text,
      "last_name": apellidosCtrl.text,
      "email": correoCtrl.text,
      "person_type": dropdownValueTipoPersona,
      "phone": telefonoCtrl.text,
      "activities": dropdownValueActividad,
      "districts": selectedValues
    };

    await dio
        .post(
      'https://gc1hfo9hl0.execute-api.us-east-1.amazonaws.com/dev/auth/invitation',
      data: createAliado,
    )
        .then((value) async {
      if (value.statusCode == 200) {
        Fluttertoast.showToast(
          msg: 'Solicitud enviada con éxito',
          backgroundColor: Colors.green,
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Home(),
          ),
        );
      }
    }).catchError((e) {
      print(e);
      Fluttertoast.showToast(
          msg: 'Ha ocurrido un error',
          backgroundColor: Colors.red,
          textColor: Colors.black);
    });
  }

  getDistritos() async {
    List<DropdownMenuItem<DistritosModel>> temp = [];
    List<DistritosModel> distritosTemp = await API().getDistritos();

    for (DistritosModel distrito in distritosTemp) {
      temp.add(
        DropdownMenuItem(
          value: distrito,
          child: Text(
            '${distrito.name}',
            style: const TextStyle(fontSize: 15),
          ),
        ),
      );
    }

    setState(() {
      distritos = temp;
    });
  }

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
                padding: const EdgeInsets.only(top: 8, bottom: 5),
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
  void initState() {
    getDistritos();
    super.initState();
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
                Center(
                  child: SizedBox(
                    width: 340,
                    height: 60,
                    child: DropdownButtonFormField(
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.orange, width: 1),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        filled: true,
                      ),
                      dropdownColor: Colors.grey.shade200,
                      value: dropdownValueDistrito,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: distritos,
                      onChanged: (DistritosModel? newValue) async {
                        setState(() {
                          dropdownValueDistrito = newValue;
                          selectedValues.add(newValue?.name);
                        });

                        await Future.delayed(const Duration(seconds: 2));
                      },
                    ),
                  ),
                ),
                if (selectedValues.isNotEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 15, bottom: 15),
                      child: Text(
                        'Distritos Seleccionados',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                Center(
                  child: Column(
                    children: selectedValues.map((e) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                '$e',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  selectedValues.remove(e);
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                BotonCustom(
                  funcion: () async {
                    if (validate()) {
                      await submit();
                    }
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

  bool validate() {
    final form = formKey1.currentState;

    if (form!.validate()) {
      if (selectedValues.isNotEmpty) {
        form.save();
      }
      return true;
    } else {
      return false;
    }
  }
}
