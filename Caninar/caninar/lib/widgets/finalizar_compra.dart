import 'dart:async';

import 'package:caninar/API/APi.dart';
import 'package:caninar/API/Mercado_pago.dart';
import 'package:caninar/constants/principals_colors.dart';
import 'package:caninar/models/user/model.dart';
import 'package:caninar/providers/cart_provider.dart';
import 'package:caninar/providers/orden_provider.dart';
import 'package:caninar/providers/producto_provider.dart';
import 'package:caninar/shared_Preferences/shared.dart';
import 'package:caninar/widgets/boton_custom.dart';
import 'package:caninar/widgets/compra_finalizada.dart';
import 'package:caninar/widgets/compra_rechazada.dart';
import 'package:caninar/widgets/custom_appBar.dart';
import 'package:caninar/widgets/custom_drawer.dart';
import 'package:caninar/widgets/redireccion_atras.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:provider/provider.dart';

class FinalizarCompra extends StatefulWidget {
  double subTotal;
  double deliveriFee;
  double impuesto;
  double total;
  FinalizarCompra(
      {Key? key,
      required this.deliveriFee,
      required this.impuesto,
      required this.subTotal,
      required this.total})
      : super(key: key);

  @override
  _FinalizarCompraState createState() => _FinalizarCompraState();
}

class _FinalizarCompraState extends State<FinalizarCompra> {
  UserLoginModel? user;
  Map<String, dynamic> ordenList = {};
  List<Map<String, dynamic>> cartProvider = [];
  List<Map<String, dynamic>> productoList = [];
  StreamSubscription? _sub;
  int? cantidad;
  String? nameProduct;
  String? priceProduct;

  getCurrentUser() async {
    UserLoginModel? userTemp = await Shared().currentUser();

    setState(() {
      user = userTemp;
    });
  }

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    OrdenProvider ordenProvider = Provider.of<OrdenProvider>(context);
    CartProvider carritoProvider = Provider.of<CartProvider>(context);
    ProductoProvider productoProvider = Provider.of<ProductoProvider>(context);
    setState(() {
      ordenList = ordenProvider.ordenList;
      cartProvider = carritoProvider.cartItems;
      productoList = productoProvider.productoList;
    });

    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: CustomDrawer(),
      body: Column(
        children: [
          RedireccionAtras(nombre: 'Finalizar Compra'),
          Expanded(
              child: ListView(
            children: [
              Column(
                children: productoList.asMap().entries.map((entry) {
                  Map<String, dynamic> data = entry.value;
                  Map<String, String> address = Map<String, String>.from(
                      ordenList['address'] as Map<String, dynamic>);
                  String nombreProveedor = data['name'];
                  String? nombreDireccion = address['name'];

                  List<dynamic> items = data['items'];

                  for (var item in items) {
                    nameProduct = item['name'];

                    cantidad = item['quantity'];
                    priceProduct = item['price'];
                  }
                  return Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 35, top: 15, bottom: 5),
                              child: Text(
                                nombreProveedor,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 5, bottom: 10),
                                        child: Text(
                                          'Cant.',
                                          style: TextStyle(
                                            color: PrincipalColors.orange,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 5, bottom: 20),
                                        child: Text(
                                          '$cantidad',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 5, bottom: 10),
                                        child: Text(
                                          'Producto.',
                                          style: TextStyle(
                                            color: PrincipalColors.orange,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 5, bottom: 20),
                                        child: Text(
                                          '$nameProduct',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 5, bottom: 10),
                                        child: Text(
                                          'Precio S/',
                                          style: TextStyle(
                                            color: PrincipalColors.orange,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 5, bottom: 20),
                                        child: Text(
                                          '$priceProduct',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(
                                    left: 35,
                                    top: 5,
                                    bottom: 15,
                                  ),
                                  child: Text(
                                    'Direccion de entrega:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 35,
                                    top: 5,
                                    bottom: 15,
                                  ),
                                  child: Text(nombreDireccion!),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: PrincipalColors.orange,
                        height: 2,
                      ),
                    ],
                  );
                }).toList(),
              ),
              Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(10, 20, 40, 10),
                          child: Text('Subtotal'),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(40, 20, 40, 10),
                          child: Text('S/ ${widget.subTotal}'),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(10, 0, 40, 10),
                          child: Text('Service Fee'),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(40, 0, 40, 10),
                          child: Text('S/ ${widget.impuesto}'),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(10, 0, 40, 10),
                          child: Text('Delivery'),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(40, 0, 40, 10),
                          child: Text('S/ ${widget.deliveriFee}'),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(10, 10, 40, 10),
                          child: Text(
                            'Total',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                          child: Text(
                            'S/ ${widget.total}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              BotonCustom(
                  funcion: () async {
                    if (user != null) {
                      Map<String, dynamic> nuevoItem = {
                        "coupon": {
                          "updated_at": '',
                          "code": "",
                          "create_at": '',
                          "status": '',
                          "amount": "",
                          "expiration_date": '',
                          "id": "",
                          "id_campaign": "",
                          "id_cart": ""
                        },
                        "suppliers": cartProvider,
                        "use_company": false,
                        "status": 1,
                        "id_user": '${user?.id}',
                        "total": widget.total
                      };
                      String? idCart = await API().createCarrito(nuevoItem);
                      String? idOrden = await API().createOrden(ordenList);
                      String urlString =
                          'https://dev.caninar.com/payment/excute?user_id=${user?.id}&&cart_id=$idCart&&total=${widget.total}&&id_orden=$idOrden';

                      print(urlString);

                      Uri url = Uri.parse(urlString);
                      final controller = WebViewController()
                        ..setJavaScriptMode(JavaScriptMode.unrestricted)
                        ..loadRequest(url);

                      // ignore: use_build_context_synchronously
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            elevation: 0.0,
                            backgroundColor: Colors.transparent,
                            child: Stack(
                              children: [
                                Column(
                                  children: [
                                    SizedBox(
                                      height:
                                          600, // Tamaño específico para el WebViewWidget
                                      child: WebViewWidget(
                                        controller: controller,
                                      ),
                                    ),
                                    BotonCustom(
                                      funcion: () async {
                                        String? estadoOrden =
                                            await API().getOrdenById(idOrden!);

                                        if (estadoOrden == 'approved') {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const CompraFinalizada()),
                                          );
                                        }
                                        if (estadoOrden == 'rejected') {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const CompraRechazada()),
                                          );
                                        }
                                        // await MercadoPago().getPago();
                                      },
                                      texto: 'Continuar',
                                    ),
                                  ],
                                ),
                                Positioned(
                                    right: 5,
                                    child: IconButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        icon: Icon(
                                          Icons.close,
                                          color: PrincipalColors.orange,
                                        )))
                              ],
                            ),
                          );
                        },
                      );

                      //await MercadoPago().consultarPago(id);
                    } else {
                      Fluttertoast.showToast(
                        msg: 'Su sesión se ha expirado',
                        backgroundColor: Colors.red,
                      );
                    }
                  },
                  texto: 'Finalizar Compra')
            ],
          ))
        ],
      ),
    );
  }
}
