import 'package:caninar/API/APi.dart';
import 'package:caninar/widgets/custom_appBar.dart';
import 'package:caninar/widgets/custom_drawer.dart';
import 'package:caninar/widgets/redireccion_atras.dart';
import 'package:flutter/material.dart';

class Comunidad extends StatefulWidget {
  Comunidad({
    super.key,
  });

  @override
  State<Comunidad> createState() => _ComunidadState();
}

class _ComunidadState extends State<Comunidad> {
  List<Map<String, dynamic>> jsonData = [];

  @override
  void initState() {
    super.initState();
    getInformacion();
  }

  getInformacion() async {
    try {
      Map<String, dynamic> info = await API().getInfoComunidad();

      if (mounted) {
        setState(() {
          jsonData = List<Map<String, dynamic>>.from(info['comunity']);
        });
      }
    } catch (e) {
      print('Error al obtener la información de la comunidad: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: jsonData.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
              child: Text(jsonData[index]['title']),
            ),
            subtitle: Column(
              children: [
                for (var image in jsonData[index]['images'])
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10.0)),
                          image: DecorationImage(
                            image: NetworkImage(image['src']),
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
                          child: jsonData.isNotEmpty
                              ? null // Evita contenido innecesario sobre la imagen
                              : const CircularProgressIndicator(),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
