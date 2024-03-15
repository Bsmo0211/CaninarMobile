import 'package:caninar/API/APi.dart';
import 'package:caninar/constants/principals_colors.dart';
import 'package:caninar/models/mascotas/model.dart';
import 'package:caninar/models/user/model.dart';
import 'package:caninar/shared_Preferences/shared.dart';
import 'package:caninar/widgets/boton_custom.dart';
import 'package:caninar/widgets/cards_items_home.dart';
import 'package:caninar/widgets/custom_appBar.dart';
import 'package:caninar/widgets/custom_drawer.dart';
import 'package:caninar/widgets/login.dart';
import 'package:caninar/widgets/page_registro_mascotas.dart';
import 'package:caninar/widgets/redireccion_atras.dart';
import 'package:flutter/material.dart';

class MisMascotas extends StatefulWidget {
  MisMascotas({
    super.key,
  });

  @override
  State<MisMascotas> createState() => _MisMascotasState();
}

class _MisMascotasState extends State<MisMascotas> {
  List<MascotasModel> mascotas = [];
  UserLoginModel? user;

  void refreshMascotas() async {
    await getMascotas();
  }

  getCurrentUser() async {
    UserLoginModel? userTemp = await Shared().currentUser();

    setState(() {
      user = userTemp;
    });

    await getMascotas();
  }

  getMascotas() async {
    if (user != null) {
      List<MascotasModel> mascotasTemp =
          await API().getMascotasByUser(user!.id!);

      setState(() {
        mascotas = mascotasTemp;
      });
    }
  }

  @override
  void initState() {
    getCurrentUser();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return user != null
        ? Scaffold(
            appBar: const CustomAppBar(),
            drawer: CustomDrawer(),
            body: RefreshIndicator(
                child: Column(
                  children: [
                    RedireccionAtras(nombre: 'Mis Mascotas'),
                    mascotas.isEmpty
                        ? Center(
                            child: SizedBox(
                            width: 300,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll<Color>(
                                        PrincipalColors.blue),
                              ),
                              child: const Text(
                                'Crear Nueva Mascota',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PageRegistroMascotas(
                                      registro: true,
                                      refresh: refreshMascotas,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ))
                        : Expanded(
                            child: ListView(
                            children: [
                              Column(
                                children: mascotas.map((mascota) {
                                  return CardItemHome(
                                    terminadoCitas: false,
                                    imageCard: mascota.image,
                                    titulo: mascota.name!,
                                    redireccion: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PageRegistroMascotas(
                                            mascota: mascota,
                                            refresh: refreshMascotas,
                                            registro: false,
                                          ),
                                        ),
                                      );
                                    },
                                    colorTexto: Colors.black,
                                  );
                                }).toList(),
                              ),
                              Center(
                                  child: Padding(
                                padding: EdgeInsets.only(bottom: 25),
                                child: SizedBox(
                                  width: 300,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStatePropertyAll<Color>(
                                              PrincipalColors.blue),
                                    ),
                                    child: const Text(
                                      'Crear Nueva Mascota',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PageRegistroMascotas(
                                            registro: true,
                                            refresh: refreshMascotas,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ))
                            ],
                          ))
                  ],
                ),
                onRefresh: () async {
                  getMascotas();
                }),
          )
        : Login();
  }
}
