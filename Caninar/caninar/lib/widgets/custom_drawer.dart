import 'package:caninar/API/APi.dart';
import 'package:caninar/constants/principals_colors.dart';
import 'package:caninar/models/user/model.dart';
import 'package:caninar/shared_Preferences/shared.dart';
import 'package:caninar/widgets/about_us.dart';
import 'package:caninar/widgets/aliados.dart';
import 'package:caninar/widgets/atencion_cliente.dart';
import 'package:caninar/widgets/compra_finalizada.dart';
import 'package:caninar/widgets/compra_rechazada.dart';
import 'package:caninar/widgets/editar_perfil.dart';
import 'package:caninar/widgets/item_drawer.dart';
import 'package:caninar/widgets/libro_reclamaciones.dart';
import 'package:caninar/widgets/login.dart';
import 'package:caninar/widgets/mis_citas.dart';
import 'package:caninar/widgets/mis_mascotas.dart';
import 'package:caninar/widgets/page_registro_mascotas.dart';
import 'package:caninar/widgets/registro.dart';
import 'package:caninar/widgets/terminos_condiciones.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatefulWidget {
  CustomDrawer({Key? key}) : super(key: key);

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  UserLoginModel? user;
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
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240,
      child: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 450,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: PrincipalColors.blue,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      width: 200,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15, bottom: 5),
                      child: Text(
                        "${user?.firstName ?? ''} ${user?.lastName ?? ''}",
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  user != null
                      ? ItemDrawer(
                          titulo: 'Tu Cuenta',
                          redireccion: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const EditarPerfil()),
                            );
                          },
                        )
                      : ItemDrawer(
                          titulo: 'Iniciar Sesión',
                          redireccion: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Login(),
                              ),
                            ).then((isLoginSuccessful) {
                              if (isLoginSuccessful != null &&
                                  isLoginSuccessful) {
                                setState(() {
                                  getCurrentUser();
                                });
                              }
                            });
                          },
                        ),
                  const Divider(
                    height: 2,
                    color: Colors.grey,
                  ),
                  if (user != null && user?.type != 2)
                    ItemDrawer(
                      titulo: 'Mascotas',
                      redireccion: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MisMascotas(),
                          ),
                        );
                      },
                    ),
                  if (user != null && user?.type != 2)
                    const Divider(
                      height: 2,
                      color: Colors.grey,
                    ),
                  if (user != null && user?.type != 2)
                    ItemDrawer(
                      titulo: 'Mis Citas',
                      redireccion: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MisCitas(),
                          ),
                        );
                      },
                    ),
                  if (user != null && user?.type != 2)
                    const Divider(
                      height: 2,
                      color: Colors.grey,
                    ),
                  if (user != null && user?.type != 2)
                    ItemDrawer(
                      titulo: 'Pedidos',
                      redireccion: () {
                        /*   Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CompraRechazada(),
                          ),
                        ); */
                      },
                    ),
                  if (user != null && user?.type != 2)
                    const Divider(
                      height: 2,
                      color: Colors.grey,
                    ),
                  ItemDrawer(
                    titulo: '¿Quiénes somos?',
                    redireccion: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AboutUs()),
                      );
                    },
                  ),
                  if (user?.type != 2)
                    const Divider(
                      height: 2,
                      color: Colors.grey,
                    ),
                  if (user?.type != 2)
                    ItemDrawer(
                      titulo: 'Quiero ser un aliado',
                      redireccion: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Alidados()),
                        );
                      },
                    ),
                  const Divider(
                    height: 2,
                    color: Colors.grey,
                  ),
                  ItemDrawer(
                    titulo: 'Atención al Cliente',
                    redireccion: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AtencionCliente()),
                      );
                    },
                  ),
                  const Divider(
                    height: 2,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
            if (user != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 20, 5),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: SizedBox(
                    height: 40,
                    child: ListTile(
                      title: const Text(
                        'Cerrar sesión',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                      onTap: () async {
                        await Shared().logout(context);
                      },
                    ),
                  ),
                ),
              ),
            ItemDrawer(
                titulo: 'Términos y Condiciones',
                redireccion: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TerminosYCondiciones()),
                  );
                }),
            const Divider(
              height: 2,
              color: Colors.grey,
            ),
            ItemDrawer(
                titulo: 'Libro de reclamaciones',
                redireccion: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LibroReclamaciones()),
                  );
                }),
            const Padding(
              padding: EdgeInsets.fromLTRB(15, 5, 15, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        WidgetSpan(
                            child: Icon(
                          Icons.copyright_outlined,
                          size: 12,
                        )),
                        TextSpan(
                          text: 'Caninar 2019.',
                          style: TextStyle(fontSize: 10),
                        )
                      ],
                    ),
                  ),
                  Text(
                    'Todos los derechos reservados.',
                    style: TextStyle(fontSize: 10),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
