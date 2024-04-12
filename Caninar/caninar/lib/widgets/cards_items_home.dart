import 'package:caninar/constants/principals_colors.dart';
import 'package:caninar/models/coverage/model.dart';
import 'package:caninar/models/marcas/model.dart';
import 'package:caninar/models/productos/model.dart';
import 'package:caninar/models/user/model.dart';
import 'package:caninar/providers/cart_provider.dart';
import 'package:caninar/providers/direccion_provider.dart';
import 'package:caninar/providers/producto_provider.dart';
import 'package:caninar/widgets/boton_custom.dart';
import 'package:caninar/widgets/carrito.dart';
import 'package:caninar/widgets/image_network_propio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class CardItemHome extends StatefulWidget {
  String titulo;
  Icon? icono;
  int? typePro;
  bool? productoTipo;
  String? imageCard;
  Function? redireccion;
  Color? colorTexto;
  String? precios;
  bool? terminadoCitas;
  ProductoModel? producto;
  MarcasModel? marca;
  String? idCategoria;
  String? idDistrito;
  CardItemHome(
      {Key? key,
      required this.titulo,
      this.icono,
      this.imageCard,
      required this.redireccion,
      this.colorTexto,
      this.precios,
      required this.terminadoCitas,
      this.typePro,
      this.producto,
      this.marca,
      this.idCategoria,
      this.idDistrito,
      this.productoTipo})
      : super(key: key);

  @override
  State<CardItemHome> createState() => _CardItemHomeState();
}

class _CardItemHomeState extends State<CardItemHome> {
  int quantity = 1;
  String? selectedAdress;
  UserLoginModel? user;
  String? selectedDistritoName;
  String? selectedInside;
  String? deliveryCost;

