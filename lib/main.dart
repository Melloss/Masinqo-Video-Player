import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../screens/splash_screen.dart';
import './controllers/init_controllers.dart';

void main() async {
  await initControllers();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
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
      appBarTheme: const AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
        ),
        elevation: 0,
        toolbarHeight: 0,
      ),
      textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontFamily: 'RobotoCondensed',
            fontSize: 35,
            color: Color(0xFF3498db),
            fontWeight: FontWeight.w400,
          ),
          displayMedium: TextStyle(
            fontFamily: 'RobotoCondensed',
            fontSize: 18,
            color: Colors.black54,
            fontWeight: FontWeight.w200,
          )),
    );
  }
}
