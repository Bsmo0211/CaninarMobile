import 'dart:io';

import 'package:caninar/constants/principals_colors.dart';
import 'package:caninar/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:snippet_coder_utils/multi_images_utils.dart';

class RegistroMascota extends StatefulWidget {
  bool registro;
  RegistroMascota({
    super.key,
    required this.registro,
  });

  @override
  State<RegistroMascota> createState() => _RegistroMascotaState();
}

class _RegistroMascotaState extends State<RegistroMascota> {
  TextEditingController nombresCtrl = TextEditingController();
  TextEditingController razaCtrl = TextEditingController();
  final formKey1 = GlobalKey<FormState>();
  File? _imageFile;
  bool esterilizado = false;
  String? dropdownValueSexo;
  Map<String, String> dropdownSexoMap = {
    'Macho': 'male',
    'Hembra': 'female',
  };
  String? dropdownValueTamano;
  Map<String, String> dropdownTamanoMap = {
    'Pequeño (1kg - 8Kg)': 'pequeño',
    'Mediano (-kg - -Kg)': 'mediano',
  };

  Future<void> _getImage() async {}

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
          key: formKey1,
          child: ListView(
            children: [
              Center(
                child: GestureDetector(
                  onTap: () {},
                  child: CircleAvatar(
                      radius: 80.0,
                      backgroundColor: Colors.grey[300],
                      backgroundImage:
                          _imageFile != null ? FileImage(_imageFile!) : null,
                      child: const Icon(
                        Icons.camera_alt,
                        size: 40.0,
                        color: Colors.white,
                      )),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 15, left: 15),
                child: Text('Nombre de tu mascota'),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
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
              const Padding(
                padding: EdgeInsets.only(top: 15, left: 15),
                child: Text('Sexo'),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: DropdownButtonFormField<String>(
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
                  ),
                  value: dropdownValueSexo,
                  items: dropdownSexoMap.keys.map((String item) {
                    return DropdownMenuItem(
                      value: dropdownSexoMap[item],
                      child: Text(
                        item,
                      ),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    // Handle dropdown value change
                    setState(() {
                      dropdownValueSexo = newValue!;
                    });
                  },
                  validator: (selectedValue) {
                    if (selectedValue == null || selectedValue.isEmpty) {
                      return 'Selecciona un valor';
                    }
                    return null;
                  },
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 15, left: 15),
                child: Text('Esterilizado'),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          esterilizado = true;
                        });
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              esterilizado ? PrincipalColors.blue : Colors.grey,
                        ),
                        child: const Center(
                          child: Text(
                            'Sí',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          esterilizado = false;
                        });
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: esterilizado
                              ? Colors.grey
                              : PrincipalColors.orange,
                        ),
                        child: const Center(
                          child: Text(
                            'No',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 15, left: 15),
                child: Text('Tamaño'),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: DropdownButtonFormField<String>(
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
                  ),
                  value: dropdownValueTamano,
                  items: dropdownTamanoMap.keys.map((String item) {
                    return DropdownMenuItem(
                      value: dropdownTamanoMap[item],
                      child: Text(
                        item,
                      ),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    // Handle dropdown value change
                    setState(() {
                      dropdownValueTamano = newValue!;
                    });
                  },
                  validator: (selectedValue) {
                    if (selectedValue == null || selectedValue.isEmpty) {
                      return 'Selecciona un valor';
                    }
                    return null;
                  },
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 15, left: 15),
                child: Text('Raza'),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
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
                  controller: razaCtrl,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 25),
                child: Center(
                  child: SizedBox(
                    width: 300,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll<Color>(
                            PrincipalColors.blue),
                      ),
                      child: Text(
                        widget.registro == true
                            ? 'Crear Mascota'
                            : 'Editar Mascota',
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Home()),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
