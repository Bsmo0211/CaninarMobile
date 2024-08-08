import 'dart:async';

import 'package:caninar/API/APi.dart';
import 'package:caninar/constants/principals_colors.dart';
import 'package:caninar/models/carrusel/model.dart';
import 'package:caninar/models/categorias/model.dart';
import 'package:caninar/models/distritos/model.dart';
import 'package:caninar/models/user/model.dart';
import 'package:caninar/navigation_pages/navigation_categoria_seleccionada.dart';
import 'package:caninar/pages/page_categoria_seleccionada.dart';
import 'package:caninar/providers/cart_provider.dart';
import 'package:caninar/providers/direccion_provider.dart';
import 'package:caninar/providers/producto_provider.dart';
import 'package:caninar/shared_Preferences/shared.dart';
import 'package:caninar/widgets/boton_custom.dart';
import 'package:caninar/widgets/cards_items_home.dart';
import 'package:caninar/widgets/custom_appBar.dart';
import 'package:caninar/widgets/custom_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class ItemHome extends StatefulWidget {
  const ItemHome({super.key});

  @override
  State<ItemHome> createState() => _ItemHomeState();
}

class _ItemHomeState extends State<ItemHome> {
  bool isApiCallProcess = false;
  List<CategoriasModel> categorias = [];
  List<CarruselModel> imagenes = [];
  int currentIndex = 0;
  late Timer _timer;
  UserLoginModel? user;
  List<Widget> paginasNavegacion = [];
  final TextEditingController _controller = TextEditingController();
  String? searchText;
  final FocusNode _focusNode = FocusNode();
  DistritosModel? dropdownValueDistrito;
  String? selectedDistritoName;
  String? selectedInside;
  String? selectedAdress;

  String? idDistrito;
  bool isLoading = false;
  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> suppliers = [];
  List<int> quantities = [];
  List<DropdownMenuItem<DistritosModel>> distritos = [];
  String? deliveryCost;

  getCurrentUser() async {
    UserLoginModel? userTemp = await Shared().currentUser();

    setState(() {
      user = userTemp;
    });
  }

  getDistritos() async {
    List<DropdownMenuItem<DistritosModel>> temp = [];
    List<DistritosModel> distritosTemp = await API().getDistritos();

    for (DistritosModel distrito in distritosTemp) {
      temp.add(
        DropdownMenuItem(
          value: distrito,
          child: Text(
            '${distrito.name}',
            style: const TextStyle(fontSize: 15),
          ),
        ),
      );
    }

    if (!mounted) return;
    setState(() {
      distritos = temp;
    });
  }

  getProductos(String slug, String seaarch) async {
    List<Map<String, dynamic>> data = [];

    if (!mounted) return;
    setState(() {
      isLoading = true;
    });

    Map<String, dynamic> search = await API().getProductsSearch(slug, seaarch);

    if (!mounted) return;
    setState(() {
      if (search['data'] != null) {
        data = List<Map<String, dynamic>>.from(search['data']);
        for (var supplier in data) {
          if (supplier.containsKey('suppliers') &&
              supplier['suppliers'] != null) {
            suppliers = List<Map<String, dynamic>>.from(supplier['suppliers']);

            for (var supplier in suppliers) {
              if (supplier.containsKey('products') &&
                  supplier['products'] != null) {
                products =
                    List<Map<String, dynamic>>.from(supplier['products']);

                quantities = List<int>.filled(products.length, 1);
              }
            }
          }
        }
      }

      isLoading = false;
    });
  }

  getData() async {
    if (!mounted) return;
    setState(() {
      isApiCallProcess = true;
    });

    List<CategoriasModel> result = await API().getCategorias();
    List<CarruselModel> imagenesTemp = await API().getImageCarrusel();
    imagenesTemp.sort((a, b) => a.order!.compareTo(b.order!));

    if (!mounted) return;
    setState(() {
      categorias = result;
      imagenes = imagenesTemp;
      isApiCallProcess = false;
    });
  }

