import 'package:caninar/constants/principals_colors.dart';
import 'package:caninar/constants/routes.dart';
import 'package:caninar/pages/page_categoria_seleccionada.dart';
import 'package:caninar/widgets/about_us.dart';

import 'package:caninar/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:location/location.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Location().requestPermission();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      home: const Home(),
      routes: {
        Routes.home.name: (_) => const Home(),
      },
    );
  }
}
