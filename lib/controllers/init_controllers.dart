import 'package:get/get.dart';
import 'package:masinqo_video_player/controllers/ad_controller.dart';

import './data_controller.dart';

Future initControllers() async {
  Get.lazyPut(() => DataController());
  Get.lazyPut(() => AdController());
}
