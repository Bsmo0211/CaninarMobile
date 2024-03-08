import 'package:caninar/constants/principals_colors.dart';
import 'package:caninar/models/coverage/model.dart';
import 'package:caninar/models/marcas/model.dart';
import 'package:caninar/models/productos/model.dart';
import 'package:caninar/models/user/model.dart';
import 'package:caninar/providers/cart_provider.dart';
import 'package:caninar/providers/direccion_provider.dart';
import 'package:caninar/providers/producto_provider.dart';
import 'package:caninar/shared_Preferences/shared.dart';
import 'package:caninar/widgets/boton_custom.dart';
import 'package:caninar/widgets/carrito.dart';
import 'package:caninar/widgets/custom_appBar.dart';
import 'package:caninar/widgets/custom_drawer.dart';
import 'package:caninar/widgets/image_network_propio.dart';
import 'package:caninar/widgets/redireccion_atras.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InterfazMarker extends StatefulWidget {
  ProductoModel producto;
  MarcasModel marca;
  String idCategoria;
  String idDistrito;
  InterfazMarker({
    super.key,
    required this.producto,
    required this.marca,
    required this.idCategoria,
    required this.idDistrito,
  });

  @override
  State<InterfazMarker> createState() => _InterfazMarkerState();
}

class _InterfazMarkerState extends State<InterfazMarker> {
  int quantity = 1;
  String? selectedAdress;
  UserLoginModel? user;
  String? selectedDistritoName;
  String? selectedInside;
  String? deliveryCost;

  getCurrentUser() async {
    UserLoginModel? userTemp = await Shared().currentUser();

    setState(() {
      user = userTemp;
    });
  }

  agregarCarrito() {
    CartProvider cartProvider =
        Provider.of<CartProvider>(context, listen: false);
    ProductoProvider ordenProvider =
        Provider.of<ProductoProvider>(context, listen: false);
    DireccionProvider direccionProvider =
        Provider.of<DireccionProvider>(context, listen: false);

    Map<String, dynamic> nuevoSupplier = {
      "coverge": widget.marca.coverage,
      "create_at": "",
      "delivery_time": widget.marca.deliveryTime,
      "bussines_name": widget.marca.bussinesName,
      "contact": widget.marca.contact,
      "status": 1,
      "slug": widget.marca.slug,
      "address": widget.marca.addresses,
      "id_user": user?.id,
      "email": [''],
      "name": widget.marca.name,
      "updated_at": 1622602830,
      "image": widget.marca.image,
      "categories": widget.marca.categories,
      "min_order_amount": widget.marca.minOrderAmount,
      "telephone": widget.marca.telephone,
      "id": widget.marca.id,
      "min_amount_free_delivery": widget.marca.minAmountFreeDelivery,
      "ruc": widget.marca.ruc,
      "items": [
        {
          "discount_type": 1,
          "status": 1,
          "slug": widget.producto.slug,
          "stock": widget.producto.stock,
          "discount_percent": "${widget.producto.discountPercent}",
          "name": widget.producto.name,
          "updated_at": 1622602830,
          "price_offer": "${widget.producto.priceOffer}",
          "image": widget.producto.image,
          "categories": widget.producto.categories,
          "id_category": widget.idCategoria,
          "units": widget.producto.units,
          "description": widget.producto.description,
          "id": widget.producto.id,
          "price": widget.producto.price,
          "id_supplier": widget.marca.id,
          "supplier": {
            "coverage": widget.marca.coverage,
            "delivery_time": widget.marca.deliveryTime,
            "bussines_name": widget.marca.bussinesName,
            "contact": widget.marca.contact,
            "status": 1,
            "slug": widget.marca.slug,
            "address": widget.marca.addresses,
            "id_user": user?.id,
            "email": [''],
            "name": widget.marca.name,
            "updated_at": 1622602830,
            "image": widget.marca.image,
            "categories": widget.marca.categories,
            "min_order_amount": widget.marca.minOrderAmount,
            "telephone": widget.marca.telephone,
            "id": widget.marca.id,
            "min_amount_free_delivery": widget.marca.minAmountFreeDelivery,
            "ruc": widget.marca.ruc
          },
          "quantity": quantity
        }
      ],
    };

    Map<String, dynamic> nuevaOrden = {
      "id": "${widget.marca.id}", // id
      "name": "${widget.marca.name}",
      "email": "${widget.marca.bussinesName}", //no esta
      "contact": "${widget.marca.contact}",
      "telephone": "${widget.marca.telephone}",
      "delivery_cost": "$deliveryCost", //no esta
      "delivery_time": "${widget.marca.deliveryTime}",
      "total": "95.45", //no esta
      "pet_name": {
        // modulo para perris crud
        "pet_id": '',
        "name": '',
      },
      "schedule": {
        "category_id": widget.idCategoria, //preguntar
        "time": {
          "date": "",
          "hour": {
            "star": '',
            "end": '',
          }
        },
        "pet_id": ''
      },
      "items": [
        {
          "id": "${widget.producto.id}",
          "name": "${widget.producto.name}",
          "units": "",
          "quantity": quantity,
          "price": "${calculateTotalValue(quantity)}"
        }
      ]
    };

    Map<String, dynamic> createAdress = {
      // enviar m
      "name": '$selectedAdress',
      "inside": '$selectedInside',
      "name_district": '$selectedDistritoName', //enviar distrito
      "id_district": "1",
      "default": "true"
    };

    direccionProvider.addDireccion(createAdress);
    cartProvider.addToCart(nuevoSupplier);
    ordenProvider.addOrden(nuevaOrden);
  }

