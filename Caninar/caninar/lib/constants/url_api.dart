import 'package:caninar/services/dev.dart';

class UrlApi {
  static String auth = Dev.isDev
      ? 'https://gc1hfo9hl0.execute-api.us-east-1.amazonaws.com/dev'
      : 'https://lhdb8etem6.execute-api.us-east-1.amazonaws.com/pro';
  static String billing = Dev.isDev
      ? 'https://526d3xobb4.execute-api.us-east-1.amazonaws.com/dev'
      : 'https://ug2bzbjp9a.execute-api.us-east-1.amazonaws.com/pro';
  static String cart = Dev.isDev
      ? 'https://xcgb8jo8r3.execute-api.us-east-1.amazonaws.com/dev'
      : 'https://27ino9p5i8.execute-api.us-east-1.amazonaws.com/pro';
  static String categories = Dev.isDev
      ? 'https://2nfsboi1gi.execute-api.us-east-1.amazonaws.com/dev'
      : 'https://skrmntqbpk.execute-api.us-east-1.amazonaws.com/pro';
  static String config = Dev.isDev
      ? 'https://4efh6anwka.execute-api.us-east-1.amazonaws.com/dev'
      : 'https://azb4gfjmb7.execute-api.us-east-1.amazonaws.com/pro';
  static String coupons = Dev.isDev
      ? 'https://8r14grfe5a.execute-api.us-east-1.amazonaws.com/dev'
      : 'https://bbphldzpia.execute-api.us-east-1.amazonaws.com/pro';
  static String dashboard = Dev.isDev
      ? 'https://dyrkgyykob.execute-api.us-east-1.amazonaws.com/dev'
      : 'https://zf71nen8pa.execute-api.us-east-1.amazonaws.com/pro';
  static String district = Dev.isDev
      ? 'https://phjesjw9wa.execute-api.us-east-1.amazonaws.com/dev'
      : 'https://5qlm1b1vul.execute-api.us-east-1.amazonaws.com/pro';
  static String images = Dev.isDev
      ? 'https://13wukmmcl7.execute-api.us-east-1.amazonaws.com/dev'
      : 'https://3k2jdv7vq2.execute-api.us-east-1.amazonaws.com/pro';
  static String orders = Dev.isDev
      ? 'https://0v7g8z5804.execute-api.us-east-1.amazonaws.com/dev'
      : 'https://mx4r68p7z0.execute-api.us-east-1.amazonaws.com/pro';
  static String pets = Dev.isDev
      ? 'https://5sl6737lhc.execute-api.us-east-1.amazonaws.com/dev'
      : 'https://ifhb5acdm6.execute-api.us-east-1.amazonaws.com/pro';
  static String products = Dev.isDev
      ? 'https://ozstkosm6b.execute-api.us-east-1.amazonaws.com/dev'
      : 'https://zo3u0mf90a.execute-api.us-east-1.amazonaws.com/pro';
  static String ratings = Dev.isDev
      ? 'https://2ikgw4dk46.execute-api.us-east-1.amazonaws.com/dev'
      : 'https://ru9ltx6dfl.execute-api.us-east-1.amazonaws.com/pro';
  static String suppliers = Dev.isDev
      ? 'https://w7lje56t6h.execute-api.us-east-1.amazonaws.com/dev'
      : 'https://e5d9vgy8ii.execute-api.us-east-1.amazonaws.com/pro';
  static String transaction = Dev.isDev
      ? 'https://conlwugaye.execute-api.us-east-1.amazonaws.com/dev'
      : 'https://86d0ezca01.execute-api.us-east-1.amazonaws.com/pro';
  static String users = Dev.isDev
      ? 'https://v3x0nryj7b.execute-api.us-east-1.amazonaws.com/dev'
      : 'https://13mokpecyh.execute-api.us-east-1.amazonaws.com/pro';
  static String mercadoPago = Dev.isDev
      ? 'https://lc6rd6q7pa.execute-api.us-east-1.amazonaws.com/dev'
      : 'https://ki8e13yyy7.execute-api.us-east-1.amazonaws.com/pro';
}
