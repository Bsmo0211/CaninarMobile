import 'dart:convert';

import 'package:caninar/constants/principals_colors.dart';
import 'package:caninar/widgets/boton_custom.dart';
import 'package:caninar/widgets/custom_appBar.dart';
import 'package:caninar/widgets/custom_drawer.dart';
import 'package:caninar/widgets/redireccion_atras.dart';
import 'package:caninar/widgets/registro_completo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:email_validator/email_validator.dart';

class Registro extends StatefulWidget {
  Registro({Key? key}) : super(key: key);

  @override
  _RegistroState createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
  Map<String, String> dropdownActividadMap = {
    'Masculino': 'male',
    'Femenino': 'female',
  };
  String? dropdownValueActividad;
  bool _acceptTerms = false;
  final formKey1 = GlobalKey<FormState>();
  bool _showPassword = true;
  bool _showPassword1 = true;
  TextEditingController correoCtrl = TextEditingController();
  TextEditingController contrasenaCtrl = TextEditingController();
  TextEditingController contrasena2Ctrl = TextEditingController();
  TextEditingController nombresCtrl = TextEditingController();
  TextEditingController apellidosCtrl = TextEditingController();
  TextEditingController telefonoCtrl = TextEditingController();
  TextEditingController direccionCtrl = TextEditingController();
  TextEditingController identificacionCtrl = TextEditingController();
  RegExp expRegNum = RegExp(r'[0-9]');

  submit() async {
    Dio dio = Dio();
    Map<String, dynamic> createUser = {
      "type": 1,
      "first_name": nombresCtrl.text,
      "last_name": apellidosCtrl.text,
      "email": correoCtrl.text,
      "document_type": "1",
      "gender": dropdownValueActividad,
      "document_number": identificacionCtrl.text,
      "telephone": telefonoCtrl.text,
      "password": contrasena2Ctrl.text,
      //TODO:arreglar envio de direcciones
      "addresses": [
        {
          "name": "Av. Emancipación 153",
          "inside": "int 304",
          "id_district": "1",
          "default": "true"
        },
      ],
      "profile_photo": "s3.com"
    };

    String jsonBody = jsonEncode(createUser);

    await dio
        .post(
      'https://v3x0nryj7b.execute-api.us-east-1.amazonaws.com/dev/users',
      data: jsonBody,
    )
        .then((value) async {
      if (value.statusCode == 200) {
        Fluttertoast.showToast(
          msg: 'Usuario registrado con exito',
          backgroundColor: Colors.green,
        );

        String link =
            'https://v3x0nryj7b.execute-api.us-east-1.amazonaws.com/dev/users/verify/{email}';
        Response response = await dio.get(link);

        if (response.statusCode == 200) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const RegistroCompleto(),
            ),
          );
        }
      }
    }).catchError((e) {
      print(e);
      Fluttertoast.showToast(
          msg: 'Ha ocurrido un error',
          backgroundColor: Colors.red,
          textColor: Colors.black);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: CustomDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RedireccionAtras(nombre: 'Registro'),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: Form(
              key: formKey1,
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      'Datos de Inicio de Sesión',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: Text('Correo Electrónico *'),
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
                      controller: correoCtrl,
                      validator: (correoCtrl) {
                        if (correoCtrl == null || correoCtrl.isEmpty) {
                          return 'El campo es obligatorio';
                        } else {
                          if (EmailValidator.validate(correoCtrl)) {
                            return null;
                          } else {
                            return 'Formato de correo no valido';
                          }
                        }
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: Text('Contraseña *'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: TextFormField(
                      obscureText: _showPassword,
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
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _showPassword = !_showPassword;
                            });
                          },
                          icon: Icon(
                            color: PrincipalColors.blue,
                            _showPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                      ),
                      controller: contrasenaCtrl,
                      validator: (contrasenaCtrl) {
                        RegExp passwordRegExp = RegExp(
                            r'^(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\$&*~]).{8,}$');
                        if (contrasenaCtrl == null || contrasenaCtrl.isEmpty) {
                          return 'Digite una contraseña';
                        } else {}

                        if (contrasenaCtrl != '') {
                          if (!passwordRegExp.hasMatch(contrasenaCtrl)) {
                            return 'La contraseña debe contener al menos\nuna mayúscula, un número ,\nun carácter especial y 8 carácteres (!@#\$&*~).';
                          }
                          return null;
                        }
                        return null;
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: Text('Confirmar Contraseña *'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: TextFormField(
                      obscureText: _showPassword1,
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
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _showPassword1 = !_showPassword1;
                            });
                          },
                          icon: Icon(
                            color: PrincipalColors.blue,
                            _showPassword1
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                      ),
                      controller: contrasena2Ctrl,
                      validator: (contrasena2Ctrl) {
                        if (contrasena2Ctrl != contrasenaCtrl.text) {
                          return 'Las contraseñas no coinciden';
                        } else {}
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                    ),
                    child: Text(
                      'Datos de Inicio de Sesión',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: Text('Nombres *'),
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
                    padding: EdgeInsets.only(top: 15),
                    child: Text('Apellidos *'),
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
                      controller: apellidosCtrl,
                      validator: (apellidosCtrl) {
                        if (apellidosCtrl == null || apellidosCtrl.isEmpty) {
                          return 'El campo es obligatorio';
                        } else {}
                        return null;
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: Text('Número de Identificación *'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: TextFormField(
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(expRegNum)
                      ],
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
                      controller: identificacionCtrl,
                      validator: (identificacionCtrl) {
                        if (identificacionCtrl == null ||
                            identificacionCtrl.isEmpty) {
                          return 'El campo es obligatorio';
                        } else {}
                        return null;
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: Text('Sexo *'),
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
                      value: dropdownValueActividad,
                      items: dropdownActividadMap.keys.map((String item) {
                        return DropdownMenuItem(
                          value: dropdownActividadMap[item],
                          child: Text(
                            item,
                          ),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        // Handle dropdown value change
                        setState(() {
                          dropdownValueActividad = newValue!;
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
                    padding: EdgeInsets.only(top: 15),
                    child: Text('Teléfono *'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: TextFormField(
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(expRegNum)
                      ],
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
                  CheckboxListTile(
                    activeColor: PrincipalColors.blue,
                    title: RichText(
                        text: TextSpan(
                      text: 'Al crear una cuenta estas aceptando los ',
                      style: DefaultTextStyle.of(context).style,
                      children: [
                        TextSpan(
                          text: 'términos y condiciones ',
                          style: TextStyle(
                            color: PrincipalColors.orange,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        const TextSpan(
                          text: 'del aplicativo *',
                        ),
                      ],
                    )),
                    value: _acceptTerms,
                    onChanged: (value) {
                      setState(() {
                        _acceptTerms = value!;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  BotonCustom(
                    funcion: () async {
                      if (validate()) {
                        if (_acceptTerms) {
                          await submit();
                        } else {
                          Fluttertoast.showToast(
                            msg: 'Se debe aceptar los terminos y condiciones',
                            backgroundColor: Colors.yellow,
                            textColor: Colors.black,
                          );
                        }
                      }
                    },
                    texto: 'Registrarse',
                  )
                ],
              ),
            ),
          ))
        ],
      ),
    );
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
