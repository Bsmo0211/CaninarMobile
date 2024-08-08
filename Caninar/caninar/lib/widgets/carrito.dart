import 'package:caninar/constants/principals_colors.dart';
import 'package:caninar/models/user/model.dart';
import 'package:caninar/providers/cart_provider.dart';
import 'package:caninar/providers/direccion_provider.dart';
import 'package:caninar/providers/orden_provider.dart';
import 'package:caninar/providers/producto_provider.dart';
import 'package:caninar/shared_Preferences/shared.dart';
import 'package:caninar/widgets/boton_custom.dart';
import 'package:caninar/widgets/custom_appBar.dart';
import 'package:caninar/widgets/custom_drawer.dart';
import 'package:caninar/widgets/finalizar_compra.dart';
import 'package:caninar/widgets/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CarritoCompras extends StatefulWidget {
  CarritoCompras({Key? key}) : super(key: key);

  @override
  _CarritoComprasState createState() => _CarritoComprasState();
}

class _CarritoComprasState extends State<CarritoCompras> {
  List<Map<String, dynamic>> productoList = [];
  Map<String, dynamic> orden = {};
  Map<String, dynamic> direccion = {};
  String? nameProduct;
  String? priceProduct;

  UserLoginModel? user;
  int? cantidad;
  double totalGeneral = 0.0;
  double subtotal = 0.0;
  double deliveryCost = 0.0;

  getCurrentUser() async {
    UserLoginModel? userTemp = await Shared().currentUser();

    setState(() {
      user = userTemp;
    });
  }

  createOrden() {
    OrdenProvider ordenProvider =
        Provider.of<OrdenProvider>(context, listen: false);

    Map<String, dynamic> nuevaOrden = {
      "paymen_status": null,
      "id_user": user?.id,
      "user": {
        "addresses": user?.addresses,
        "document_number": user?.documentNumber,
        "document_type": 1,
        "company": {
          "bussines_name": "", //
          "ruc": ""
        },
        "email": user?.email,
        "first_name": user?.firstName,
        "id": user?.id,
        "id_cart": user?.idCart,
        "last_name": user?.lastName,
        "password": "",
        "satus": 1,
        "telephone": user?.telephone,
        "type": 1,
      },
      "address": direccion,
      "products": productoList,
      "reciever": {"names": "", "last_names": "", "dni": ""},
      "quantity": 2, //
      "total": '$totalGeneral',
      "id_transaction": "" //
    };

    ordenProvider.addOrden(nuevaOrden);
  }

  @override
  void initState() {
    getCurrentUser();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ProductoProvider productoProvider = Provider.of<ProductoProvider>(context);
    OrdenProvider ordenProvider = Provider.of<OrdenProvider>(context);
    DireccionProvider direccionProvider =
        Provider.of<DireccionProvider>(context);

    setState(() {
      productoList = productoProvider.productoList;
      orden = ordenProvider.ordenList;
      direccion = direccionProvider.direccion;
      calculateSubtotal();
    });

    return Scaffold(
      drawer: CustomDrawer(),
      appBar: const CustomAppBar(),
      body: Column(
        children: [
          ListTile(
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context, 'OK');
                },
                icon: Icon(
                  Icons.close,
                  color: PrincipalColors.orange,
                )),
            title: const Text(
              'Carrito',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                Column(
                  children: productoList.asMap().entries.map((entry) {
                    int index = entry.key;
                    Map<String, dynamic> data = entry.value;

                    String nombreProveedor = data['name'];

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
                                padding:
                                    const EdgeInsets.only(left: 35, top: 15),
                                child: Text(
                                  nombreProveedor,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
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
                                            top: 5,
                                            bottom: 20,
                                          ),
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
                                            top: 5,
                                            bottom: 20,
                                          ),
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
                                            top: 5,
                                            bottom: 20,
                                          ),
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
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10, bottom: 15),
                                          child: IconButton(
                                            onPressed: () {
                                              productoProvider
                                                  .removeProducto(index);
                                            },
                                            icon: Icon(
                                              Icons.delete_outlined,
                                              color: PrincipalColors.blue,
                                              size: 30,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
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
                productoList.isNotEmpty
                    ? Align(
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
                                  padding:
                                      const EdgeInsets.fromLTRB(40, 20, 40, 10),
                                  child: Text('S/ $subtotal'),
                                ),
                              ],
                            ),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(10, 0, 40, 10),
                                  child: Text('Service Fee'),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(40, 0, 40, 10),
                                  child: Text('S/ 0'),
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
                                  padding:
                                      const EdgeInsets.fromLTRB(40, 0, 40, 10),
                                  child: Text('S/ $deliveryCost'),
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
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(40, 10, 40, 10),
                                  child: Text(
                                    'S/ $totalGeneral',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    : const Center(
                        child: Text(
                          'No tienes nada agregado al carrito',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                if (productoList.isNotEmpty)
                  BotonCustom(
                    funcion: () {
                      if (user != null) {
                        createOrden();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FinalizarCompra(
                                subTotal: subtotal,
                                deliveriFee: deliveryCost,
                                impuesto: 0,
                                total: totalGeneral),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Login(
                              navegacion: true,
                            ),
                          ),
                        ).then((isLoginSuccessful) {
                          if (isLoginSuccessful != null && isLoginSuccessful) {
                            // El usuario ha iniciado sesión correctamente, actualiza el estado o reconstruye la página anterior
                            setState(() {
                              getCurrentUser();
                            });
                          }
                        });
                      }
                    },
                    texto: 'Ir a pagar',
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void calculateSubtotal() {
    subtotal = 0.0;
    deliveryCost = 0.0;

    for (var data in productoList) {
      String deliveryCostString = data['delivery_cost'];
      deliveryCostString = deliveryCostString.replaceAll(',', '.');

      deliveryCost += double.parse(deliveryCostString);

      List<dynamic> items = data['items'];
      for (var item in items) {
        String subTotalString = item['price'];
        subTotalString = subTotalString.replaceAll(',', '.');
        subtotal += double.parse(subTotalString);
      }
      totalGeneral = deliveryCost + subtotal;
    }
  }
}
