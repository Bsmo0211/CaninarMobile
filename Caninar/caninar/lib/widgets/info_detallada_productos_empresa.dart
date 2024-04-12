import 'dart:math';

import 'package:caninar/API/APi.dart';
import 'package:caninar/constants/principals_colors.dart';
import 'package:caninar/models/certificados/model.dart';
import 'package:caninar/models/distritos/model.dart';
import 'package:caninar/models/marcas/model.dart';
import 'package:caninar/models/productos/model.dart';
import 'package:caninar/models/user/model.dart';
import 'package:caninar/shared_Preferences/shared.dart';
import 'package:caninar/widgets/cards_items_home.dart';
import 'package:caninar/widgets/custom_appBar.dart';
import 'package:caninar/widgets/custom_drawer.dart';
import 'package:caninar/widgets/fecha_producto.dart';
import 'package:caninar/widgets/interfaz_marker.dart';
import 'package:caninar/widgets/login.dart';
import 'package:caninar/widgets/redireccion_atras.dart';
import 'package:flutter/material.dart';

class InformacionDetalladaProductos extends StatefulWidget {
  List<CertificadosModel> certificados;
  MarcasModel marca;
  DistritosModel distrito;
  String categoria;
  String categoriaId;
  InformacionDetalladaProductos(
      {Key? key,
      required this.certificados,
      required this.marca,
      required this.distrito,
      required this.categoria,
      required this.categoriaId})
      : super(key: key);

  @override
  _InformacionDetalladaProductosState createState() =>
      _InformacionDetalladaProductosState();
}

class _InformacionDetalladaProductosState
    extends State<InformacionDetalladaProductos> {
  List<ProductoModel> productos = [];
  UserLoginModel? user;

  getData() async {
    List<ProductoModel> result = await API().getProductosbymarca(
        widget.distrito.slug!, widget.categoria, widget.marca.slug!);

    setState(() {
      productos = result;
    });
  }

  getCurrentUser() async {
    UserLoginModel? userTemp = await Shared().currentUser();

    setState(() {
      user = userTemp;
    });
  }

  @override
  void initState() {
    getCurrentUser();
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
          RedireccionAtras(nombre: widget.marca.name!),
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
                        widget.marca.image!,
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
                                          '',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: PrincipalColors.orange,
                                          ),
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
                                                text: '${widget.marca.rating}',
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
              return Column(
                children: [
                  CardItemHome(
                    productoTipo: true,
                    typePro: producto.typePro,
                    marca: widget.marca,
                    producto: producto,
                    idCategoria: widget.categoriaId,
                    idDistrito: widget.distrito.id!,
                    terminadoCitas: false,
                    titulo: producto.name!,
                    redireccion: () {
                      if (producto.typePro == 3 || producto.typePro == null) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return InterfazMarker(
                              marca: widget.marca,
                              producto: producto,
                              idCategoria: widget.categoriaId,
                              idDistrito: widget.distrito.id!,
                            );
                          },
                        );
                      } else {
                        if (user != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FechaProductos(
                                marca: widget.marca,
                                producto: producto,
                                type: producto.typePro!,
                                idCategoria: widget.categoriaId,
                                idDistrito: widget.distrito.id!,
                              ),
                            ),
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext contextHijo) {
                              return AlertDialog(
                                title: Text('Comprar ${producto.name}'),
                                content: const Text(
                                    'Para realizar esta acción, primero debes iniciar sesión.'),
                                actions: <Widget>[
                                  TextButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                                PrincipalColors.blue)),
                                    onPressed: () {
                                      Navigator.of(contextHijo).pop();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Login(),
                                        ),
                                      ).then((isLoginSuccessful) {
                                        if (isLoginSuccessful != null &&
                                            isLoginSuccessful) {
                                          // El usuario ha iniciado sesión correctamente, actualiza el estado o reconstruye la página anterior
                                          setState(() {
                                            getCurrentUser();
                                          });
                                        }
                                      });
                                    },
                                    child: const Text(
                                      'Sí',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  TextButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                                PrincipalColors.orange)),
                                    onPressed: () {
                                      // Aquí puedes agregar la lógica para manejar la respuesta "No"
                                      Navigator.of(context)
                                          .pop(); // Cerrar el diálogo
                                    },
                                    child: const Text(
                                      'No',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      }
                    },
                    colorTexto: Colors.black,
                    precios: 'S/${producto.price}',
                    imageCard: producto.image,
                  ),
                ],
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}
