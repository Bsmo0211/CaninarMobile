import 'package:caninar/API/APi.dart';
import 'package:caninar/constants/principals_colors.dart';
import 'package:caninar/models/distritos/model.dart';
import 'package:caninar/models/user/model.dart';
import 'package:caninar/shared_Preferences/shared.dart';
import 'package:caninar/widgets/boton_custom.dart';
import 'package:flutter/material.dart';

class SeleccionDireccion extends StatefulWidget {
  Function agregarDireccion;
  bool updateDireccion;
  SeleccionDireccion({
    super.key,
    required this.agregarDireccion,
    required this.updateDireccion,
  });

  @override
  State<SeleccionDireccion> createState() => _SeleccionDireccionState();
}

class _SeleccionDireccionState extends State<SeleccionDireccion> {
  UserLoginModel? user;
  List<DropdownMenuItem<String>> distritos = [];
  String? dropdownvalueDistritos;
  TextEditingController direccionCtrl = TextEditingController();
  TextEditingController datosOpcionalesCtrl = TextEditingController();
  final formKey1 = GlobalKey<FormState>();

  getCurrentUser() async {
    UserLoginModel? userTemp = await Shared().currentUser();

    setState(() {
      user = userTemp;
    });
  }

  getDistritos() async {
    List<DropdownMenuItem<String>> temp = [];
    List<DistritosModel> distritosTemp = await API().getDistritos();

    for (DistritosModel distrito in distritosTemp) {
      temp.add(
        DropdownMenuItem(
          value: distrito.slug,
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

  @override
  void initState() {
    getCurrentUser();
    getDistritos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: formKey1,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 15),
              child: Text('Distrito *'),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
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
                value: dropdownvalueDistritos,
                items: distritos,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El campo es obligatorio';
                  } else {}
                  return null;
                },
                onChanged: (newValue) {
                  setState(() {
                    dropdownvalueDistritos = newValue!;
                  });
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 15),
              child: Text('Dirección *'),
            ),
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
                controller: direccionCtrl,
                validator: (direccionCtrl) {
                  if (direccionCtrl == null || direccionCtrl.isEmpty) {
                    return 'El campo es obligatorio';
                  } else {}
                  return null;
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 15),
              child: Text('Datos opcionales'),
            ),
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
                controller: datosOpcionalesCtrl,
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (widget.updateDireccion) {
                  if (validate()) {
                    widget.agregarDireccion(
                      direccionCtrl.text,
                      datosOpcionalesCtrl.text,
                      dropdownvalueDistritos,
                    );

                    Navigator.pop(context);
                    setState(() {});
                  }
                }

                setState(() {
                  dropdownvalueDistritos = null;
                  direccionCtrl.clear();
                  datosOpcionalesCtrl.clear();
                });
              },
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(
                  PrincipalColors.blue,
                ),
              ),
              child: const Text('Agregar Direccion'),
            )
          ],
        ));
  }

  bool validate() {
    final form = formKey1.currentState;

    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }
}
