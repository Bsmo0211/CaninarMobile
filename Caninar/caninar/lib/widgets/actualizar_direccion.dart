import 'dart:convert';

import 'package:caninar/API/APi.dart';
import 'package:caninar/constants/principals_colors.dart';
import 'package:caninar/models/user/model.dart';
import 'package:caninar/widgets/boton_custom.dart';
import 'package:caninar/widgets/custom_appBar.dart';
import 'package:caninar/widgets/custom_drawer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class ActualizarDireccion extends StatefulWidget {
  UserLoginModel user;
  Function refresh;
  ActualizarDireccion({super.key, required this.user, required this.refresh});

  @override
  State<ActualizarDireccion> createState() => _ActualizarDireccionState();
}

class _ActualizarDireccionState extends State<ActualizarDireccion> {
  List<dynamic> _placeList = [];
  Map<String, dynamic> selectedPlaces = {};
  Uuid uuid = const Uuid();
  String? _sessionToken;
  String? direccionNombreFinal;
  TextEditingController direccionCtrl = TextEditingController();

  void addToSelectedPlaces(String placeDescription) {
    setState(() {
      selectedPlaces = {'name': placeDescription};
    });
  }

  void updateUserWithNewAddress(
      String address, String optionalData, String district) async {
    if (widget.user != null) {
      widget.user.addAdress(address, optionalData, district);

      await API().updateUser(widget.user!.toJson(), widget.user!.id!);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('user_data', jsonEncode(widget.user.toJson()));
      widget.refresh();
      Navigator.pop(
        context,
      );
    }
  }

  void getSuggestion(String input) async {
    Dio dio = Dio();

    String kplacesApiKey = "AIzaSyCmDOgFduDJlMZhE7zFNV_0ATbxT170xjU";
    String type = '(regions)';
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseURL?input=$input&key=$kplacesApiKey&sessiontoken=$_sessionToken';
    Response response = await dio.get(request);
    if (response.statusCode == 200) {
      print(response.data);
      setState(() {
        _placeList = response.data['predictions'];
      });
    } else {
      throw Exception('Failed to load predictions');
    }
  }

  _onChanged() {
    if (_sessionToken == null) {
      setState(() {
        _sessionToken = uuid.v4();
      });
    }
    getSuggestion(direccionCtrl.text);
  }

  @override
  void initState() {
    direccionCtrl.addListener(() {
      _onChanged();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Text(
              textAlign: TextAlign.center,
              'En este espacio podrás ingresar una nueva direccion',
              style: TextStyle(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Text(
              'Datos sobre direccion',
              style: TextStyle(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
          ),
          TextField(
            controller: direccionCtrl,
            autocorrect: false,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.never,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1.5,
                  color: PrincipalColors.blue,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1.5,
                  color: PrincipalColors.blue,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 5.0,
                horizontal: 15.0,
              ),
              labelStyle: const TextStyle(
                color: Colors.black,
              ),
              border: const OutlineInputBorder(
                borderSide: BorderSide(
                  width: 3,
                ),
              ),
              suffixIcon: const Icon(Icons.search),
            ),
          ),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _placeList.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_placeList[index]["description"]),
                onTap: () {
                  String selectedPlaceDescription =
                      _placeList[index]["description"];
                  addToSelectedPlaces(selectedPlaceDescription);

                  setState(() {
                    direccionCtrl.clear();
                  });
                },
              );
            },
          ),
          if (selectedPlaces.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                'Direcciones seleccionadas',
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
            ),
          if (selectedPlaces.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 5, left: 5),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      selectedPlaces['name'],
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        selectedPlaces.clear();
                      });
                    },
                  ),
                ],
              ),
            ),
          BotonCustom(
              funcion: () async {
                updateUserWithNewAddress(selectedPlaces['name']!, '', '');
              },
              texto: 'Agregar Nueva dirección')
        ],
      ),
    );
  }
}
