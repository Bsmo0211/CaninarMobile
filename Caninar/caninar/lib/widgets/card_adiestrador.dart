import 'package:caninar/constants/principals_colors.dart';
import 'package:flutter/material.dart';

class CardAdiestradorCanino extends StatefulWidget {
  Function redireccion;
  String codigo;
  String nombre;
  String? calificacion;
  String? imagen;
  CardAdiestradorCanino({
    Key? key,
    required this.redireccion,
    required this.codigo,
    required this.nombre,
    this.calificacion,
    required this.imagen,
  }) : super(key: key);

  @override
  _CardAdiestradorCaninoState createState() => _CardAdiestradorCaninoState();
}

class _CardAdiestradorCaninoState extends State<CardAdiestradorCanino> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          double cardWidth = constraints.maxWidth;

          return GestureDetector(
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Column(
                children: [
                  Image.network(
                    widget.imagen!,
                    width: 200,
                  ),
                  Container(
                      width: cardWidth,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Padding(
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
                                widget.codigo,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: 20,
                                      bottom: 8,
                                      left: 25,
                                    ),
                                    child: Icon(
                                      Icons.stars_sharp,
                                      color: Colors.red,
                                      size: 30,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: 20,
                                      bottom: 8,
                                    ),
                                    child: Icon(
                                      Icons.stars_sharp,
                                      color: Colors.black,
                                      size: 30,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 0),
                                child: Center(
                                  child: Text(
                                    widget.nombre,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 15, bottom: 15),
                                child: Text(
                                  'Horario',
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
                                padding: const EdgeInsets.only(right: 15),
                                child: Text.rich(
                                  TextSpan(
                                    children: [
                                      WidgetSpan(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              right: 5, left: 5, top: 15),
                                          child: Icon(
                                            Icons.star_border,
                                            size: 15,
                                            color: PrincipalColors.orange,
                                          ),
                                        ),
                                      ),
                                      TextSpan(
                                        text: widget.calificacion ?? '--',
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
                      )),
                ],
              ),
            ),
            onTap: () {
              widget.redireccion();
            },
          );
        },
      ),
    );
  }
}
