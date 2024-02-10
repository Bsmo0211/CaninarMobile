import 'package:caninar/constants/access_keys.dart';
import 'package:caninar/widgets/finalizar_compra.dart';
import 'package:flutter/material.dart';
import 'package:mercadopago_sdk/mercadopago_sdk.dart';
import 'package:dio/dio.dart';

class MercadoPago {
  MP mp = MP(Keys.mpClientId, Keys.mpClientSecret);
  MP mpAcces = MP.fromAccessToken(Keys.mpAccesTokenKey);
  static Dio dio = Dio();

  Future<Map<String, dynamic>> createPreference(BuildContext context) async {
    Map<String, dynamic> preference = {
      "items": [
        {
          "title": "Caninar",
          "description": "Venta de productos en Caninar",
          "quantity": 1,
          "unit_price": 200,
          "currency_id": "PEN",
        }
      ],
      "back_urls": {
        "success": "https://dev.caninar.com/success",
        "failure": '',
        "pending": "caninarApp://pending"
      },
      "auto_return": "approved",
    };
    var result = await mp.createPreference(preference);

    return result;
  }

  Future<String> ejecutarMercadoPago(BuildContext context) async {
    String id;

    var value = await createPreference(context);

    print(value);

    id = value['response']['id'];

    return id;
  }
}
