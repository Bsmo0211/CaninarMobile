/* import 'dart:async';

import 'package:caninar/models/carrusel/model.dart';
import 'package:flutter/material.dart';

class CarrouselPropio extends StatefulWidget {
  List<CarruselModel> images;
  CarrouselPropio({super.key, required this.images});

  @override
  State<CarrouselPropio> createState() => _CarrouselPropioState();
}

class _CarrouselPropioState extends State<CarrouselPropio> {
  PageController? _pageController;
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);

    // Iniciar el temporizador para cambiar de página automáticamente
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_currentPage < widget.images.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
        // Si es la última imagen, animar suavemente al principio
        _pageController!.animateToPage(
          0,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
      // Si no es la última imagen, cambiar a la siguiente normalmente
      _pageController!.nextPage(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer!.cancel(); // Cancelar el temporizador al desechar el widget
    _pageController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: PageView.builder(
        controller: _pageController,
        itemCount: widget.images.length,
        onPageChanged: (int index) {
          setState(() {
            _currentPage = index;
          });
        },
        itemBuilder: (BuildContext context, int index) {
          CarruselModel imagen = widget.images[index];
          return Image.network(
            imagen.imageMobile!,
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }
} */
