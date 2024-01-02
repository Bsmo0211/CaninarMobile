import 'package:caninar/API/APi.dart';
import 'package:caninar/constants/principals_colors.dart';
import 'package:caninar/constants/routes.dart';
import 'package:caninar/models/carrusel/model.dart';
import 'package:caninar/models/categorias/model.dart';
import 'package:caninar/pages/adiestramiento.dart';
import 'package:caninar/pages/paseos.dart';
import 'package:caninar/widgets/cards_items_home.dart';
import 'package:caninar/widgets/custom_appBar.dart';
import 'package:caninar/widgets/custom_drawer.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isApiCallProcess = false;
  List<CategoriasModel> categorias = [];
  List<CarruselModel> imagenes = [];

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
          CarouselSlider(
            options: CarouselOptions(
              initialPage: 0,
              viewportFraction: 0.677 ,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 3),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              scrollDirection: Axis.horizontal,
            ),
            items: imagenes.map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return SizedBox(
                    child: Image.network(
                      i.imageMobile!,
                    ),
                  );
                },
              );
            }).toList(),
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
                titulo: '${categoria.name}',
                imageCard: categoria.image,
                redireccion: () {
                  if (categoria.slug!.contains('alimentos-snacks')) {
                  } else if (categoria.slug!
                      .contains('adiestramiento-canino')) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AdiestramientoPage(),
                      ),
                    );
                  } else if (categoria.slug!.contains('juguetes-acessorios')) {
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaseosPage(
                          slugCategoria: categoria.slug ?? '',
                        ),
                      ),
                    );
                  }
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
