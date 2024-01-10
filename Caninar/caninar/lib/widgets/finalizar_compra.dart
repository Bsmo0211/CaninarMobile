import 'package:caninar/constants/principals_colors.dart';
import 'package:caninar/models/user/model.dart';
import 'package:caninar/shared_Preferences/shared.dart';
import 'package:caninar/widgets/boton_custom.dart';
import 'package:caninar/widgets/custom_appBar.dart';
import 'package:caninar/widgets/custom_drawer.dart';
import 'package:caninar/widgets/redireccion_atras.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FinalizarCompra extends StatefulWidget {
  FinalizarCompra({Key? key}) : super(key: key);

  @override
  _FinalizarCompraState createState() => _FinalizarCompraState();
}

class _FinalizarCompraState extends State<FinalizarCompra> {
  UserLoginModel? user;
  getCurrentUser() async {
    UserLoginModel? userTemp = await Shared().currentUser();

    setState(() {
      user = userTemp;
    });
  }

  void _launchURL(BuildContext context) async {
    try {
      await launch(
        'https://manjaro.org/',
        customTabsOption: CustomTabsOption(
          toolbarColor: Theme.of(context).primaryColor,
          enableDefaultShare: true,
          enableUrlBarHiding: true,
          showPageTitle: true,
          extraCustomTabs: const <String>[
            'org.mozilla.firefox',
            'com.microsoft.emmx',
          ],
        ),
        safariVCOption: SafariViewControllerOption(
          preferredBarTintColor: Theme.of(context).primaryColor,
          preferredControlTintColor: Colors.white,
          barCollapsingEnabled: true,
          entersReaderIfAvailable: false,
          dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
        ),
      );
    } catch (e) {
      // An exception is thrown if browser app is not installed on Android device.
      debugPrint(e.toString());
    }
  }

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                children: [1, 2].map((e) {
                  return Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding:
                                  EdgeInsets.only(left: 35, top: 15, bottom: 5),
                              child: Text(
                                'Nombre Proovedor',
                                style: TextStyle(fontWeight: FontWeight.bold),
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
                                      const Padding(
                                        padding:
                                            EdgeInsets.only(top: 5, bottom: 20),
                                        child: Text(
                                          'data',
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
                                            top: 5, bottom: 10),
                                        child: Text(
                                          'Producto.',
                                          style: TextStyle(
                                            color: PrincipalColors.orange,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const Padding(
                                        padding:
                                            EdgeInsets.only(top: 5, bottom: 20),
                                        child: Text(
                                          'data',
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
                                            top: 5, bottom: 10),
                                        child: Text(
                                          'Precio S/',
                                          style: TextStyle(
                                            color: PrincipalColors.orange,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const Padding(
                                        padding:
                                            EdgeInsets.only(top: 5, bottom: 20),
                                        child: Text(
                                          'data',
                                          style: TextStyle(
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
                                    child: Column(
                                      children: [
                                        const Text('Direccion'),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5),
                                          child: GestureDetector(
                                            onTap: () async {},
                                            child: Text(
                                              'Cambiar dirección',
                                              style: TextStyle(
                                                color: PrincipalColors.orange,
                                                fontSize: 11,
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ))
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
              const Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 20, 40, 10),
                          child: Text('Subtotal'),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(40, 20, 40, 10),
                          child: Text('S/ precio'),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 0, 40, 10),
                          child: Text('Service Fee'),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(40, 0, 40, 10),
                          child: Text('S/ precio'),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 0, 40, 10),
                          child: Text('Delivery'),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(40, 0, 40, 10),
                          child: Text('S/ precio'),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 10, 40, 10),
                          child: Text(
                            'Total',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                          child: Text(
                            'S/ precio',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              BotonCustom(
                  funcion: () {
                    if (user != null) {
                      _launchURL(context);
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
