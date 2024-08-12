import 'package:caninar/models/certificados/model.dart';
import 'package:caninar/models/distritos/model.dart';
import 'package:caninar/models/marcas/model.dart';
import 'package:caninar/models/user/model.dart';
import 'package:caninar/providers/index_provider.dart';
import 'package:caninar/shared_Preferences/shared.dart';
import 'package:caninar/widgets/comunidad.dart';
import 'package:caninar/widgets/editar_perfil.dart';
import 'package:caninar/widgets/info_detallada_productos_empresa.dart';
import 'package:caninar/widgets/mis_citas.dart';
import 'package:caninar/widgets/mis_mascotas.dart';
import 'package:caninar/widgets/navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavegacionInformacionDetalladaProd extends StatefulWidget {
  List<CertificadosModel> certificados;
  MarcasModel marca;
  DistritosModel distrito;
  String categoria;
  String categoriaId;
  NavegacionInformacionDetalladaProd({
    Key? key,
    required this.certificados,
    required this.marca,
    required this.distrito,
    required this.categoria,
    required this.categoriaId,
  }) : super(key: key);

  @override
  _NavegacionInformacionDetalladaProdState createState() =>
      _NavegacionInformacionDetalladaProdState();
}

class _NavegacionInformacionDetalladaProdState
    extends State<NavegacionInformacionDetalladaProd> {
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
        InformacionDetalladaProductos(
          distrito: widget.distrito,
          categoria: widget.categoria,
          categoriaId: widget.categoriaId,
          marca: widget.marca,
          certificados: widget.certificados,
        ),
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