  agregarCarrito() {
    CartProvider cartProvider =
        Provider.of<CartProvider>(context, listen: false);
    ProductoProvider productoProvider =
        Provider.of<ProductoProvider>(context, listen: false);
    DireccionProvider direccionProvider =
        Provider.of<DireccionProvider>(context, listen: false);

    Map<String, dynamic> nuevoSupplier = {
      "coverge": widget.marca?.coverage,
      "create_at": "",
      "delivery_time": widget.marca?.deliveryTime,
      "bussines_name": widget.marca?.bussinesName,
      "contact": widget.marca?.contact,
      "status": 1,
      "slug": widget.marca?.slug,
      "address": widget.marca?.addresses,
      "id_user": user?.id,
      "email": [''],
      "name": widget.marca?.name,
      "updated_at": 1622602830,
      "image": widget.marca?.image,
      "categories": widget.marca?.categories,
      "min_order_amount": widget.marca?.minOrderAmount,
      "telephone": widget.marca?.telephone,
      "id": widget.marca?.id,
      "min_amount_free_delivery": widget.marca?.minAmountFreeDelivery,
      "ruc": widget.marca?.ruc,
      "items": [
        {
          "discount_type": 1,
          "status": 1,
          "slug": widget.producto?.slug,
          "stock": widget.producto?.stock,
          "discount_percent": "${widget.producto?.discountPercent}",
          "name": widget.producto?.name,
          "updated_at": 1622602830,
          "price_offer": "${widget.producto?.priceOffer}",
          "image": widget.producto?.image,
          "categories": widget.producto?.categories,
          "id_category": widget.idCategoria,
          "units": widget.producto?.units,
          "description": widget.producto?.description,
          "id": widget.producto?.id,
          "price": widget.producto?.price,
          "id_supplier": widget.marca?.id,
          "supplier": {
            "coverage": widget.marca?.coverage,
            "delivery_time": widget.marca?.deliveryTime,
            "bussines_name": widget.marca?.bussinesName,
            "contact": widget.marca?.contact,
            "status": 1,
            "slug": widget.marca?.slug,
            "address": widget.marca?.addresses,
            "id_user": user?.id,
            "email": [''],
            "name": widget.marca?.name,
            "updated_at": 1622602830,
            "image": widget.marca?.image,
            "categories": widget.marca?.categories,
            "min_order_amount": widget.marca?.minOrderAmount,
            "telephone": widget.marca?.telephone,
            "id": widget.marca?.id,
            "min_amount_free_delivery": widget.marca?.minAmountFreeDelivery,
            "ruc": widget.marca?.ruc
          },
          "quantity": quantity
        }
      ],
    };

    Map<String, dynamic> createProducto = {
      "id": "${widget.marca?.id}", // id
      "name": "${widget.marca?.name}",
      "email": "${widget.marca?.bussinesName}", //no esta
      "contact": "${widget.marca?.contact}",
      "telephone": "${widget.marca?.telephone}",
      "delivery_cost": "$deliveryCost", //no esta
      "delivery_time": "${widget.marca?.deliveryTime}",
      "pet_name": {
        // modulo para perris crud
        "pet_id": '',
        "name": '',
      },
      "schedule": [
        {
          "name_adress": '$selectedAdress',
          "id_user": user?.id,
          "category_id": widget.idCategoria,
          "supplier_id": widget.marca?.id,
          "sh_status": 'pending',
          "time": {
            "date": '',
            "hour": {
              "star": '',
              "end": '',
            }
          },
          "pet_id": ''
        }
      ],
      "items": [
        {
          "description": widget.producto?.description,
          "id": "${widget.producto?.id}",
          "name": "${widget.producto?.name}",
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
    productoProvider.addOrden(createProducto);
  }

  double calculateTotalValue(int quantity) {
    double unitPrice = double.parse(widget.producto!.price!);
    return quantity * unitPrice;
  }

  void deliveryCostMap() {
    if (widget.marca?.coverage != null) {
      for (CoverageModel? coverage in widget.marca!.coverage!) {
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

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      child: GestureDetector(
        child: Card(
          elevation: widget.terminadoCitas! ? 8 : 4,
          shadowColor: widget.terminadoCitas! ? Colors.red : Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Column(
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: widget.imageCard != null
                    ? ImageNetworkPropio(imagen: widget.imageCard!)
                    : Image.asset(
                        'assets/images/Recurso 7.png',
                      ),
              ),
              Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Padding(
                          padding: const EdgeInsets.only(
                            left: 15,
                          ),
                          child: widget.icono ??
                              Icon(
                                Icons.pets,
                                color: PrincipalColors.blue,
                                size: 25,
                              ),
                        ),
                        title: Text(
                          widget.titulo,
                          style: TextStyle(
                            fontSize: 18,
                            color: widget.colorTexto ?? Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: widget.precios != null
                            ? Text(
                                widget.precios!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              )
                            : null,
                      ),
                      if (widget.productoTipo == true &&
                          (widget.typePro == null || widget.typePro == 3))
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: PrincipalColors.orange,
                                    border: Border.all(
                                      color: PrincipalColors.orange,
                                    ),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.remove,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      if (quantity > 1) {
                                        setState(() {
                                          quantity--;
                                        });
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  '$quantity',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 10),
                                Container(
                                  decoration: BoxDecoration(
                                    color: PrincipalColors.orange,
                                    border: Border.all(
                                      color: PrincipalColors.orange,
                                    ),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        quantity++;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      if (widget.productoTipo == true &&
                          (widget.typePro == null || widget.typePro == 3))
                        BotonCustom(
                          funcion: () async {
                            await agregarCarrito();

                            Fluttertoast.showToast(
                              msg:
                                  'Su producto ha sido agregado al carrito con éxito',
                              backgroundColor: Colors.green,
                            );
                          },
                          texto: 'Agregar al Carrito',
                        )
                    ],
                  )),
            ],
          ),
        ),
        onTap: () {
          widget.redireccion!();
        },
      ),
    );
  }
}
