import 'package:caninar/API/APi.dart';
import 'package:caninar/widgets/custom_appBar.dart';
import 'package:caninar/widgets/custom_drawer.dart';
import 'package:caninar/widgets/redireccion_atras.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class TerminosYCondiciones extends StatefulWidget {
  bool cliente;
  TerminosYCondiciones({Key? key, required this.cliente}) : super(key: key);

  @override
  _TerminosYCondicionesState createState() => _TerminosYCondicionesState();
}

class _TerminosYCondicionesState extends State<TerminosYCondiciones> {
  Map<String, dynamic> clientes = {};
  String? contenidoCliente = '';
  Map<String, dynamic> proovedores = {};
  String? contenidoProovedor = '';
  bool isLoading = false;

  getInformacion() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> info = await API().getInfoComunidad();
    setState(() {
      clientes = Map<String, dynamic>.from(info['tyc']['clients']);
      proovedores = Map<String, dynamic>.from(info['tyc']['suppliers']);
      contenidoCliente = clientes['content'];
      contenidoProovedor = proovedores['content'];
      isLoading = false;
    });
  }

  @override
  void initState() {
    getInformacion();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      EasyLoading.show(status: 'Cargando');
    } else {
      EasyLoading.dismiss();
    }
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: CustomDrawer(),
      body: Column(
        children: [
          RedireccionAtras(nombre: 'Términos y Condiciones'),
          Center(
              child: Text(
            widget.cliente ? '$contenidoCliente' : '$contenidoProovedor',
            textAlign: TextAlign.justify,
          ))
        ],
      ),
    );
  }
}
