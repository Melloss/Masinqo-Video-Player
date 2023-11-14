import 'package:get/get.dart';
import 'package:flutter/material.dart' show EdgeInsets, Color, Colors;

import '../controllers/data_controller.dart';

showSnackbar(String title, String message,
    {Color? color, double? horizontalMargin}) {
  DataController dataController = Get.find();
  Get.snackbar(title, message,
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.symmetric(
          vertical: 30, horizontal: horizontalMargin ?? 15),
      colorText: color ?? Colors.white,
      backgroundColor: dataController.backgroundColor);
}
