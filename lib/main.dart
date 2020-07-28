import 'package:barcode_scanner/product_registration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'export_warehouse.dart';
import 'home_page.dart';
import 'import_warehouse.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'Warehouse manager',
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/register-product': (context) => RegisterProduct(),
        '/import-warehouse': (context) => ImportWarehouse(),
        '/export-warehouse': (context) => ExportWarehouse(),
      },
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: MaterialColor(
          0xFF6AA84F,
          {
            50: Color(0xFFCEE2C5),
            100: Color(0xFFC2DBB7),
            200: Color(0xFFB3D2A5),
            300: Color(0xFFA0C78E),
            400: Color(0xFF88B972),
            500: Color(0xFF6AA84F),
            600: Color(0xFF55863F),
            700: Color(0xFF446B32),
            800: Color(0xFF365628),
            900: Color(0xFF2B4520),
          },
        ),
        visualDensity: VisualDensity.comfortable,
        accentColorBrightness: Brightness.dark,
        accentColor: Color(0xFFA84F6A),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: MaterialColor(0xFF446B32, {
          50: Color(0xFFC1CFBC),
          100: Color(0xFFB2C3AB),
          200: Color(0xFF9FB496),
          300: Color(0xFF87A17C),
          400: Color(0xFF69895B),
          500: Color(0xFF446B32),
          600: Color(0xFF365628),
          700: Color(0xFF2B4520),
          800: Color(0xFF22371A),
          900: Color(0xFF1B2C15),
        }),
        visualDensity: VisualDensity.comfortable,
        accentColorBrightness: Brightness.light,
        accentColor: Color(0xFF32446B),
      ),
    );
  }
}
