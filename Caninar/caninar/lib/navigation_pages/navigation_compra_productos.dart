import 'package:caninar/models/certificados/model.dart';
import 'package:caninar/models/distritos/model.dart';
import 'package:caninar/models/marcas/model.dart';
import 'package:caninar/models/productos/model.dart';
import 'package:caninar/models/user/model.dart';
import 'package:caninar/providers/index_provider.dart';
import 'package:caninar/shared_Preferences/shared.dart';
import 'package:caninar/widgets/compra_producto.dart';
import 'package:caninar/widgets/comunidad.dart';
import 'package:caninar/widgets/editar_perfil.dart';
import 'package:caninar/widgets/mis_citas.dart';
import 'package:caninar/widgets/mis_mascotas.dart';
import 'package:caninar/widgets/navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavegacionCompraProductos extends StatefulWidget {
  ProductoModel producto;
  MarcasModel marca;
  int type;
  String idCategoria;
  String idDistrito;
  NavegacionCompraProductos(
      {Key? key,
      required this.producto,
      required this.marca,
      required this.type,
      required this.idCategoria,
      required this.idDistrito})
      : super(key: key);

  @override
  _NavegacionCompraProductosState createState() =>
      _NavegacionCompraProductosState();
}

class _NavegacionCompraProductosState extends State<NavegacionCompraProductos> {
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
        const Comunidad(),
        MisMascotas(),
        CompraProductos(
          marca: widget.marca,
          producto: widget.producto,
          type: widget.type,
          idCategoria: widget.idCategoria,
          idDistrito: widget.idDistrito,
        ),
        const MisCitas(),
        const EditarPerfil()
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
    return Scaffold(
      body: paginasNavegacion.isNotEmpty
          ? Center(
              child: paginasNavegacion.elementAt(index),
            )
          : const Center(child: Text("Cargando")),
      bottomNavigationBar: NavbigationBarWidget(
        paginasNavegacion: paginasNavegacion,
      ),
    );
  }
}
