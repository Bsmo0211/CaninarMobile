import 'package:caninar/API/APi.dart';
import 'package:caninar/constants/principals_colors.dart';
import 'package:caninar/models/distritos/model.dart';
import 'package:caninar/models/marcas/model.dart';
import 'package:caninar/widgets/card_adiestrador.dart';
import 'package:caninar/widgets/custom_appBar.dart';
import 'package:caninar/widgets/custom_drawer.dart';
import 'package:caninar/widgets/info_detallada_adiestrador.dart';
import 'package:caninar/widgets/info_detallada_productos_empresa.dart';
import 'package:caninar/widgets/redireccion_atras.dart';
import 'package:flutter/material.dart';

class PageCategoriaSeleccionada extends StatefulWidget {
  String slugCategoria;
  String name;
  PageCategoriaSeleccionada(
      {Key? key, required this.slugCategoria, required this.name})
      : super(key: key);

  @override
  _PageCategoriaSeleccionadaState createState() =>
      _PageCategoriaSeleccionadaState();
}

class _PageCategoriaSeleccionadaState extends State<PageCategoriaSeleccionada> {
  String? dropdownvalue;
  List<MarcasModel> marcas = [];
  List<DropdownMenuItem<String>> distritos = [];

  getDistritos() async {
    List<DropdownMenuItem<String>> temp = [];
    List<DistritosModel> distritosTemp = await API().getDistritos();

    for (DistritosModel distrito in distritosTemp) {
      temp.add(
        DropdownMenuItem(
          value: distrito.slug,
          child: Text(
            '${distrito.name}',
            style: const TextStyle(fontSize: 15),
          ),
        ),
      );
    }
    setState(() {
      distritos = temp;
    });
  }

  getMarcas() async {
    if (dropdownvalue != null) {
      List<MarcasModel> marcasTemp =
          await API().getMarcasByDistrito(dropdownvalue!, widget.slugCategoria);

      setState(() {
        marcas = marcasTemp;
      });
    }
  }

  @override
  void initState() {
    getDistritos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: CustomDrawer(),
      body: ListView(
        children: [
          RedireccionAtras(nombre: widget.name),
          Center(
            child: Container(
              padding: const EdgeInsets.only(left: 50, right: 50),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                border: Border.all(
                  color: PrincipalColors.orange,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: DropdownButton(
                isDense: true,
                dropdownColor: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(30.0),
                underline: Container(),
                value: dropdownvalue,
                icon: const Icon(Icons.keyboard_arrow_down),
                items: distritos,
                onChanged: (String? newValue) async {
                  setState(() {
                    dropdownvalue = newValue!;
                  });
                  await getMarcas();
                },
              ),
            ),
          ),
          if (marcas.isNotEmpty)
            Column(
                children: marcas.map((marca) {
              return CardAdiestradorCanino(
                redireccion: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InformacionDetalladaProductos(
                        marca: marca,
                        certificados: marca.certificates != null
                            ? marca.certificates!
                            : [],
                      ),
                    ),
                  );
                },
                codigo: 'AK9-123',
                nombre: marca.name!,
                calificacion: '${marca.rating}',
                imagen: marca.image,
              );
            }).toList())
        ],
      ),
    );
  }
}
