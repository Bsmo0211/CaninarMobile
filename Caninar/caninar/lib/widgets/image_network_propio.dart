import 'package:flutter/material.dart';

class ImageNetworkPropio extends StatelessWidget {
  String? imagen;
  double? width;
  double? height;
  BoxFit? fit;
  ImageNetworkPropio(
      {super.key, required this.imagen, this.fit, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      '$imagen',
      width: width,
      height: height,
      fit: fit,
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
      errorBuilder:
          (BuildContext context, Object exception, StackTrace? stackTrace) {
        return Image.asset(
          'assets/images/Recurso 7.png', // Ruta de la imagen de respaldo
          width: width,
          height: height,
          fit: fit,
        );
      },
    );
  }
}
