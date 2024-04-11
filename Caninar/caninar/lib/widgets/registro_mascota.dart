import 'dart:convert';
import 'dart:io';

import 'package:aws_s3_upload/enum/acl.dart';
import 'package:caninar/constants/access_keys.dart';
import 'package:caninar/constants/principals_colors.dart';
import 'package:caninar/constants/url_api.dart';
import 'package:caninar/models/mascotas/model.dart';
import 'package:caninar/models/user/model.dart';
import 'package:caninar/pages/home.dart';
import 'package:caninar/shared_Preferences/shared.dart';
import 'package:caninar/widgets/mis_mascotas.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:snippet_coder_utils/multi_images_utils.dart';

import 'package:image_picker/image_picker.dart';
import 'package:aws_s3_upload/aws_s3_upload.dart';

class RegistroMascota extends StatefulWidget {
  Function refresh;
  bool registro;
  MascotasModel? mascota;
  RegistroMascota({
    super.key,
    required this.registro,
    required this.refresh,
    this.mascota,
  });

  @override
  State<RegistroMascota> createState() => _RegistroMascotaState();
}

class _RegistroMascotaState extends State<RegistroMascota> {
  TextEditingController nombresCtrl = TextEditingController();
  TextEditingController razaCtrl = TextEditingController();
  final formKey1 = GlobalKey<FormState>();
  UserLoginModel? user;
  File? imageMascota;
  bool esterilizado = false;
  String? dropdownValueSexo;
  final ImagePicker _picker = ImagePicker();
  Map<String, String> dropdownSexoMap = {
    'Macho': 'Macho',
    'Hembra': 'Hembra',
  };
  String? dropdownValueTamano;
  Map<String, String> dropdownTamanoMap = {
    'Pequeño (1kg - 8Kg)': 'Pequeño',
    'Mediano (9kg - 15Kg)': 'Mediano',
  };
  bool isLoading = false;

  submit() async {
    String recorteUrl = imageMascota!.path;
    List<String> segmentos = recorteUrl.split("/");
    String ultimoSegmento = segmentos.last;

    String imagen =
        'https://caninar-images.s3.amazonaws.com/pets/$ultimoSegmento';

    Dio dio = Dio();
    Map<String, dynamic> createPet = {
      "user_id": '${user?.id}',
      "name": nombresCtrl.text,
      "gender": dropdownValueSexo,
      "sterilized": esterilizado,
      "pet_size": dropdownValueTamano,
      "race": razaCtrl.text,
      "image": imagen,
    };

    String jsonBody = jsonEncode(createPet);

    await dio
        .post(
      '${UrlApi.pets}/pet',
      data: jsonBody,
    )
        .then((value) async {
      if (value.statusCode == 200) {
        Fluttertoast.showToast(
          msg: 'Mascota registrado con exito',
          backgroundColor: Colors.green,
        );

        widget.refresh();

        Navigator.pop(
          context,
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

  tomarFoto() async {
    final picker = ImagePicker();

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
      XFile? photo = await picker.pickImage(source: source);

      if (photo != null) {
        File photofile = File(photo.path);

        setState(() {
          imageMascota = photofile;
        });

        AwsS3.uploadFile(
          accessKey: Keys.awsAccessKey,
          secretKey: Keys.awsSecretKey,
          file: File(imageMascota!.path),
          bucket: "caninar-images",
          region: "us-east-1",
          destDir: "pets",
        );
      }
    }
  }

  getCurrentUser() async {
    UserLoginModel? userTemp = await Shared().currentUser();

    setState(() {
      user = userTemp;
    });
  }

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      EasyLoading.show(status: 'Cargando');
    } else {
      EasyLoading.dismiss();
    }
    return Center(
      child: Form(
          key: formKey1,
          child: ListView(
            children: [
              Center(
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
                        child: imageMascota != null
                            ? Image.file(
                                imageMascota!,
                                fit: BoxFit.cover,
                              )
                            : widget.mascota?.image != null
                                ? Image.network(
                                    widget.mascota!.image!,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      } else {
                                        return const Center(
                                          child: SizedBox(
                                            width: 20.0,
                                            height: 20.0,
                                            child: CircularProgressIndicator(),
                                          ),
                                        );
                                      }
                                    },
                                  )
                                : const Icon(
                                    Icons.camera_alt,
                                    size: 40.0,
                                    color: Colors.white,
                                  ),
                      ),
                    ),
                  ),
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
                    labelText: widget.mascota?.name,
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
                    labelText: widget.mascota?.gender,
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
                    labelText: widget.mascota?.petSize,
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
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 15),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: widget.mascota?.race,
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
              if (widget.registro == true)
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
                        child: const Text(
                          'Crear Mascota',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () async {
                          if (user != null) {
                            setState(() {
                              isLoading = true;
                            });
                            await submit();
                            setState(() {
                              isLoading = false;
                            });
                          }
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
