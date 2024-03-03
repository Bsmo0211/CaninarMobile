import 'dart:convert';

import 'package:caninar/API/APi.dart';
import 'package:caninar/client/mapa.dart';
import 'package:caninar/constants/principals_colors.dart';
import 'package:caninar/models/coverage/model.dart';
import 'package:caninar/models/marcas/model.dart';
import 'package:caninar/models/mascotas/model.dart';
import 'package:caninar/models/productos/model.dart';
import 'package:caninar/models/user/model.dart';
import 'package:caninar/providers/calendario_provider.dart';
import 'package:caninar/providers/cart_provider.dart';
import 'package:caninar/providers/direccion_provider.dart';
import 'package:caninar/providers/orden_provider.dart';
import 'package:caninar/providers/producto_provider.dart';
import 'package:caninar/shared_Preferences/shared.dart';
import 'package:caninar/widgets/boton_custom.dart';
import 'package:caninar/widgets/calendario_custom.dart';
import 'package:caninar/widgets/carrito.dart';
import 'package:caninar/widgets/custom_appBar.dart';
import 'package:caninar/widgets/custom_drawer.dart';
import 'package:caninar/widgets/image_network_propio.dart';
import 'package:caninar/widgets/modal_map.dart';
import 'package:caninar/widgets/modal_registro_mascota.dart';
import 'package:caninar/widgets/redireccion_atras.dart';
import 'package:caninar/widgets/registro_mascota.dart';
import 'package:caninar/widgets/selecion_direccion.dart';
import 'package:convert/convert.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';

class FechaProductos extends StatefulWidget {
  ProductoModel producto;
  MarcasModel marca;
  int type;
  String idCategoria;
  String idDistrito;

  FechaProductos(
      {Key? key,
      required this.producto,
      required this.marca,
      required this.type,
      required this.idCategoria,
      required this.idDistrito})
      : super(key: key);

  @override
  _FechaProductosState createState() => _FechaProductosState();
}

class _FechaProductosState extends State<FechaProductos> {
  DateTime? diaSeleccionado;
  String? diaFormateado;
  LatLng? initialCenter;
  TextEditingController telefonoCtrl = TextEditingController();
  bool isApiCallProcess = false;
  List<int> hours = List.generate(23, (index) => index + 1);
  int selectedHour = 1;
  String? selectedOptionMascota;
  String? nameSelectedOptionMascota;
  String? selectedAdress;
  String? horaInicial;
  String? horaFinal;
  List<MascotasModel> mascotas = [];
  UserLoginModel? user;
  List<String> direcciones = [];
  List<int> selectedHours = [1];
  String? selectedDistritoName;
  String? selectedInside;
  int cantidad = 1;
  String? deliveryCost;

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

