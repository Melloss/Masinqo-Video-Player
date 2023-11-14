import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart' show SpinKitThreeBounce;
import 'package:get/get.dart';

import '../screens/video_list_screen.dart';
import '../controllers/ad_controller.dart';
import '../controllers/data_controller.dart';
import '../utilities/media_query.dart';
import '../widgets/masinqo_loading_animation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  DataController dataController = Get.find();
  AdController adController = Get.find();
  bool showTryAgainButton = false;
  bool isLoading = false;

  initializeEveryData() async {
    setState(() {
      isLoading = true;
    });
    bool isFetchingCompleted = await dataController.isFetchingSuccessful();
    await Future.delayed(const Duration(seconds: 3));
    setState(() {
      isLoading = false;
    });
    if (isFetchingCompleted) {
      setState(() {
        showTryAgainButton = false;
      });
      Get.off(() => const VideoListScreen(),
          transition: Transition.fadeIn, duration: const Duration(seconds: 2));
    } else {
      setState(() {
        showTryAgainButton = true;
      });
    }
    // it addes ad for later use
    adController.loadAd();
  }

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    initializeEveryData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const MasinqoLoadingAnimation(),
          SizedBox(
            height: screenHeight(context) * 0.3,
            width: screenWidth(context),
            child: Column(
              children: [
                Text(
                  'Masinqo',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                const SizedBox(height: 10),
                Text(
                  'Video Player',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 100,
            child: showTryAgainButton
                ? TextButton(
                    onPressed: () async {
                      setState(() {
                        showTryAgainButton = false;
                      });
                      await initializeEveryData();
                    },
                    child: Column(
                      children: [
                        Text(
                          'Try Again',
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                        const SizedBox(height: 10),
                        const Icon(Icons.refresh)
                      ],
                    ))
                : Visibility(
                    visible: isLoading,
                    child: const SpinKitThreeBounce(
                      color: Color(0xFF3498db),
                      size: 17,
                      duration: Duration(seconds: 2),
                    ),
                  ),
          )
        ],
      ),
    );
  }
}
