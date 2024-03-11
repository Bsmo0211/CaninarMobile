import 'dart:async';

import 'package:caninar/API/APi.dart';
import 'package:caninar/constants/principals_colors.dart';

import 'package:caninar/models/carrusel/model.dart';
import 'package:caninar/models/categorias/model.dart';

import 'package:caninar/pages/page_categoria_seleccionada.dart';
import 'package:caninar/widgets/cards_items_home.dart';
import 'package:caninar/widgets/carrousel_propio.dart';
import 'package:caninar/widgets/custom_appBar.dart';
import 'package:caninar/widgets/custom_drawer.dart';
import 'package:caninar/widgets/image_network_propio.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isApiCallProcess = false;
  List<CategoriasModel> categorias = [];
  List<CarruselModel> imagenes = [];
  int currentIndex = 0;
  late Timer _timer; // Declara el temporizador

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
    getData();
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      setState(() {
        if (currentIndex < imagenes.length - 1) {
          currentIndex++;
        } else {
          currentIndex = 0; // Vuelve al principio de la lista
        }
      });
    });

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
      appBar: const CustomAppBar(),
      drawer: CustomDrawer(),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.only(
              top: 15,
              bottom: 15,
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
          SizedBox(
            height: 200,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: imagenes.isNotEmpty
                  ? Image.network(
                      imagenes[currentIndex].imageMobile!,
                      key: ValueKey<int>(currentIndex),
                    )
                  : const CircularProgressIndicator(),
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
                      builder: (context) => PageCategoriaSeleccionada(
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
    );
  }
}
