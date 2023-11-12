import 'package:get/get.dart';

import 'data_controller.dart';

Future initControllers() async {
  Get.lazyPut(() => DataController());
}
