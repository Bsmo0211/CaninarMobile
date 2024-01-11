import 'package:caninar/widgets/registro_mascota.dart';
import 'package:flutter/material.dart';

class ModalRegistroMascota extends StatefulWidget {
  Function funcionRefresh;
  ModalRegistroMascota({super.key, required this.funcionRefresh});

  @override
  State<ModalRegistroMascota> createState() => _ModalRegistroMascotaState();
}

class _ModalRegistroMascotaState extends State<ModalRegistroMascota> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 15),
          child: RegistroMascota(
            refresh: widget.funcionRefresh,
            registro: true,
          ),
        ));
  }
}
