import 'dart:convert';

import 'package:caninar/constants/url_api.dart';
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
import 'package:caninar/services/dev.dart';
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
    String link = '${UrlApi.categories}/categories/featured?featured=1';

    Response response = await dio.get(link);

    List<CategoriasModel> categorias = [];

    for (Map<String, dynamic> categoria in response.data) {
      categorias.add(CategoriasModel.fromJson(categoria));
    }

    return categorias;
  }

  Future<List<CarruselModel>> getImageCarrusel() async {
    String link = '${UrlApi.config}/config/banners/1';
    Response response = await dio.get(link);

    List<CarruselModel> imagenes = [];

    for (Map<String, dynamic> imagen in response.data) {
      imagenes.add(CarruselModel.fromJson(imagen));
    }

    return imagenes;
  }

  Future<List<DistritosModel>> getDistritos() async {
    String link = '${UrlApi.district}/district/list';
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
        '${UrlApi.suppliers}/suppliers/district/$district/category/$categoria';
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
        '${UrlApi.products}/products/district/$district/supplier/$marca/category/$categoria';
    Response response = await dio.get(link);

    List<ProductoModel> productos = [];

    List<dynamic> productList = response.data['products'];

    for (Map<String, dynamic> producto in productList) {
   
      productos.add(ProductoModel.fromJson(producto));
    }

    return productos;
  }

  Future<List<MascotasModel>> getMascotasByUser(String id) async {
    String link = '${UrlApi.pets}/pet/list/$id';
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
      '${UrlApi.auth}/auth/password_recovery',
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
    String link = '${UrlApi.users}/users/$id';

    await dio.put(link, data: dataSend).then((value) async {
      if (value.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('user_data', jsonEncode(dataSend));
        Fluttertoast.showToast(
            msg: 'Información actualizada con éxito',
            backgroundColor: Colors.green,
            textColor: Colors.white);
      }
    }).catchError((e) {
      print(e);
      Fluttertoast.showToast(
          msg: 'Ha ocurrido con la actualización de los datos',
          backgroundColor: Colors.red,
          textColor: Colors.black);
    });
  }

  Future<String?> createCarrito(Map<String, dynamic> datosCarrito) async {
    String jsonBody = jsonEncode(datosCarrito);
    String? idCart;

    await dio
        .post(
      '${UrlApi.cart}/cart',
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
      '${UrlApi.orders}/orders',
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
    await dio
        .put(
          '${UrlApi.users}/users/tracking?schedule_id=$id',
          data: {"coordinates": datosOrden, 'sh_status': status},
        )
        .then((value) async {})
        .catchError((e) {
          print(e);
          Fluttertoast.showToast(
            msg: 'Ha ocurrido un error',
            backgroundColor: Colors.red,
            textColor: Colors.black,
          );
        });
  }

  Future<void> updateScheduleById(
      String id, Map<String, dynamic> timeActualizacion) async {
    await dio.put(
      '${UrlApi.orders}/orders/schedule/$id',
      data: {
        "sh_status": 'coming',
        "time": timeActualizacion,
      },
    ).then((value) async {
      Fluttertoast.showToast(
        msg: 'La cita ha sido programada con éxito',
        backgroundColor: Colors.green,
      );
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
    await dio
        .put(
          '${UrlApi.users}/users/tracking?schedule_id=$id',
          data: {"coordinates": datosOrden},
        )
        .then((value) async {})
        .catchError((e) {
          print(e);
          Fluttertoast.showToast(
            msg: 'Ha ocurrido un error',
            backgroundColor: Colors.red,
            textColor: Colors.black,
          );
        });
  }

  Future<List<Map<String, dynamic>>> getPointsSupplierById(String id) async {
    String link = '${UrlApi.users}/users/tracking?schedule_id=$id';

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

  Future<UserLoginModel> getUserByid(String id) async {
    final response = await dio.get('${UrlApi.users}/users/$id');

    if (response.statusCode == 200) {
      return UserLoginModel.fromJson(response.data);
    } else {
      throw Exception('Failed to load supplier');
    }
  }

  Future<Map<String, dynamic>> getCitas(String? id, int? type) async {
    String link = '${UrlApi.users}/users/datings/$id?role=$type';

    Response response = await dio.get(link);

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to load information');
    }
  }

  Future<MarcasModel> getSupplierById(String id) async {
    final response = await dio.get('${UrlApi.suppliers}/suppliers/$id');

    if (response.statusCode == 200) {
      return MarcasModel.fromJson(response.data);
    } else {
      throw Exception('Failed to load supplier');
    }
  }

  Future<MascotasModel> getPetById(String id) async {
    final response = await dio.get('${UrlApi.pets}/pet/$id');

    if (response.statusCode == 200) {
      return MascotasModel.fromJson(response.data);
    } else {
      throw Exception('Failed to load supplier');
    }
  }

  Future<Map<String, dynamic>> getOrdenById(String id) async {
    Map<String, dynamic> estado;
    final response = await dio.get('${UrlApi.orders}/orders/$id');

    if (response.statusCode == 200) {
      estado = response.data;
      return estado;
    } else {
      throw Exception('error');
    }
  }

  Future<void> updatePaymentStatusOrden(String id) async {
    await dio.put(
      '${UrlApi.orders}/orders/$id',
      data: {"payment_status": "approved"},
    ).then((value) async {
      if (value.statusCode == 200) {}
    }).catchError((e) {
      print(e);
      Fluttertoast.showToast(
        msg: 'Ha ocurrido un error',
        backgroundColor: Colors.red,
        textColor: Colors.black,
      );
    });
  }

  Future<void> deletePets(String id) async {
    await dio
        .delete(
      '${UrlApi.pets}/pet/$id',
    )
        .then((value) async {
      if (value.statusCode == 200) {
        Fluttertoast.showToast(
          msg: 'Mascota eliminada con éxito',
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
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

  updatePets(Map<String, dynamic> dataSend, String id) async {
    String link = '${UrlApi.pets}/pet/$id';

    await dio.put(link, data: dataSend).then((value) async {
      if (value.statusCode == 200) {
        Fluttertoast.showToast(
            msg: 'Información actualizada con éxito',
            backgroundColor: Colors.green,
            textColor: Colors.white);
      }
    }).catchError((e) {
      print(e);
      Fluttertoast.showToast(
          msg: 'Ha ocurrido con la actualización de los datos',
          backgroundColor: Colors.red,
          textColor: Colors.black);
    });
  }

  Future<void> sendParams(Map<String, dynamic> updateParams) async {
    await dio
        .post(
      '${UrlApi.transaction}/transaction/charge',
      data: updateParams,
    )
        .then((value) async {
      if (value.statusCode == 200) {
        print('enviado con exito');
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

  Future<Map<String, dynamic>> getInfoComunidad() async {
    Map<String, dynamic> estado;
    final response = await dio.get('${UrlApi.config}/config/general');

    if (response.statusCode == 200) {
      estado = response.data;
      return estado;
    } else {
      throw Exception('error');
    }
  }

  Future<Map<String, dynamic>> getProductsSearch(
      String distrito, String busqueda) async {
    Map<String, dynamic> search;
    final response = await dio
        .get('${UrlApi.products}/products/district/$distrito/search/$busqueda');

    if (response.statusCode == 200) {
      search = response.data;
      return search;
    } else {
      throw Exception('error');
    }
  }
}
