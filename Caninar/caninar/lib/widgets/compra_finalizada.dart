import 'package:caninar/API/APi.dart';
import 'package:caninar/constants/principals_colors.dart';
import 'package:caninar/navigation_pages/navigation_home.dart';
import 'package:caninar/providers/cart_provider.dart';
import 'package:caninar/providers/datos_cobro_provider.dart';
import 'package:caninar/providers/id_orden_provider.dart';
import 'package:caninar/providers/orden_provider.dart';
import 'package:caninar/providers/producto_provider.dart';
import 'package:caninar/widgets/boton_custom.dart';
import 'package:caninar/widgets/custom_appBar.dart';
import 'package:caninar/widgets/custom_drawer.dart';
import 'package:caninar/widgets/login.dart';
import 'package:caninar/widgets/redireccion_atras.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class CompraFinalizada extends StatefulWidget {
  Map<String, String> queryParams;
  CompraFinalizada({super.key, required this.queryParams});

  @override
  State<CompraFinalizada> createState() => _CompraFinalizadaState();
}

class _CompraFinalizadaState extends State<CompraFinalizada> {
  Map<String, dynamic> ordenList = {};
  List<Map<String, dynamic>> productoList = [];
  Map<String, dynamic> datosCobro = {};

  int? cantidad;
  String? nameProduct;
  String? priceProduct;
  String? nombreProv;
  String? idSupplier;
  String? idItem;
  String? description;
  String? subtotal;
  String? total;
  String? serviceFee;
  String? deliveryFee;

  updateStatusOrden() async {
    IdOrdenProvider idOrdenProvider =
        Provider.of<IdOrdenProvider>(context, listen: false);

    String? idOrdenObtenido = idOrdenProvider.idOrden;

    if (idOrdenObtenido != null) {
      await API().updatePaymentStatusOrden(idOrdenObtenido);
    }
  }

  sendQueryParams() async {
    String collectionId = widget.queryParams['collection_id']?.toString() ?? '';
    String collectionStatus =
        widget.queryParams['collection_status']?.toString() ?? '';
    String paymentId = widget.queryParams['payment_id']?.toString() ?? '';
    String status = widget.queryParams['status']?.toString() ?? '';
    String externalReference =
        widget.queryParams['external_reference']?.toString() ?? '';
    String paymentType = widget.queryParams['payment_type']?.toString() ?? '';
    String merchantOrderId =
        widget.queryParams['merchant_order_id']?.toString() ?? '';
    String preferenceId = widget.queryParams['preference_id']?.toString() ?? '';
    String siteId = widget.queryParams['site_id']?.toString() ?? '';
    String processingMode =
        widget.queryParams['processing_mode']?.toString() ?? '';
    String merchantAccountId =
        widget.queryParams['merchant_account_id']?.toString() ?? '';

    Map<String, List<String>> updateParams = {
      "collection_id": [collectionId],
      "collection_status": [collectionStatus],
      "payment_id": [paymentId],
      "status": [status],
      "external_reference": [externalReference],
      "payment_type": [paymentType],
      "merchant_order_id": [merchantOrderId],
      "preference_id": [preferenceId],
      "site_id": [siteId],
      "processing_mode": [processingMode],
      "merchant_account_id": [merchantAccountId]
    };

    await API().sendParams(updateParams);
  }

  @override
  void initState() {
    super.initState();
    sendQueryParams();
    updateStatusOrden();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      limpiarCarrito();
    });
  }

  limpiarCarrito() async {
    final ProductoProvider productoProvider =
        Provider.of<ProductoProvider>(context, listen: false);
    setState(() {
      productoList = List.from(productoProvider.productoList);
    });
    productoProvider.clearProducto();
  }

  clearProviders() {
    final OrdenProvider ordenProvider =
        Provider.of<OrdenProvider>(context, listen: false);
    final ProductoProvider productoProvider =
        Provider.of<ProductoProvider>(context, listen: false);
    final CobroProvider cobroProvider =
        Provider.of<CobroProvider>(context, listen: false);
    final CartProvider carritoProvider =
        Provider.of<CartProvider>(context, listen: false);

    ordenProvider.clearOrder();
    carritoProvider.clearCart();
    cobroProvider.clearCobro();
    productoProvider.clearProducto();
  }

  @override
  Widget build(BuildContext context) {
    OrdenProvider ordenProvider = Provider.of<OrdenProvider>(context);

    CobroProvider cobroProvider = Provider.of<CobroProvider>(context);

    setState(() {
      ordenList = ordenProvider.ordenList;
      datosCobro = cobroProvider.cobro;
    });
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: const CustomAppBar(),
        drawer: CustomDrawer(),
        body: Column(
          children: [
            Expanded(
                child: ListView(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 15, left: 20),
                  child: Text(
                    'Pago exitoso',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 5, left: 20, bottom: 10),
                  child: Text(
                    'Resumen de compra',
                    style: TextStyle(fontSize: 13),
                  ),
                ),
                Column(
                  children: productoList.asMap().entries.map((entry) {
                    setState(() {
                      total = datosCobro['total'];
                      subtotal = datosCobro['subTotal'];
                      deliveryFee = datosCobro['delivery'];
                      serviceFee = datosCobro['impuesto'];
                    });

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
                            child: Text('S/ $subtotal'),
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
                            child: Text('S/ $serviceFee'),
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
                            child: Text('S/ $deliveryFee'),
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
                              'S/ $total',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                BotonCustom(
                    funcion: () async {
                      clearProviders();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Home()),
                      );
                    },
                    texto: 'Ir al inicio')
              ],
            ))
          ],
        ),
      ),
    );
  }
}
