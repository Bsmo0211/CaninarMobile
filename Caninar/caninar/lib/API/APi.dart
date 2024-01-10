import 'dart:convert';

import 'package:caninar/models/carrusel/model.dart';
import 'package:caninar/models/categorias/model.dart';
import 'package:caninar/models/certificados/model.dart';
import 'package:caninar/models/distritos/model.dart';
import 'package:caninar/models/marcas/model.dart';
import 'package:caninar/models/productos/model.dart';
import 'package:caninar/models/user/model.dart';
import 'package:caninar/widgets/finalizar_compra.dart';
import 'package:caninar/widgets/login.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

class API {
  static Dio dio = Dio();
  static UserLoginModel? userLoginModelFinal;

  Future<void> launchWhatsApp(String phoneNumber, {String message = ""}) async {
    try {
      String whatsappUrl = getWhatsAppUrl(phoneNumber, message);
      await launchUrl(Uri.parse(whatsappUrl));
    } catch (e) {
      print('Error al abrir el enlace de WhatsApp: $e');
    }
  }

  String getWhatsAppUrl(String phoneNumber, String message) {
    String url =
        'https://wa.me/$phoneNumber/?text=${Uri.encodeComponent(message)}';

    return url;
  }

  Future<List<CategoriasModel>> getCategorias() async {
    String link =
        'https://2nfsboi1gi.execute-api.us-east-1.amazonaws.com/dev/categories/featured?featured=1';
    Response response = await dio.get(link);

    List<CategoriasModel> categorias = [];

    for (Map<String, dynamic> categoria in response.data) {
      categorias.add(CategoriasModel.fromJson(categoria));
    }

    return categorias;
  }

  Future<List<CarruselModel>> getImageCarrusel() async {
    String link =
        'https://4efh6anwka.execute-api.us-east-1.amazonaws.com/dev/config/banners/{id}';
    Response response = await dio.get(link);

    List<CarruselModel> imagenes = [];

    for (Map<String, dynamic> imagen in response.data) {
      imagenes.add(CarruselModel.fromJson(imagen));
    }

    return imagenes;
  }

  Future<List<DistritosModel>> getDistritos() async {
    String link =
        'https://phjesjw9wa.execute-api.us-east-1.amazonaws.com/dev/district/list';
    Response response = await dio.get(link);

    List<DistritosModel> distritos = [];

    for (Map<String, dynamic> distrito in response.data) {
      distritos.add(DistritosModel.fromJson(distrito));
    }

    return distritos;
  }

  Future<List<MarcasModel>> getMarcasByDistrito(
      String district, String categoria) async {
    String link =
        'https://w7lje56t6h.execute-api.us-east-1.amazonaws.com/dev/suppliers/district/$district/category/$categoria';
    Response response = await dio.get(link);

    List<MarcasModel> marcas = [];
    List<CertificadosModel> certificates = [];

    //print(response.data);

    if (response.data['data'] != null) {
      List<dynamic> marcaList = response.data['data'];

      for (Map<String, dynamic> marca in marcaList) {
        if (marca['certificates'] != null) {
          List<dynamic> certificatesList = marca['certificates'];
          for (Map<String, dynamic> certificate in certificatesList) {
            certificates.add(CertificadosModel.fromJson(certificate));
          }
        }

        marcas.add(MarcasModel.fromJson(marca));
      }
    }

    return marcas;
  }

  Future<List<ProductoModel>> getProductosbymarca(String id) async {
    String link =
        'https://ozstkosm6b.execute-api.us-east-1.amazonaws.com/dev/products?id_supplier=$id';
    Response response = await dio.get(link);

    List<ProductoModel> productos = [];

    for (Map<String, dynamic> producto in response.data) {
      productos.add(ProductoModel.fromJson(producto));
    }

    return productos;
  }

  passRecovery(String email, BuildContext context) async {
    Map<String, dynamic> dataSend = {
      "email": email,
    };

    String jsonBody = jsonEncode(dataSend);

    await dio
        .post(
      'https://gc1hfo9hl0.execute-api.us-east-1.amazonaws.com/dev/auth/password_recovery',
      data: jsonBody,
    )
        .then((value) async {
      if (value.statusCode == 200) {
        Fluttertoast.showToast(
          msg: 'La solicitud de recuperación ha sido creada con éxito',
          backgroundColor: Colors.green,
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      }
    }).catchError((e) {
      Fluttertoast.showToast(
          msg: 'Ha ocurrido un error',
          backgroundColor: Colors.red,
          textColor: Colors.black);
    });
  }
}
