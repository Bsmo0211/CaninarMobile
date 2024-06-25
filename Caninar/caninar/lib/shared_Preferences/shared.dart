// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:caninar/constants/url_api.dart';
import 'package:caninar/models/user/model.dart';
import 'package:caninar/navigation_pages/navigation_home.dart';
import 'package:caninar/providers/index_provider.dart';
import 'package:caninar/providers/producto_provider.dart';
import 'package:caninar/widgets/home_adriestrador.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Shared {
  static Dio dio = Dio();
  Future<UserLoginModel?> currentUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataString = prefs.getString('user_data');

    if (userDataString != null && userDataString.isNotEmpty) {
      Map<String, dynamic> userDataMap = json.decode(userDataString);
      //print(userDataMap);
      return UserLoginModel.fromJson(userDataMap);
    } else {
      return null;
    }
  }

  Future<UserLoginModel?> login(
      String email, String pass, BuildContext context , bool? requerido) async {
    UserLoginModel? userLoginModel;
    Map<String, dynamic> login = {
      "email": email,
      "password": pass,
    };

    String jsonBody = jsonEncode(login);

    await dio
        .post(
      '${UrlApi.auth}/auth/login',
      data: jsonBody,
    )
        .then((value) async {
      if (value.statusCode == 200) {
        dynamic jsonData = json.decode(value.toString());

        UserLoginModel userLoginModelTemp =
            UserLoginModel.fromJson(jsonData['user']);

        userLoginModel = userLoginModelTemp;

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('user_data', jsonEncode(userLoginModel?.toJson()));

        Fluttertoast.showToast(
          msg: 'Bienvenido ${userLoginModel?.firstName}',
          backgroundColor: Colors.green,
        );
        if (userLoginModel?.type == 3 || userLoginModel?.type == 1) {
          Navigator.pop(context, true);
        }
         if ((userLoginModel?.type == 3 || userLoginModel?.type == 1) && requerido!) {
          print('object');
          Provider.of<IndexNavegacion>(context, listen: false).resetIndex();
         Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Home()),
          );
        }
        if (userLoginModel?.type == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomeAdiestrador()),
          );
        }
      }
    }).catchError((e) {
      Fluttertoast.showToast(
          msg: 'Correo o contraseña incorrecto',
          backgroundColor: Colors.red,
          textColor: Colors.black);
    });
    return userLoginModel;
  }

  Future<void> logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ProductoProvider productoProvider =
        Provider.of<ProductoProvider>(context, listen: false);

    productoProvider.clearProducto();

    prefs.remove('user_data');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Home()),
    );
  }
}
