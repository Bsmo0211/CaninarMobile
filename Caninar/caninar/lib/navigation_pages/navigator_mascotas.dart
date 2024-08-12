import 'package:caninar/models/user/model.dart';
import 'package:caninar/providers/index_provider.dart';
import 'package:caninar/shared_Preferences/shared.dart';
import 'package:caninar/widgets/compra_producto.dart';
import 'package:caninar/widgets/comunidad.dart';
import 'package:caninar/widgets/editar_perfil.dart';
import 'package:caninar/widgets/item_home.dart';
import 'package:caninar/widgets/mis_citas.dart';
import 'package:caninar/widgets/mis_mascotas.dart';
import 'package:caninar/widgets/navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavegacionMascota extends StatefulWidget {
  const NavegacionMascota({
    Key? key,
  }) : super(key: key);

  @override
  _NavegacionMascotaState createState() => _NavegacionMascotaState();
}

class _NavegacionMascotaState extends State<NavegacionMascota> {
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
        Comunidad(
          drawer: true,
        ),
        MisMascotas(
          drawer: true,
        ),
        const ItemHome(),
        MisCitas(
          drawer: true,
        ),
        EditarPerfil(
          drawer: true,
        )
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
        body: paginasNavegacion.isNotEmpty
            ? Center(
                child: paginasNavegacion.elementAt(index),
              )
            : const Center(child: Text("Cargando")),
        bottomNavigationBar: NavbigationBarWidget(
          paginasNavegacion: paginasNavegacion,
        ),
      ),
    );
  }
}