  double calculateTotalValue(int quantity) {
    double unitPrice = double.parse(widget.producto.price!);
    return quantity * unitPrice;
  }

  void deliveryCostMap() {
    if (widget.marca.coverage != null) {
      for (CoverageModel? coverage in widget.marca.coverage!) {
        if (coverage?.idDistrict == widget.idDistrito) {
          setState(() {
            deliveryCost = coverage?.deliveryCost;
          });
          break;
        }
      }
    }
  }

  @override
  void initState() {
    deliveryCostMap();
    getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RedireccionAtras(nombre: '${widget.producto.name}'),
            ImageNetworkPropio(
              imagen: widget.producto.image,
              width: 200,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 25, bottom: 40, left: 20, right: 20),
              child: Center(
                child: Text(
                  widget.producto.description ?? '',
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Cantidad a comprar: ',
                    style: TextStyle(fontSize: 16),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.remove,
                      color: PrincipalColors.orange,
                    ),
                    onPressed: () {
                      if (quantity > 0) {
                        setState(() {
                          quantity--;
                        });
                      }
                    },
                  ),
                  Text(
                    '$quantity',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.add,
                      color: PrincipalColors.orange,
                    ),
                    onPressed: () {
                      setState(() {
                        quantity++;
                      });
                    },
                  ),
                ],
              ),
            ),
            if (user != null)
              Column(
                children: user!.addresses.map((direccion) {
                  return RadioListTile<String>(
                    title: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 5,
                          ),
                          child: Text(
                              '${direccion.name!},${direccion.idDistrict}'),
                        )
                      ],
                    ),
                    value: direccion.name!,
                    groupValue: selectedAdress,
                    onChanged: (String? value) {
                      setState(() {
                        selectedAdress = value;
                        selectedDistritoName = direccion.idDistrict;
                        selectedInside = direccion.inside;
                      });
                    },
                  );
                }).toList(),
              ),
            Padding(
              padding: EdgeInsets.only(
                top: 15,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Valor a pagar: ',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    '\$${calculateTotalValue(quantity)}',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            BotonCustom(
              funcion: () {
                agregarCarrito();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CarritoCompras(),
                  ),
                );
              },
              texto: 'Agregar al carrito',
            )
          ],
        ),
      ),
    );
  }
}
