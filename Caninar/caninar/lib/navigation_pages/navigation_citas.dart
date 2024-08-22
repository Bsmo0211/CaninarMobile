import 'package:caninar/models/user/model.dart';
import 'package:caninar/providers/index_provider.dart';
import 'package:caninar/shared_Preferences/shared.dart';
import 'package:caninar/widgets/compra_producto.dart';
import 'package:caninar/widgets/comunidad.dart';
import 'package:caninar/widgets/custom_appBar.dart';
import 'package:caninar/widgets/custom_drawer.dart';
import 'package:caninar/widgets/editar_perfil.dart';
import 'package:caninar/widgets/item_home.dart';
import 'package:caninar/widgets/mis_citas.dart';
import 'package:caninar/widgets/mis_mascotas.dart';
import 'package:caninar/widgets/navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavigationCitas extends StatefulWidget {
  const NavigationCitas({
    Key? key,
  }) : super(key: key);

  @override
  _NavigationCitasState createState() => _NavigationCitasState();
}

class _NavigationCitasState extends State<NavigationCitas> {
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
            ? Center(
                child: paginasNavegacion.elementAt(index),
              )
            : const Center(child: Text("Cargando")),
        bottomNavigationBar: NavbigationBarWidget(),
      ),
    );
  }
}
