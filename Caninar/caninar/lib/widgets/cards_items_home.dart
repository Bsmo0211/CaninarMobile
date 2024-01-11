import 'package:caninar/constants/principals_colors.dart';
import 'package:flutter/material.dart';

class CardItemHome extends StatelessWidget {
  String titulo;
  Icon? icono;
  //temporal
  String? imageCard;
  Function? redireccion;
  Color? colorTexto;
  String? precios;
  CardItemHome(
      {Key? key,
      required this.titulo,
      this.icono,
      this.imageCard,
      required this.redireccion,
      this.colorTexto,
      this.precios})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: GestureDetector(
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Column(
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: imageCard != null
                    ? Image.network(
                        imageCard!,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            return const Center(
                              child: SizedBox(
                                width: 20.0,
                                height: 20.0,
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                        },
                      )
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
                  child: ListTile(
                    leading: Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: icono ??
                          Icon(
                            Icons.pets,
                            color: PrincipalColors.blue,
                            size: 25,
                          ),
                    ),
                    title: Text(
                      titulo,
                      style: TextStyle(
                        fontSize: 18,
                        color: colorTexto ?? Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: precios != null
                        ? Text(
                            precios!,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          )
                        : null,
                  )),
            ],
          ),
        ),
        onTap: () {
          redireccion!();
        },
      ),
    );
  }
}
