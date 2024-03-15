import 'dart:convert';
import 'dart:io';

import 'package:aws_s3_upload/aws_s3_upload.dart';
import 'package:caninar/API/APi.dart';
import 'package:caninar/constants/access_keys.dart';
import 'package:caninar/constants/principals_colors.dart';
import 'package:caninar/models/user/model.dart';
import 'package:caninar/shared_Preferences/shared.dart';
import 'package:caninar/widgets/boton_custom.dart';
import 'package:caninar/widgets/custom_appBar.dart';
import 'package:caninar/widgets/custom_drawer.dart';
import 'package:caninar/widgets/login.dart';
import 'package:caninar/widgets/redireccion_atras.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditarPerfil extends StatefulWidget {
  const EditarPerfil({super.key});

  @override
  State<EditarPerfil> createState() => _EditarPerfilState();
}

class _EditarPerfilState extends State<EditarPerfil> {
  final ImagePicker _picker = ImagePicker();
  File? imagePersona;
  UserLoginModel? user;
  TextEditingController nombresCtrl = TextEditingController();
  TextEditingController apellidosCtrl = TextEditingController();
  TextEditingController correoCtrl = TextEditingController();
  TextEditingController telefonoCtrl = TextEditingController();
  getCurrentUser() async {
    UserLoginModel? userTemp = await Shared().currentUser();

    setState(() {
      user = userTemp;
    });
  }

  tomarFoto() async {
    final source = await showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Seleccionar'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(ImageSource.gallery),
              child: const Text('Galería'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(ImageSource.camera),
              child: const Text('Cámara'),
            ),
          ],
        );
      },
    );

    if (source != null) {
      XFile? photo = await _picker.pickImage(source: source);

      if (photo != null) {
        File photofile = File(photo.path);

        setState(() {
          imagePersona = photofile;
        });
      }
      AwsS3.uploadFile(
        accessKey: Keys.awsAccessKey,
        secretKey: Keys.awsSecretKey,
        file: File(imagePersona!.path),
        bucket: "caninar-images",
        region: "us-east-1",
        destDir: "users",
      );
    }
  }

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  updateUser(UserLoginModel updatedUser) async {
    await API().updateUser(updatedUser.toJson(), user!.id!);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print(user?.profilePhoto);
    return user != null
        ? Scaffold(
            appBar: const CustomAppBar(),
            drawer: CustomDrawer(),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RedireccionAtras(nombre: 'Mi perfil'),
                  Padding(
                    padding: const EdgeInsets.only(top: 15, bottom: 10),
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          tomarFoto();
                        },
                        child: CircleAvatar(
                          radius: 80.0,
                          backgroundColor: Colors.grey[300],
                          child: ClipOval(
                            child: SizedBox(
                              width: 160.0, // El doble del radio
                              height: 160.0, // El doble del radio
                              child: imagePersona != null
                                  ? Image.file(
                                      imagePersona!,
                                      fit: BoxFit.cover,
                                    )
                                  : (user?.profilePhoto != null
                                      ? Image.network(
                                          user!.profilePhoto!,
                                          fit: BoxFit.cover,
                                        )
                                      : const Icon(
                                          Icons.camera_alt,
                                          size: 40.0,
                                          color: Colors.white,
                                        )),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 15, left: 20),
                    child: Text('Nombres'),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: user?.firstName ?? '',
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
                    padding: EdgeInsets.only(top: 15, left: 20),
                    child: Text('Apellidos'),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: user?.lastName ?? '',
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
                    padding: EdgeInsets.only(top: 15, left: 20),
                    child: Text('Teléfono'),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: user?.telephone ?? '',
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
                    padding: EdgeInsets.only(top: 15, left: 20),
                    child: Text('Correo Electrónico'),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: user?.email ?? '',
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
                  Center(
                    child: SizedBox(
                      child: BotonCustom(
                        funcion: () async {
                          // Crear una instancia de UserLoginModel con los valores actuales del usuario
                          UserLoginModel updatedUser =
                              UserLoginModel.fromJson(user!.toJson());

                          if (imagePersona != null) {
                            String recorteUrl = imagePersona!.path;
                            List<String> segmentos = recorteUrl.split("/");
                            String ultimoSegmento = segmentos.last;

                            String imagen =
                                'https://caninar-images.s3.amazonaws.com/users/$ultimoSegmento';

                            updatedUser.profilePhoto = imagen;
                          }

                          // Actualizar solo los campos que han cambiado
                          if (nombresCtrl.text.isNotEmpty &&
                              nombresCtrl.text != user?.firstName) {
                            updatedUser.firstName = nombresCtrl.text;
                          }

                          if (apellidosCtrl.text.isNotEmpty &&
                              apellidosCtrl.text != user?.lastName) {
                            updatedUser.lastName = apellidosCtrl.text;
                          }

                          if (correoCtrl.text.isNotEmpty &&
                              correoCtrl.text != user?.email) {
                            updatedUser.email = correoCtrl.text;
                          }

                          if (telefonoCtrl.text.isNotEmpty &&
                              telefonoCtrl.text != user?.telephone) {
                            updatedUser.telephone = telefonoCtrl.text;
                          }

                          // Verificar si algún campo ha cambiado
                          if (updatedUser.firstName != user?.firstName ||
                              updatedUser.lastName != user?.lastName ||
                              updatedUser.email != user?.email ||
                              updatedUser.telephone != user?.telephone ||
                              updatedUser.profilePhoto != user?.profilePhoto) {
                            updateUser(updatedUser);
                          } else {
                            print(
                                "No se han realizado cambios en la información del usuario.");
                          }
                        },
                        texto: 'Editar Perfil',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : Login();
  }
}
