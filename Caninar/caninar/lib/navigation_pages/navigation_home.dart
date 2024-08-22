import 'dart:async';

import 'package:caninar/API/APi.dart';
import 'package:caninar/constants/principals_colors.dart';

import 'package:caninar/models/carrusel/model.dart';
import 'package:caninar/models/categorias/model.dart';
import 'package:caninar/models/user/model.dart';

import 'package:caninar/pages/page_categoria_seleccionada.dart';
import 'package:caninar/providers/index_provider.dart';
import 'package:caninar/shared_Preferences/shared.dart';
import 'package:caninar/widgets/cards_items_home.dart';
import 'package:caninar/widgets/carrousel_propio.dart';
import 'package:caninar/widgets/comunidad.dart';
import 'package:caninar/widgets/custom_appBar.dart';
import 'package:caninar/widgets/custom_drawer.dart';
import 'package:caninar/widgets/editar_perfil.dart';
import 'package:caninar/widgets/image_network_propio.dart';
import 'package:caninar/widgets/item_home.dart';
import 'package:caninar/widgets/login.dart';
import 'package:caninar/widgets/mis_citas.dart';
import 'package:caninar/widgets/mis_mascotas.dart';
import 'package:caninar/widgets/navigation_bar.dart';
import 'package:caninar/widgets/terminos_condiciones.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  UserLoginModel? user;
  List<Widget> paginasNavegacion = [];

  getCurrentUser() async {
    UserLoginModel? userTemp = await Shared().currentUser();

    setState(() {
      user = userTemp;
    });
  }

  insertPaginas() {
    setState(() {
      paginasNavegacion = [
        Comunidad(),
        MisMascotas(),
        const ItemHome(),
        MisCitas(),
        EditarPerfil()
      ];
    });
  }

  @override
  void initState() {
    getCurrentUser();
    insertPaginas();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int index = Provider.of<IndexNavegacion>(context).Index;
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: CustomAppBar(),
        drawer: CustomDrawer(),
        body: paginasNavegacion.isNotEmpty
            ? paginasNavegacion.elementAt(index)
            : const Center(child: Text("Cargando")),
        bottomNavigationBar: NavbigationBarWidget(),
      ),
    );
  }
}