  agregarCarrito() async {
    if (widget.producto.typePro == 2) {
      cantidad = 2;
    }
    CartProvider cartProvider =
        Provider.of<CartProvider>(context, listen: false);
    ProductoProvider productoProvider =
        Provider.of<ProductoProvider>(context, listen: false);
    DireccionProvider direccionProvider =
        Provider.of<DireccionProvider>(context, listen: false);
    CalendarioProvider calendarioProvider =
        Provider.of<CalendarioProvider>(context, listen: false);

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
          "quantity": cantidad
        }
      ],
    };

    Map<String, dynamic> createCalendar = {
      "schedule": {
        "category_id": widget.idCategoria,
        "status": 'pending',
        "time": {
          "date": diaFormateado,
          "hour": {
            "star": horaInicial,
            "end": horaFinal,
          }
        },
        "pet_id": selectedOptionMascota
      },
    };

    Map<String, dynamic> createProducto = {
      "id": "${widget.marca.id}",
      "name": "${widget.marca.name}",
      "email": "",
      "contact": "${widget.marca.contact}",
      "telephone": "${widget.marca.telephone}",
      "delivery_cost": deliveryCost,
      "delivery_time": "${widget.marca.deliveryTime}",
      "pet_name": {
        "pet_id": selectedOptionMascota,
        "name": nameSelectedOptionMascota,
      },
      "schedule": {
        "category_id": '',
        "status": '',
        "time": {
          "date": '',
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
          "units": "Hours",
          "quantity": cantidad,
          "price": "${widget.producto.price}"
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

  void updateUserWithNewAddress(
      String address, String optionalData, String district) async {
    if (user != null) {
      user!.addAdress(address, optionalData, district);

      await API().updateUser(user!.toJson(), user!.id!);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('user_data', jsonEncode(user!.toJson()));
      setState(() {});
    }
  }

  void refreshMascotas() async {
    await getMascotas();
  }

  getMascotas() async {
    if (user != null) {
      List<MascotasModel> mascotasTemp =
          await API().getMascotasByUser(user!.id!);

      setState(() {
        mascotas = mascotasTemp;
      });
    }
  }

  getCurrentUser() async {
    UserLoginModel? userTemp = await Shared().currentUser();

    setState(() {
      user = userTemp;
    });

    await getMascotas();
  }

  @override
  void initState() {
    deliveryCostMap();
    getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isApiCallProcess) {
      EasyLoading.show(status: 'Cargando', dismissOnTap: true);
    } else {
      EasyLoading.dismiss();
    }
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: const CustomAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RedireccionAtras(nombre: widget.producto.name!),
          Expanded(
            child: ListView(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Text(
                    'Un paseo de 1 hora a cargo de un profesional certificado de APAI K9.',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 20, top: 15),
                  child: Text(
                    'Selecciona una fecha:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                CalendarioCustom(
                  type: widget.type,
                  onDiaSeleccionado: ((selectedDay) {
                    String formattedDate =
                        DateFormat('dd/MM/yyyy').format(selectedDay);
                    setState(() {
                      diaFormateado = formattedDate;
                    });
                    print(formattedDate);
                  }),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 20, top: 15, bottom: 15),
                  child: Text(
                    'Elige un horario:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Column(
                  children: [
                    for (int index = 0; index < selectedHours.length; index++)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: PrincipalColors.blueDrops,
                            ),
                            child: DropdownButton<int>(
                              padding:
                                  const EdgeInsets.only(left: 25, right: 25),
                              value: selectedHours[index],
                              items: hours.map((hour) {
                                return DropdownMenuItem<int>(
                                  value: hour,
                                  child: Text(
                                    '$hour:00 - ${hour + 1}:00',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedHours[index] = value!;
                                  int horainicialTemp = selectedHours[index];
                                  int horafinalTemp = horainicialTemp + 1;

                                  horaInicial = '$horainicialTemp:00';
                                  horaFinal = '$horafinalTemp:00';
                                });

                                print(horaInicial);
                                print(horaFinal);
                              },
                            ),
                          ),
                          if (widget.type == 2 &&
                              index == selectedHours.length - 1)
                            IconButton(
                              icon: Icon(
                                Icons.add,
                                color: PrincipalColors.blue,
                              ),
                              onPressed: () {
                                setState(() {
                                  selectedHours.add(1);
                                });
                              },
                            ),
                        ],
                      ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 20, top: 15, bottom: 5),
                  child: Text(
                    'Dirección de recojo:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
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
                Center(
                  child: GestureDetector(
                    onTap: () async {
                      /*  setState(() {
                        isApiCallProcess = true;
                      });
                      await getUbicacion();
                      setState(() {
                        isApiCallProcess = false;
                      }); */
                      showDialog(
                        context: context,
                        builder: ((BuildContext context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Align(
                                  alignment: Alignment.topRight,
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.cancel,
                                      color: PrincipalColors.blue,
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 0, 15, 10),
                                  child: SeleccionDireccion(
                                    updateDireccion: true,
                                    agregarDireccion: updateUserWithNewAddress,
                                  ),
                                )
                              ],
                            ),
                          );
                        }),
                      );
                    },
                    child: Text(
                      '+ Agregar dirección',
                      style: TextStyle(
                        color: PrincipalColors.orange,
                        fontSize: 11,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(
                    left: 20,
                    top: 15,
                    bottom: 5,
                  ),
                  child: Text(
                    'Seleccionar mascota:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Column(
                  children: mascotas.map((mascota) {
                    return RadioListTile<String>(
                      // Especifica el tipo genérico String aquí
                      title: Row(
                        children: [
                          ClipOval(
                              child: ImageNetworkPropio(
                            imagen: mascota.image!,
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                          )),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 5,
                            ),
                            child: Text('${mascota.name}'),
                          )
                        ],
                      ),
                      value: mascota.id!,
                      groupValue: selectedOptionMascota,
                      onChanged: (String? value) {
                        setState(() {
                          nameSelectedOptionMascota = mascota.name;
                          selectedOptionMascota = value;
                        });
                      },
                    );
                  }).toList(),
                ),
                Center(
                  child: GestureDetector(
                    onTap: () async {
                      showDialog(
                        context: context,
                        builder: ((BuildContext context) {
                          return ModalRegistroMascota(
                            funcionRefresh: refreshMascotas,
                          );
                        }),
                      );
                      //  await getMascotas();
                    },
                    child: Text(
                      '+ Añadir Mascota',
                      style: TextStyle(
                        color: PrincipalColors.orange,
                        fontSize: 11,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 20, top: 15, bottom: 5),
                  child: Text(
                    'Comentario:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: TextFormField(
                    maxLines: 5,
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1.5,
                          color: PrincipalColors.blueDrops,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      hintText: '¿Algo que necesitemos saber previamente?',
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 5.0,
                        horizontal: 15.0,
                      ),
                      labelStyle: const TextStyle(
                        color: Colors.black,
                      ),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 3,
                        ),
                      ),
                    ),
                    controller: telefonoCtrl,
                    validator: (telefonoCtrl) {
                      if (telefonoCtrl == null || telefonoCtrl.isEmpty) {
                        return 'El campo es obligatorio';
                      } else {}
                      return null;
                    },
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 20,
                                    bottom: 10,
                                  ),
                                  child: Text(
                                    'Cant.',
                                    style: TextStyle(
                                      color: PrincipalColors.orange,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(
                                    top: 5,
                                    bottom: 20,
                                  ),
                                  child: Text(
                                    '1',
                                    style: TextStyle(
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
                                    top: 20,
                                    bottom: 10,
                                  ),
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
                                    '${widget.producto.name}',
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
                                      top: 20, bottom: 10),
                                  child: Text(
                                    'Precio S/',
                                    style: TextStyle(
                                      color: PrincipalColors.orange,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 5, bottom: 20),
                                  child: Text(
                                    '${widget.producto.price}',
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
                    ],
                  ),
                ),
                BotonCustom(
                  funcion: () async {
                    if (selectedAdress != null &&
                        selectedOptionMascota != null) {
                      await agregarCarrito();

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CarritoCompras(),
                        ),
                      );
                    } else {
                      Fluttertoast.showToast(
                          msg: 'Debe Seleccionar todos los campos requeridos',
                          backgroundColor: Colors.red,
                          textColor: Colors.black);
                    }
                  },
                  texto: 'Agregar al carrito',
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
