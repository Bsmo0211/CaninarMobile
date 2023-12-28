import 'package:caninar/API/APi.dart';
import 'package:caninar/widgets/carrito.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      title: Image.asset(
        'assets/images/logo.png',
        width: 90,
      ),
      actions: [
        GestureDetector(
          child: Image.asset(
            'assets/images/wpp.png',
            width: 30,
          ),
          onTap: () {
            API().launchWhatsApp('51919285667');
          },
        ),
        Padding(
          padding: const EdgeInsets.only(
            right: 8,
          ),
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
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
