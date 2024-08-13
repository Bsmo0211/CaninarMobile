import 'package:caninar/API/APi.dart';
import 'package:caninar/constants/principals_colors.dart';
import 'package:caninar/widgets/custom_appBar.dart';
import 'package:caninar/widgets/custom_drawer.dart';
import 'package:caninar/widgets/redireccion_atras.dart';
import 'package:flutter/material.dart';

class AboutUs extends StatefulWidget {
  AboutUs({Key? key}) : super(key: key);

  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  String? contenidoAboutUs = '';
  bool isLoading = false;

  getInformacion() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> info = await API().getInfoComunidad();
    print(info);
    setState(() {
      contenidoAboutUs = info['About us'];
      isLoading = false;
    });
  }

  @override
  void initState() {
    getInformacion();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: CustomDrawer(),
      body: Column(
        children: [
          RedireccionAtras(nombre: '¿Quiénes somos?'),
          Center(
              child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 5, 15, 10),
            child: Text(
              '$contenidoAboutUs ',
              textAlign: TextAlign.justify,
            ),
          ))
        ],
      ),
    );
  }
}
