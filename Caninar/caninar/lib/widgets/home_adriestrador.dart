import 'package:caninar/widgets/custom_drawer.dart';
import 'package:caninar/widgets/mis_citas.dart';
import 'package:flutter/material.dart';

class HomeAdiestrador extends StatefulWidget {
  const HomeAdiestrador({super.key});

  @override
  State<HomeAdiestrador> createState() => _HomeAdiestradorState();
}

class _HomeAdiestradorState extends State<HomeAdiestrador> {
  @override
  Widget build(BuildContext context) {
    return MisCitas(
      drawer: true,
    );
  }
}
