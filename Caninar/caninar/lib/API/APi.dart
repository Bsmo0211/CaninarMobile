import 'dart:convert';

import 'package:caninar/models/carrusel/model.dart';
import 'package:caninar/models/categorias/model.dart';
import 'package:caninar/models/certificados/model.dart';
import 'package:caninar/models/citas/model_current.dart';
import 'package:caninar/models/citas/model_history.dart';
import 'package:caninar/models/citas/model_pending.dart';
import 'package:caninar/models/distritos/model.dart';
import 'package:caninar/models/marcas/model.dart';
import 'package:caninar/models/mascotas/model.dart';
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
    // https://ozstkosm6b.execute-api.us-east-1.amazonaws.com/dev/products/district/{district_slug}/supplier/{supplier-slug}/category/{category_slug}
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

  Future<List<ProductoModel>> getProductosbymarca(
      String district, String categoria, String marca) async {
    String link =
        'https://ozstkosm6b.execute-api.us-east-1.amazonaws.com/dev/products/district/$district/supplier/$marca/category/$categoria';
    Response response = await dio.get(link);

    List<ProductoModel> productos = [];

    List<dynamic> productList = response.data['products'];

    for (Map<String, dynamic> producto in productList) {
      productos.add(ProductoModel.fromJson(producto));
    }

    return productos;
  }

  Future<List<MascotasModel>> getMascotasByUser(String id) async {
    String link =
        'https://5sl6737lhc.execute-api.us-east-1.amazonaws.com/dev/pet/list/$id';
    Response response = await dio.get(link);

    List<MascotasModel> mascotas = [];

    for (Map<String, dynamic> mascota in response.data) {
      mascotas.add(MascotasModel.fromJson(mascota));
    }

    return mascotas;
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

  updateUser(Map<String, dynamic> dataSend, String id) async {
    String link =
        'https://v3x0nryj7b.execute-api.us-east-1.amazonaws.com/dev/users/$id';

    String jsonBody = jsonEncode(dataSend);
    await dio.put(link, data: jsonBody).then((value) async {
      if (value.statusCode == 200) {
        Fluttertoast.showToast(
            msg: 'Información actualizada con éxito',
            backgroundColor: Colors.green,
            textColor: Colors.white);
      }
    }).catchError((e) {
      print(e);
      Fluttertoast.showToast(
          msg: 'Ha ocurrido con la creación de la dirección',
          backgroundColor: Colors.red,
          textColor: Colors.black);
    });
  }

  Future<String?> createCarrito(Map<String, dynamic> datosCarrito) async {
    String jsonBody = jsonEncode(datosCarrito);
    String? idCart;

    await dio
        .post(
      'https://xcgb8jo8r3.execute-api.us-east-1.amazonaws.com/dev/cart',
      data: jsonBody,
    )
        .then((value) async {
      if (value.statusCode == 200) {
        idCart = value.data['id'];
      }
    }).catchError((e) {
      Fluttertoast.showToast(
        msg: 'Ha ocurrido un error',
        backgroundColor: Colors.red,
        textColor: Colors.black,
      );
    });

    return idCart;
  }

  Future<String?> createOrden(Map<String, dynamic> datosOrden) async {
    String jsonBody = jsonEncode(datosOrden);
    String? idOrden;

    await dio
        .post(
      'https://0v7g8z5804.execute-api.us-east-1.amazonaws.com/dev/orders',
      data: jsonBody,
    )
        .then((value) async {
      if (value.statusCode == 200) {
        idOrden = value.data['id_order'];
      }
    }).catchError((e) {
      print(e);
      Fluttertoast.showToast(
        msg: 'Ha ocurrido un error',
        backgroundColor: Colors.red,
        textColor: Colors.black,
      );
    });

    return idOrden;
  }

  Future<void> updateFirstPointById(
      List<Map<String, dynamic>> datosOrden, String id, String status) async {
    await dio.put(
      'https://v3x0nryj7b.execute-api.us-east-1.amazonaws.com/dev/users/tracking?schedule_id=$id',
      data: {"coordinates": datosOrden, 'sh_status': status},
    ).then((value) async {
      if (value.statusCode == 200) {
        print(value.data);
      }
    }).catchError((e) {
      print(e);
      Fluttertoast.showToast(
        msg: 'Ha ocurrido un error',
        backgroundColor: Colors.red,
        textColor: Colors.black,
      );
    });
  }

  Future<void> updatePointById(
      List<Map<String, dynamic>> datosOrden, String id) async {
    await dio.put(
      'https://v3x0nryj7b.execute-api.us-east-1.amazonaws.com/dev/users/tracking?schedule_id=$id',
      data: {"coordinates": datosOrden},
    ).then((value) async {
      if (value.statusCode == 200) {
        print(value.data);
      }
    }).catchError((e) {
      print(e);
      Fluttertoast.showToast(
        msg: 'Ha ocurrido un error',
        backgroundColor: Colors.red,
        textColor: Colors.black,
      );
    });
  }

  Future<List<Map<String, dynamic>>> getPointsSupplierById(String id) async {
    String link =
        'https://v3x0nryj7b.execute-api.us-east-1.amazonaws.com/dev/users/tracking?schedule_id=$id';

    Response response = await dio.get(link);

    if (response.statusCode == 200) {
      List<Map<String, dynamic>> points = [];
      for (Map<String, dynamic> punto in response.data) {
        points.add(punto);
      }
      return points;
    } else {
      throw Exception('Failed to load points');
    }
  }

  Future<Map<String, dynamic>> getCitas(String? id, int? type) async {
    String link =
        'https://v3x0nryj7b.execute-api.us-east-1.amazonaws.com/dev/users/datings/$id?role=$type';

    Response response = await dio.get(link);

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to load information');
    }
  }

  Future<MarcasModel> getSupplierById(String id) async {
    final response = await dio.get(
        'https://w7lje56t6h.execute-api.us-east-1.amazonaws.com/dev/suppliers/$id');

    if (response.statusCode == 200) {
      return MarcasModel.fromJson(response.data);
    } else {
      throw Exception('Failed to load supplier');
    }
  }

  Future<MascotasModel> getPetById(String id) async {
    final response = await dio.get(
        'https://5sl6737lhc.execute-api.us-east-1.amazonaws.com/dev/pet/$id');

    if (response.statusCode == 200) {
      return MascotasModel.fromJson(response.data);
    } else {
      throw Exception('Failed to load supplier');
    }
  }

  Future<String?> getOrdenById(String id) async {
    String? estado;
    final response = await dio.get(
        'https://0v7g8z5804.execute-api.us-east-1.amazonaws.com/dev/orders/$id');

    if (response.statusCode == 200) {
      estado = response.data['payment_status'];
      return estado;
    } else {
      throw Exception('error');
    }
  }

  Future<void> updateOrden(
      List<Map<String, dynamic>> datosActualizacionOrden, String id) async {
    await dio.put(
      'https://0v7g8z5804.execute-api.us-east-1.amazonaws.com/dev/orders/$id',
      data: {
        'schedule': datosActualizacionOrden,
      },
    ).then((value) async {
      if (value.statusCode == 200) {
        print(value.data);
      }
    }).catchError((e) {
      print(e);
      Fluttertoast.showToast(
        msg: 'Ha ocurrido un error',
        backgroundColor: Colors.red,
        textColor: Colors.black,
      );
    });
  }
}
