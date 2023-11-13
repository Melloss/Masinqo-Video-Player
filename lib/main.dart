import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../utilities/color_pallet.dart';
import '../screens/splash_screen.dart';
import './controllers/init_controllers.dart';

void main() async {
  await initControllers();
  runApp(MainApp());
}

class MainApp extends StatelessWidget with ColorPallet {
  MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: const SplashScreen(),
      theme: _buildTheme(),
      debugShowCheckedModeBanner: false,
    );
  }

  ThemeData _buildTheme() {
    return ThemeData(
      scaffoldBackgroundColor: splashBackgroundColor,
      appBarTheme: AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: splashBackgroundColor,
          statusBarIconBrightness: Brightness.dark,
        ),
        elevation: 0,
        toolbarHeight: 0,
      ),
      textTheme: TextTheme(
        displayLarge: const TextStyle(
          fontFamily: 'RobotoCondensed',
          fontSize: 35,
          color: Color(0xFF3498db),
          fontWeight: FontWeight.w400,
        ),
        displayMedium: const TextStyle(
          fontFamily: 'RobotoCondensed',
          fontSize: 18,
          color: Colors.black54,
          fontWeight: FontWeight.w200,
        ),
        displaySmall: const TextStyle(
          fontFamily: 'RobotoCondensed',
          fontSize: 13,
        ),
        titleLarge: TextStyle(
          fontFamily: 'RobotoCondensed',
          color: textColor,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        titleMedium: TextStyle(
          fontFamily: 'RobotoCondensed',
          color: textColor,
          fontSize: 12.5,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }
}
