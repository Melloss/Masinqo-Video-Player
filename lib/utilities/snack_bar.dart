import 'package:get/get.dart';
import 'package:flutter/material.dart' show EdgeInsets;

showSnackbar(String title, String message) {
  Get.snackbar(
    title,
    message,
    snackPosition: SnackPosition.BOTTOM,
    margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
  );
}
