import 'package:caninar/constants/principals_colors.dart';
import 'package:caninar/constants/routes.dart';
import 'package:caninar/models/user/model.dart';
import 'package:caninar/pages/page_categoria_seleccionada.dart';
import 'package:caninar/providers/calendario_provider.dart';
import 'package:caninar/providers/cart_provider.dart';
import 'package:caninar/providers/datos_cobro_provider.dart';
import 'package:caninar/providers/direccion_provider.dart';
import 'package:caninar/providers/id_orden_provider.dart';
import 'package:caninar/providers/index_provider.dart';
import 'package:caninar/providers/orden_provider.dart';
import 'package:caninar/providers/producto_provider.dart';
import 'package:caninar/shared_Preferences/shared.dart';
import 'package:caninar/widgets/404_page.dart';
import 'package:caninar/widgets/about_us.dart';
import 'package:caninar/navigation_pages/navigation_home.dart';
import 'package:caninar/widgets/compra_finalizada.dart';
import 'package:caninar/widgets/compra_rechazada.dart';
import 'package:caninar/widgets/finalizar_compra.dart';
import 'package:caninar/widgets/home_adriestrador.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => FutureBuilder<UserLoginModel?>(
          future: Shared().currentUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Mostrar un indicador de carga mientras se espera
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              // Manejar errores
              return const Center(child: Text('Error al cargar'));
            } else {
              final user = snapshot.data;
              if (user != null) {
                if (user.type == 1 || user.type == 3) {
                  return const Home();
                } else {
                  return const HomeAdiestrador();
                }
              } else {
                return const Home();
              }
            }
          },
        ),
      ),
      GoRoute(
        path: '/payment/success',
        builder: (context, state) {
          Map<String, String> queryParams = state.uri.queryParameters;
          return CompraFinalizada(
            queryParams: queryParams,
          );
        },
      ),
      GoRoute(
        path: '/payment/error',
        builder: (context, state) => const CompraRechazada(),
      ),
    ],
    errorBuilder: (context, state) => const Home(),
  );

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => ProductoProvider()),
        ChangeNotifierProvider(create: (context) => OrdenProvider()),
        ChangeNotifierProvider(create: (context) => DireccionProvider()),
        ChangeNotifierProvider(create: (context) => CalendarioProvider()),
        ChangeNotifierProvider(create: (context) => IndexNavegacion()),
        ChangeNotifierProvider(create: (context) => IdOrdenProvider()),
        ChangeNotifierProvider(create: (context) => CobroProvider()),
      ],
      child: MaterialApp.router(
        routerConfig: router,
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
        theme: ThemeData(useMaterial3: false),
        debugShowCheckedModeBanner: false,
        locale: const Locale('es'),
      ),
    );
  }
}