  void _showModal(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (contextModal) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStateModal) {
            return Dialog(
              insetPadding: const EdgeInsets.all(2),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            dropdownValueDistrito = null;
                            searchText = '';
                            _controller.clear();
                            suppliers.clear();
                            products.clear();
                          });
                          Navigator.pop(contextModal);
                        },
                        icon: const Icon(Icons.close),
                      ),
                    ),
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Seleccione el distrito donde quiere realizar la búsqueda',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 3, bottom: 20),
                      child: Center(
                        child: SizedBox(
                          width: 260,
                          height: 75,
                          child: DropdownButtonFormField<DistritosModel>(
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.orange, width: 1),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.grey, width: 1),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              filled: true,
                            ),
                            dropdownColor: Colors.grey.shade200,
                            value: dropdownValueDistrito,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            items: distritos,
                            onChanged: (DistritosModel? newValue) async {
                              setState(() {});
                              setStateModal(() {
                                dropdownValueDistrito = newValue;

                                idDistrito = dropdownValueDistrito!.id;
                              });

                              if (dropdownValueDistrito?.slug != null &&
                                  searchText != null &&
                                  searchText!.isNotEmpty) {
                                setStateModal(() {
                                  isApiCallProcess = true;
                                });
                                await getProductos(
                                    dropdownValueDistrito!.slug!, searchText!);
                                setStateModal(() {
                                  isApiCallProcess = false;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                      child: Center(
                        child: SizedBox(
                          height: 55,
                          child: TextField(
                            controller: _controller,
                            decoration: const InputDecoration(
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              labelText: '¿Qué necesitas?',
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                            ),
                            onChanged: (value) async {
                              setStateModal(() {
                                searchText = value;
                              });

                              if (dropdownValueDistrito?.slug != null &&
                                  searchText != null &&
                                  searchText!.isNotEmpty) {
                                setStateModal(() {
                                  isApiCallProcess = true;
                                });
                                await getProductos(
                                    dropdownValueDistrito!.slug!, searchText!);
                                setStateModal(() {
                                  isApiCallProcess = false;
                                });
                              }

                              if (searchText!.isEmpty) {
                                setStateModal(() {
                                  suppliers.clear();
                                  products.clear();
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    Column(
                      children: suppliers.asMap().entries.map((supplierEntry) {
                        var supplier = supplierEntry.value;
                        var index = supplierEntry.key;
                        for (Map<String, dynamic> coverage
                            in supplier['coverage']) {
                          if (coverage['id_district'] == idDistrito) {
                            setStateModal(() {
                              deliveryCost = coverage['delivery_cost'];
                            });
                          }
                        }
                        return Column(
                          children:
                              products.asMap().entries.map((productEntry) {
                            var product = productEntry.value;
                            var productIndex = productEntry.key;

                            double calculateTotalValue(int quantity) {
                              double unitPrice = double.parse(product['price']);
                              return quantity * unitPrice;
                            }

                            return Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 9,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    children: [
                                      // Center image using Align
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Image.network(
                                          product['image'],
                                          width: 70,
                                        ),
                                      ),
                                      const SizedBox(width: 16.0),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start, // Left-align text
                                          children: [
                                            Text(
                                              '${supplier['name']}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: PrincipalColors.blue,
                                              ),
                                            ),
                                            Text(
                                              '${product['name']}',
                                              style: const TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                          width:
                                              16.0), // Spacing between text and price section
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Container(
                                              color: Colors.grey.shade300,
                                              child: Text(
                                                  'S/. ${calculateTotalValue(quantities[productIndex])}'),
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: 35,
                                                  height: 35,
                                                  decoration: BoxDecoration(
                                                    color: PrincipalColors.blue,
                                                    border: Border.all(
                                                        color: PrincipalColors
                                                            .blue),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0),
                                                  ),
                                                  child: Center(
                                                    // Center IconButton within the container
                                                    child: IconButton(
                                                      icon: const Icon(
                                                          Icons.remove,
                                                          size: 14,
                                                          color: Colors.white),
                                                      onPressed: () {
                                                        if (quantities[
                                                                productIndex] >
                                                            1) {
                                                          setStateModal(() {
                                                            quantities[
                                                                productIndex]--;
                                                          });
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Text(
                                                  '${quantities[productIndex]}',
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Container(
                                                  width: 35,
                                                  height: 35,
                                                  decoration: BoxDecoration(
                                                    color: PrincipalColors.blue,
                                                    border: Border.all(
                                                        color: PrincipalColors
                                                            .blue),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0),
                                                  ),
                                                  child: Center(
                                                    // Center IconButton within the container
                                                    child: IconButton(
                                                      icon: const Icon(
                                                          Icons.add,
                                                          size: 14,
                                                          color: Colors.white),
                                                      onPressed: () {
                                                        setStateModal(() {
                                                          quantities[
                                                              productIndex]++;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            ElevatedButton.icon(
                                              onPressed: () {
                                                CartProvider cartProvider =
                                                    Provider.of<CartProvider>(
                                                        context,
                                                        listen: false);
                                                ProductoProvider
                                                    productoProvider = Provider
                                                        .of<ProductoProvider>(
                                                            context,
                                                            listen: false);
                                                DireccionProvider
                                                    direccionProvider = Provider
                                                        .of<DireccionProvider>(
                                                            context,
                                                            listen: false);

                                                Map<String, dynamic>
                                                    nuevoSupplier = supplier;

                                                Map<String, dynamic>
                                                    createProducto = {
                                                  "id":
                                                      "${supplier['id']}", // id
                                                  "name": "${supplier['name']}",
                                                  "email":
                                                      "${supplier['bussinesName']}",
                                                  "contact":
                                                      "${supplier['contact']}",
                                                  "telephone":
                                                      "${supplier['telephone']}",
                                                  "delivery_cost":
                                                      "$deliveryCost",
                                                  "delivery_time":
                                                      "${supplier['delivery_time']}",

                                                  "items": [
                                                    {
                                                      "description": product[
                                                          'description'],
                                                      "id": "${product['id']}",
                                                      "name":
                                                          "${product['name']}",
                                                      "units": "",
                                                      "quantity": quantities[
                                                          productIndex],
                                                      "price":
                                                          "${calculateTotalValue(quantities[productIndex])}"
                                                    }
                                                  ]
                                                };

                                                Map<String, dynamic>
                                                    createAdress = {
                                                  // enviar m
                                                  "name": '$selectedAdress',
                                                  "inside": '$selectedInside',
                                                  "name_district":
                                                      '$selectedDistritoName', //enviar distrito
                                                  "id_district": "1",
                                                  "default": "true"
                                                };

                                                direccionProvider
                                                    .addDireccion(createAdress);

                                                cartProvider
                                                    .addToCart(nuevoSupplier);
                                                productoProvider
                                                    .addOrden(createProducto);

                                                Fluttertoast.showToast(
                                                  msg:
                                                      'Su producto ha sido agregado al carrito con éxito',
                                                  backgroundColor: Colors.green,
                                                );
                                              },
                                              icon: const Icon(
                                                Icons.shopping_cart_outlined,
                                                size: 14,
                                              ),
                                              label: const Text(
                                                'Agregar',
                                                style: TextStyle(fontSize: 12),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0), // Set the button's rounded corners
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    getDistritos();
    getData();
    getCurrentUser();

    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _showModal(context);
        _focusNode.unfocus();
      }
    });

    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        setState(() {
          if (currentIndex < imagenes.length - 1) {
            currentIndex++;
          } else {
            currentIndex = 0;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isApiCallProcess) {
      EasyLoading.show(status: 'Cargando');
    } else {
      EasyLoading.dismiss();
    }
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: ListView(
          children: [
            const Padding(
              padding: EdgeInsets.only(
                top: 15,
                bottom: 5,
              ),
              child: Center(
                child: Text(
                  'Bienvenido',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                    image: DecorationImage(
                      image: NetworkImage(imagenes.isNotEmpty
                          ? imagenes[currentIndex].imageMobile!
                          : ''),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        offset: const Offset(0, 3),
                        blurRadius: 5.0,
                        spreadRadius: 2.0,
                      ),
                    ],
                  ),
                  height: 200.0,
                  child: AnimatedSwitcher(
                    // Opcional para animaciones
                    duration: const Duration(milliseconds: 500),
                    child: imagenes.isNotEmpty
                        ? null // Evita contenido innecesario sobre la imagen
                        : const CircularProgressIndicator(),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 15,
              ),
              child: Center(
                child: Text(
                  'Todo lo que necesitas en un solo app.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
              child: Center(
                child: SizedBox(
                  height: 55,
                  child: TextField(
                    focusNode: _focusNode,
                    decoration: const InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      labelText: '¿Qué necesitas?',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchText = value;
                      });
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Column(
              children: categorias.map((categoria) {
                return CardItemHome(
                  terminadoCitas: false,
                  titulo: '${categoria.name}',
                  imageCard: categoria.image,
                  redireccion: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NavegacionCategoriaSeleccionada(
                          slugCategoria: categoria.slug ?? '',
                          name: categoria.name!,
                          idCategoria: categoria.id!,
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
