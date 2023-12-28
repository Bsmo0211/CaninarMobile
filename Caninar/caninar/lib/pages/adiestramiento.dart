import 'package:caninar/constants/principals_colors.dart';
import 'package:caninar/widgets/card_adiestrador.dart';
import 'package:caninar/widgets/custom_appBar.dart';
import 'package:caninar/widgets/custom_drawer.dart';
import 'package:caninar/widgets/info_detallada_adiestrador.dart';
import 'package:caninar/widgets/redireccion_atras.dart';
import 'package:flutter/material.dart';

class AdiestramientoPage extends StatefulWidget {
  AdiestramientoPage({Key? key}) : super(key: key);

  @override
  _AdiestramientoPageState createState() => _AdiestramientoPageState();
}

class _AdiestramientoPageState extends State<AdiestramientoPage> {
  String? dropdownvalue;

  var items = [
    'Miraflores',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: CustomDrawer(),
      body: ListView(
        children: [
          RedireccionAtras(nombre: 'Adiestramiento Canino'),
          Center(
            child: Container(
              padding: const EdgeInsets.only(left: 50, right: 50),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                border: Border.all(
                  color: PrincipalColors.orange,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: DropdownButton(
                isDense: true,
                dropdownColor: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(30.0),
                underline: Container(),
                value: dropdownvalue,
                icon: const Icon(Icons.keyboard_arrow_down),
                items: items.map((String item) {
                  return DropdownMenuItem(
                    value: item,
                    child: Text(
                      item,
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownvalue = newValue!;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
