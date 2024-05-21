import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:caninar/constants/principals_colors.dart';
import 'package:caninar/models/user/model.dart';
import 'package:caninar/navigation_pages/navigation_home.dart';
import 'package:caninar/providers/index_provider.dart';
import 'package:caninar/shared_Preferences/shared.dart';
import 'package:caninar/widgets/editar_perfil.dart';
import 'package:caninar/widgets/item_home.dart';
import 'package:caninar/widgets/mis_mascotas.dart';
import 'package:caninar/widgets/terminos_condiciones.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavbigationBarWidget extends StatefulWidget {
  List<Widget> paginasNavegacion;

  NavbigationBarWidget({
    super.key,
    required this.paginasNavegacion,
  });

  @override
  State<NavbigationBarWidget> createState() => _NavbigationBarWidgetState();
}

class _NavbigationBarWidgetState extends State<NavbigationBarWidget> {
  UserLoginModel? user;
  List<BottomBarItem> items = [];
  // Declara el temporizador

  getCurrentUser() async {
    UserLoginModel? userTemp = await Shared().currentUser();

    setState(() {
      user = userTemp;
    });
  }

  @override
  void initState() {
    updateItems();
    getCurrentUser();
    super.initState();
  }

  updateItems() {
    List<BottomBarItem> itemsTemp = [
      BottomBarItem(
        itemLabel: 'Noticias',
        inActiveItem: Icon(
          Icons.people_alt_rounded,
          color: PrincipalColors.blue,
        ),
        activeItem: Icon(
          Icons.people_alt_rounded,
          color: PrincipalColors.blue,
        ),
      ),
      BottomBarItem(
        itemLabel: 'Mascotas',
        inActiveItem: Icon(
          Icons.pets,
          color: PrincipalColors.blue,
        ),
        activeItem: Icon(
          Icons.pets,
          color: PrincipalColors.blue,
        ),
      ),
      BottomBarItem(
        itemLabel: 'Inicio',
        inActiveItem: Icon(
          Icons.home,
          color: PrincipalColors.blue,
        ),
        activeItem: Icon(
          Icons.home,
          color: PrincipalColors.blue,
        ),
      ),
      BottomBarItem(
        itemLabel: 'Citas',
        inActiveItem: Icon(
          Icons.edit_calendar_rounded,
          color: PrincipalColors.blue,
        ),
        activeItem: Icon(
          Icons.edit_calendar_rounded,
          color: PrincipalColors.blue,
        ),
      ),
      BottomBarItem(
        itemLabel: 'Perfil',
        inActiveItem: Icon(
          Icons.person,
          color: PrincipalColors.blue,
        ),
        activeItem: Icon(
          Icons.person,
          color: PrincipalColors.blue,
        ),
      ),
    ];

    setState(() {
      items = itemsTemp;
    });
  }

  @override
  Widget build(BuildContext context) {
    IndexNavegacion indexProv = Provider.of<IndexNavegacion>(context);
    final controller = NotchBottomBarController(
      index: indexProv.Index,
    );

    return AnimatedNotchBottomBar(
      kBottomRadius: 15.0,
      kIconSize: 20.0,
      notchBottomBarController: controller,
      bottomBarItems: items,
      onTap: (value) {
        indexProv.Index = value;

        if (value == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Home()),
          );
        }
      },
      color: Colors.grey.shade100,
    );
  }
}
