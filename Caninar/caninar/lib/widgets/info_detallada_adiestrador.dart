import 'package:caninar/constants/principals_colors.dart';
import 'package:caninar/widgets/cards_items_home.dart';
import 'package:caninar/widgets/custom_appBar.dart';
import 'package:caninar/widgets/custom_drawer.dart';
import 'package:caninar/widgets/redireccion_atras.dart';
import 'package:flutter/material.dart';

class InformacionDetalladaAdiestrador extends StatefulWidget {
  String nombre;
  InformacionDetalladaAdiestrador({
    Key? key,
    required this.nombre,
  }) : super(key: key);

  @override
  _InformacionDetalladaAdiestradorState createState() =>
      _InformacionDetalladaAdiestradorState();
}

class _InformacionDetalladaAdiestradorState
    extends State<InformacionDetalladaAdiestrador> {
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
                  color: PrincipalColors.blue,
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/wpp.png',
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
                                              const TextSpan(
                                                text: '--',
                                                style: TextStyle(
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
                              const Padding(
                                padding: EdgeInsets.only(left: 40),
                                child: Text.rich(
                                  TextSpan(
                                    children: [
                                      WidgetSpan(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              right: 20, left: 5, top: 5),
                                          child: Icon(
                                            Icons.stars_rounded,
                                            size: 25,
                                          ),
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'Adiestrado canino',
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 40, bottom: 15),
                                child: Text.rich(
                                  TextSpan(
                                    children: [
                                      WidgetSpan(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              right: 20, left: 5, top: 10),
                                          child: Icon(
                                            Icons.stars_rounded,
                                            size: 25,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            'Especialista en comportamiento canino',
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
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
          CardItemHome(
            titulo: 'Consulta',
            redireccion: () {},
            colorTexto: Colors.black,
            precios: 'S/ 60.00',
          )
        ],
      ),
    );
  }
}
