import 'package:caninar/API/APi.dart';
import 'package:caninar/constants/principals_colors.dart';
import 'package:caninar/models/citas/model_informacion_det_cita.dart';
import 'package:caninar/models/marcas/model.dart';
import 'package:caninar/widgets/cards_items_home.dart';
import 'package:caninar/widgets/custom_appBar.dart';
import 'package:caninar/widgets/custom_drawer.dart';
import 'package:caninar/widgets/info_detallada_adiestrador.dart';
import 'package:caninar/widgets/informacion_detallada_cita.dart';
import 'package:caninar/widgets/redireccion_atras.dart';
import 'package:flutter/material.dart';

class InformacionCitas extends StatefulWidget {
  List<InformacionDetalladaCitaModel> informacionDetalle;
  String? titulo;
  InformacionCitas(
      {super.key, required this.informacionDetalle, required this.titulo});

  @override
  State<InformacionCitas> createState() => _InformacionCitasState();
}

class _InformacionCitasState extends State<InformacionCitas> {
  List<MarcasModel>? marcas;
  getInformacionById() async {
    List<MarcasModel> marcastemp = [];

    for (InformacionDetalladaCitaModel detalle in widget.informacionDetalle) {
      String id = detalle.supplierId!;
      MarcasModel? marcaTemp = await API().getSupplierById(id);

      if (marcaTemp != null) {
        marcastemp.add(marcaTemp);
      }
    }

    setState(() {
      marcas = marcastemp;
    });
  }

  @override
  void initState() {
    getInformacionById();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: CustomDrawer(),
      body: Column(
        children: [
          RedireccionAtras(nombre: widget.titulo!),
          if (marcas != null)
            Expanded(
                child: ListView(
              children: widget.informacionDetalle.asMap().entries.map((entry) {
                int index = entry.key;

                MarcasModel marca = marcas![index];
                return CardItemHome(
                  titulo: marca.name!,
                  imageCard: marca.image!,
                  redireccion: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => InformacionDetalladaCita(
                                nombreMarca: marca.name!,
                                petId: entry.value.petId!,
                              )),
                    );
                  },
                  precios:
                      '${entry.value.time?.date} \n${entry.value.time?.hour?.start}-${entry.value.time?.hour?.end}',
                  colorTexto: Colors.black,
                  icono: Icon(
                    Icons.star,
                    color: PrincipalColors.orange,
                  ),
                );
              }).toList(),
            ))
        ],
      ),
    );
  }
}
