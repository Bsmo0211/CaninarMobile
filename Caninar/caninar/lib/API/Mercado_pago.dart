import 'package:caninar/constants/access_keys.dart';
import 'package:caninar/constants/url_api.dart';
import 'package:caninar/widgets/finalizar_compra.dart';
import 'package:flutter/material.dart';
import 'package:mercadopago_sdk/mercadopago_sdk.dart';
import 'package:dio/dio.dart';

class MercadoPago {
  MP mp = MP(Keys.mpClientId, Keys.mpClientSecret);
  MP mpAcces = MP.fromAccessToken(Keys.mpAccesTokenKey);
  static Dio dio = Dio();

  Future<String?> createPreference(
    BuildContext context,
    String supplierId,
    String email,
    String nombreEmpresa,
    String descripcion,
    String idItem,
    int cantidad,
    double precio,
  ) async {
    Dio dio = Dio();
    String? id;

    try {
      Response response = await dio.post(
        '${UrlApi.mercadoPago}/mercadopago/create_preference',
        data: {
          "supplier_id": supplierId,
          "payer_email": email,
          "items": [
            {
              "id": idItem,
              "title": nombreEmpresa,
              "currency_id": "PEN",
              "picture_url":
                  "https://www.mercadopago.com/org-img/MP3/home/logomp3.gif",
              "description": descripcion,
              "category_id": "art",
              "quantity": cantidad,
              "unit_price": precio
            }
          ],
        },
      );

      if (response.statusCode == 200) {
        id = response.data['id'];
      }
    } catch (e) {
      print(e);
    }

    return id;
  }

  Future<String?> ejecutarMercadoPago(
      BuildContext context,
      String supplierId,
      String email,
      String nombreEmpresa,
      String descripcion,
      String idItem,
      int cantidad,
      double precio) async {
    String? value = await createPreference(context, supplierId, email,
        nombreEmpresa, descripcion, idItem, cantidad, precio);

    return value;
  }
}
