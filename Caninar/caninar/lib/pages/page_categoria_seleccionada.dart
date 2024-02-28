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
  String idCategoria;
  PageCategoriaSeleccionada(
      {Key? key,
      required this.slugCategoria,
      required this.name,
      required this.idCategoria})
      : super(key: key);

  @override
  _PageCategoriaSeleccionadaState createState() =>
      _PageCategoriaSeleccionadaState();
}

class _PageCategoriaSeleccionadaState extends State<PageCategoriaSeleccionada> {
  DistritosModel? dropdownValueDistrito;
  String? slugDsitrito;
  String? idDistrito;
  List<MarcasModel> marcas = [];
  List<DropdownMenuItem<DistritosModel>> distritos = [];

  getDistritos() async {
    List<DropdownMenuItem<DistritosModel>> temp = [];
    List<DistritosModel> distritosTemp = await API().getDistritos();

    for (DistritosModel distrito in distritosTemp) {
      temp.add(
        DropdownMenuItem(
          value: distrito,
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
    if (dropdownValueDistrito != null) {
      List<MarcasModel> marcasTemp =
          await API().getMarcasByDistrito(slugDsitrito!, widget.slugCategoria);

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
              child: DropdownButton<DistritosModel>(
                isDense: true,
                dropdownColor: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(30.0),
                underline: Container(),
                value: dropdownValueDistrito,
                icon: const Icon(Icons.keyboard_arrow_down),
                items: distritos,
                onChanged: (DistritosModel? newValue) async {
                  setState(() {
                    dropdownValueDistrito = newValue;
                    slugDsitrito = newValue?.slug;
                    idDistrito = newValue?.id;
                  });
                  print(idDistrito);
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
                        distrito: dropdownValueDistrito!,
                        categoria: widget.slugCategoria,
                        categoriaId: widget.idCategoria,
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
