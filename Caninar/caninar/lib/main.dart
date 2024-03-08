import 'package:caninar/constants/principals_colors.dart';
import 'package:caninar/constants/routes.dart';
import 'package:caninar/models/user/model.dart';
import 'package:caninar/pages/page_categoria_seleccionada.dart';
import 'package:caninar/providers/calendario_provider.dart';
import 'package:caninar/providers/cart_provider.dart';
import 'package:caninar/providers/direccion_provider.dart';
import 'package:caninar/providers/orden_provider.dart';
import 'package:caninar/providers/producto_provider.dart';
import 'package:caninar/shared_Preferences/shared.dart';
import 'package:caninar/widgets/about_us.dart';

import 'package:caninar/pages/home.dart';
import 'package:caninar/widgets/finalizar_compra.dart';
import 'package:caninar/widgets/home_adriestrador.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:location/location.dart';

Widget _defaultHome = const Home();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //await Location().requestPermission();
  UserLoginModel? user = await Shared().currentUser();

  if (user != null) {
    if (user.type == 1 || user.type == 1) {
      _defaultHome = const Home();
    } else {
      _defaultHome = const HomeAdiestrador();
    }
  } else {
    _defaultHome = const Home();
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => (CartProvider()),
        ),
        ChangeNotifierProvider(
          create: (context) => (ProductoProvider()),
        ),
        ChangeNotifierProvider(
          create: (context) => (OrdenProvider()),
        ),
        ChangeNotifierProvider(
          create: (context) => (DireccionProvider()),
        ),
        ChangeNotifierProvider(
          create: (context) => (CalendarioProvider()),
        ),
      ],
      child: MaterialApp(
        builder: EasyLoading.init(),
        localizationsDelegates: const [
          SfGlobalLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'), // English
          Locale('es'),
        ],
        title: 'Caninar',
        theme: ThemeData().copyWith(
          cardTheme: const CardTheme(
            surfaceTintColor: Colors.white,
          ),
          useMaterial3: false,
          colorScheme: ThemeData().colorScheme.copyWith(
                primary: PrincipalColors.blue,
              ),
          brightness: Brightness.light,
        ),
        debugShowCheckedModeBanner: false,
        locale: const Locale('es'),
        home: _defaultHome,
      ),
    );
  }
}
