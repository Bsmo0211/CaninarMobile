import 'dart:async';

import 'package:caninar/API/APi.dart';
import 'package:caninar/API/Mercado_pago.dart';
import 'package:caninar/constants/principals_colors.dart';
import 'package:caninar/models/user/model.dart';
import 'package:caninar/providers/calendario_provider.dart';
import 'package:caninar/providers/cart_provider.dart';
import 'package:caninar/providers/datos_cobro_provider.dart';
import 'package:caninar/providers/id_orden_provider.dart';
import 'package:caninar/providers/orden_provider.dart';
import 'package:caninar/providers/producto_provider.dart';
import 'package:caninar/shared_Preferences/shared.dart';
import 'package:caninar/widgets/boton_custom.dart';
import 'package:caninar/widgets/compra_finalizada.dart';
import 'package:caninar/widgets/compra_rechazada.dart';
import 'package:caninar/widgets/custom_appBar.dart';
import 'package:caninar/widgets/custom_drawer.dart';
import 'package:caninar/widgets/redireccion_atras.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

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
  List<Map<String, dynamic>> calendarioList = [];
  StreamSubscription? _sub;
  int? cantidad;
  String? nameProduct;
  String? priceProduct;
  String? nombreProv;
  String? idSupplier;
  String? idItem;
  String? description;

  getCurrentUser() async {
    UserLoginModel? userTemp = await Shared().currentUser();

    setState(() {
      user = userTemp;
    });
  }

  void _launchURL(BuildContext context, Uri urlMp) async {
    try {
      await launchUrl(
        urlMp,
        customTabsOptions: CustomTabsOptions(
          colorSchemes: CustomTabsColorSchemes.defaults(
            toolbarColor: PrincipalColors.blue,
          ),
          shareState: CustomTabsShareState.on,
          urlBarHidingEnabled: true,
          showTitle: true,
        ),
        safariVCOptions: SafariViewControllerOptions(
          preferredBarTintColor: PrincipalColors.blue,
          preferredControlTintColor: PrincipalColors.blue,
          barCollapsingEnabled: true,
          dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
        ),
      );
    } catch (e) {
      // An exception is thrown if browser app is not installed on Android device.
      debugPrint(e.toString());
    }
  }

  agregarCostos() {
    CobroProvider cobroProvider =
        Provider.of<CobroProvider>(context, listen: false);

    Map<String, dynamic> createDatosCobro = {
      // enviar m
      "subTotal": '${widget.subTotal}',
      "total": '${widget.total}',
      "delivery": '${widget.deliveriFee}', //enviar distrito
      'impuesto': '${widget.impuesto}'
    };

    cobroProvider.addCobro(createDatosCobro);
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
    IdOrdenProvider idOrdenProvider = Provider.of<IdOrdenProvider>(context);
    CalendarioProvider calendarioProvider =
        Provider.of<CalendarioProvider>(context);

    setState(() {
      ordenList = ordenProvider.ordenList;
      cartProvider = carritoProvider.cartItems;
      productoList = productoProvider.productoList;
      calendarioList = calendarioProvider.calendarioList;
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
                  setState(() {
                    nombreProv = nombreProveedor;
                  });
                  String? nombreDireccion = address['name'];

                  List<dynamic> items = data['items'];
                  List<dynamic> schedules = data['schedule'];

                  for (var schedule in schedules) {
                    setState(() {
                      idSupplier = schedule['supplier_id'];
                    });
                  }

                  for (var item in items) {
                    nameProduct = item['name'];

                    setState(() {
                      description = item['description'];
                      idItem = item['id'];
                    });

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
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 35,
                                      top: 5,
                                      bottom: 15,
                                    ),
                                    child: Text(nombreDireccion!),
                                  ),
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
                    String? idMp = await MercadoPago().ejecutarMercadoPago(
                        context,
                        idSupplier!,
                        user!.email!,
                        nombreProv!,
                        description!,
                        idItem!,
                        cantidad!,
                        widget.total);
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
                      await idOrdenProvider.crearOrden(ordenList);
                      String urlString =
                          'https://www.mercadopago.com.pe/checkout/v1/redirect?pref_id=$idMp';

                      Uri url = Uri.parse(urlString);

                      agregarCostos();
                      _launchURL(context, url);
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
