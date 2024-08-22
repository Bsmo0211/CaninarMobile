import 'package:caninar/API/APi.dart';

import 'package:caninar/constants/principals_colors.dart';
import 'package:caninar/models/user/model.dart';
import 'package:caninar/providers/cart_provider.dart';
import 'package:caninar/providers/producto_provider.dart';

import 'package:caninar/shared_Preferences/shared.dart';
import 'package:caninar/widgets/carrito.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  UserLoginModel? user;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ProductoProvider productoProvider = Provider.of<ProductoProvider>(context);

    return AppBar(
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
      backgroundColor: PrincipalColors.blue,
      elevation: 0,
      title: Image.asset(
        'assets/images/logo.png',
        width: 90,
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 3),
          child: GestureDetector(
            child: Image.asset(
              'assets/images/wpp.png',
              width: 30,
            ),
            onTap: () {
              API().launchWhatsApp(null);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            right: 8,
          ),
          child: Badge.count(
            count: productoProvider.productoList.length,
            backgroundColor: PrincipalColors.orange,
            child: IconButton(
              icon: const Icon(
                Icons.shopping_cart_outlined,
                size: 30,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CarritoCompras()),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
