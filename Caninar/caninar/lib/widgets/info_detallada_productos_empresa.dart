import 'dart:math';

import 'package:caninar/API/APi.dart';
import 'package:caninar/constants/principals_colors.dart';
import 'package:caninar/models/certificados/model.dart';
import 'package:caninar/models/productos/model.dart';
import 'package:caninar/widgets/cards_items_home.dart';
import 'package:caninar/widgets/custom_appBar.dart';
import 'package:caninar/widgets/custom_drawer.dart';
import 'package:caninar/widgets/fecha_paseos_caninos.dart';
import 'package:caninar/widgets/redireccion_atras.dart';
import 'package:flutter/material.dart';

class InformacionDetalladaPaseos extends StatefulWidget {
  String nombre;
  String imagen;
  String id;
  int rating;
  List<CertificadosModel> certificados;
  InformacionDetalladaPaseos(
      {Key? key,
      required this.nombre,
      required this.imagen,
      required this.id,
      required this.rating,
      required this.certificados})
      : super(key: key);

  @override
  _InformacionDetalladaPaseosState createState() =>
      _InformacionDetalladaPaseosState();
}

class _InformacionDetalladaPaseosState
    extends State<InformacionDetalladaPaseos> {
  List<ProductoModel> productos = [];

  getData() async {
    List<ProductoModel> result = await API().getProductosbymarca(widget.id);

    setState(() {
      productos = result;
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: CustomDrawer(),
      body: ListView(
        children: [
          RedireccionAtras(nombre: widget.nombre),
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              double cardWidth = constraints.maxWidth;

              return GestureDetector(
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  child: Column(
                    children: [
                      Image.network(
                        widget.imagen,
                        width: 200,
                      ),
                      Container(
                          width: cardWidth,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Expanded(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                          top: 10,
                                          bottom: 8,
                                        ),
                                        child: Icon(
                                          Icons.table_chart_rounded,
                                          color: Colors.red,
                                        ),
                                      ),
                                      Text(
                                        'AK9-123',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  )),
                                  Expanded(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 15, bottom: 15),
                                        child: Text(
                                          'Horario:',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              color: PrincipalColors.orange),
                                        ),
                                      )
                                    ],
                                  )),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 15),
                                        child: Text.rich(
                                          TextSpan(
                                            children: [
                                              WidgetSpan(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    right: 5,
                                                    left: 5,
                                                    top: 15,
                                                  ),
                                                  child: Icon(
                                                    Icons.star_border,
                                                    size: 15,
                                                    color:
                                                        PrincipalColors.orange,
                                                  ),
                                                ),
                                              ),
                                              TextSpan(
                                                text: '${widget.rating}',
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 40, bottom: 20),
                                child: Column(
                                    children:
                                        widget.certificados.map((certificado) {
                                  return Text.rich(
                                    TextSpan(
                                      children: [
                                        const WidgetSpan(
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                              right: 20,
                                              left: 5,
                                              top: 5,
                                            ),
                                            child: Icon(
                                              Icons.stars_rounded,
                                              size: 25,
                                            ),
                                          ),
                                        ),
                                        TextSpan(
                                          text: certificado.name,
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                }).toList()),
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
                onTap: () {},
              );
            },
          ),
          Column(
            children: productos.map((producto) {
              return CardItemHome(
                titulo: producto.name!,
                redireccion: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FechaPaseosCaninos(
                        tituloProducto: producto.name!,
                      ),
                    ),
                  );
                },
                colorTexto: Colors.black,
                precios: 'S/${producto.price}',
                imageCard: producto.image,
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}
