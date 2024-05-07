import 'dart:async';

import 'package:caninar/API/APi.dart';
import 'package:caninar/models/carrusel/model.dart';
import 'package:caninar/models/categorias/model.dart';
import 'package:caninar/models/user/model.dart';
import 'package:caninar/navigation_pages/navigation_categoria_seleccionada.dart';
import 'package:caninar/pages/page_categoria_seleccionada.dart';
import 'package:caninar/shared_Preferences/shared.dart';
import 'package:caninar/widgets/cards_items_home.dart';
import 'package:caninar/widgets/custom_appBar.dart';
import 'package:caninar/widgets/custom_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ItemHome extends StatefulWidget {
  const ItemHome({super.key});

  @override
  State<ItemHome> createState() => _ItemHomeState();
}

class _ItemHomeState extends State<ItemHome> {
  bool isApiCallProcess = false;
  List<CategoriasModel> categorias = [];
  List<CarruselModel> imagenes = [];
  int currentIndex = 0;
  late Timer _timer;
  UserLoginModel? user;
  List<Widget> paginasNavegacion = [];
  // Declara el temporizador

  getCurrentUser() async {
    UserLoginModel? userTemp = await Shared().currentUser();

    setState(() {
      user = userTemp;
    });
  }

  getData() async {
    setState(() {
      isApiCallProcess = true;
    });
    List<CategoriasModel> result = await API().getCategorias();
    List<CarruselModel> imagenesTemp = await API().getImageCarrusel();
    imagenesTemp.sort((a, b) => a.order!.compareTo(b.order!));
    setState(() {
      categorias = result;
      imagenes = imagenesTemp;
    });
    setState(() {
      isApiCallProcess = false;
    });
  }

  @override
  void initState() {
    getCurrentUser();
    super.initState();
    getData();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        setState(() {
          if (currentIndex < imagenes.length - 1) {
            currentIndex++;
          } else {
            currentIndex = 0;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isApiCallProcess) {
      EasyLoading.show(status: 'Cargando');
    } else {
      EasyLoading.dismiss();
    }
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: const CustomAppBar(),
        drawer: CustomDrawer(),
        body: ListView(
          children: [
            const Padding(
              padding: EdgeInsets.only(
                top: 15,
                bottom: 5,
              ),
              child: Center(
                child: Text(
                  'Bienvenido',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                    image: DecorationImage(
                      image: NetworkImage(imagenes.isNotEmpty
                          ? imagenes[currentIndex].imageMobile!
                          : ''),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        offset: const Offset(0, 3),
                        blurRadius: 5.0,
                        spreadRadius: 2.0,
                      ),
                    ],
                  ),
                  height: 200.0,
                  child: AnimatedSwitcher(
                    // Opcional para animaciones
                    duration: const Duration(milliseconds: 500),
                    child: imagenes.isNotEmpty
                        ? null // Evita contenido innecesario sobre la imagen
                        : const CircularProgressIndicator(),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 15,
              ),
              child: Center(
                child: Text(
                  'Todo lo que necesitas en un solo app.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Column(
              children: categorias.map((categoria) {
                return CardItemHome(
                  terminadoCitas: false,
                  titulo: '${categoria.name}',
                  imageCard: categoria.image,
                  redireccion: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NavegacionCategoriaSeleccionada(
                          slugCategoria: categoria.slug ?? '',
                          name: categoria.name!,
                          idCategoria: categoria.id!,
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
