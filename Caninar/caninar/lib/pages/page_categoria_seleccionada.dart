import 'package:caninar/API/APi.dart';
import 'package:caninar/constants/principals_colors.dart';
import 'package:caninar/models/distritos/model.dart';
import 'package:caninar/models/marcas/model.dart';
import 'package:caninar/navigation_pages/navigator_informacion_detallada_prod.dart';
import 'package:caninar/widgets/card_adiestrador.dart';
import 'package:caninar/widgets/custom_appBar.dart';
import 'package:caninar/widgets/custom_drawer.dart';
import 'package:caninar/widgets/info_detallada_adiestrador.dart';
import 'package:caninar/widgets/info_detallada_productos_empresa.dart';
import 'package:caninar/widgets/redireccion_atras.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

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
  bool isLoading = false;

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
      dropdownValueDistrito = distritos.isNotEmpty ? distritos[0].value : null;
    });
    await getMarcas(dropdownValueDistrito!.slug!);
  }

  getMarcas(String slug) async {
    if (dropdownValueDistrito != null) {
      List<MarcasModel> marcasTemp =
          await API().getMarcasByDistrito(slug, widget.slugCategoria);

      setState(() {
        marcas = marcasTemp;
      });

      print(marcas);
    }
  }

  @override
  void initState() {
    getDistritos();
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
      body: ListView(
        children: [
          RedireccionAtras(nombre: widget.name),
          Center(
            child: SizedBox(
              width: 260,
              height: 60,
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.orange, width: 1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  filled: true,
                ),
                dropdownColor: Colors.grey.shade200,
                value: dropdownValueDistrito,
                icon: const Icon(Icons.keyboard_arrow_down),
                items: distritos,
                onChanged: (DistritosModel? newValue) async {
                  setState(() {
                    dropdownValueDistrito = newValue;
                    slugDsitrito = newValue?.slug;
                    idDistrito = newValue?.id;
                    isLoading = true;
                  });

                  await Future.delayed(const Duration(seconds: 2));

                  setState(() {
                    isLoading = false;
                  });

                  await getMarcas(slugDsitrito!);
                },
              ),
            ),
          ),
          marcas.isNotEmpty
              ? Column(
                  children: marcas.map((marca) {
                  return CardAdiestradorCanino(
                    redireccion: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              NavegacionInformacionDetalladaProd(
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
              : const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      'No hay proovedores en este distrito',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                )
        ],
      ),
    );
  }
}
