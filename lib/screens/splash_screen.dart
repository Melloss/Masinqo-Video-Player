import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart'
    show SpinKitWave, SpinKitWaveType;
import 'package:get/get.dart';
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
  bool showTryAgainButton = false;

  initalizeEveryData() async {
    bool isFetchingCompleted = await dataController.isFetchingCompleted();
    Future.delayed(const Duration(seconds: 2));
    if (isFetchingCompleted) {
      setState(() {
        showTryAgainButton = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  'Mesenqo',
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
          showTryAgainButton
              ? TextButton(
                  onPressed: () {
                    setState(() {
                      showTryAgainButton = false;
                    });
                  },
                  child: Text('Try Again'))
              : const SpinKitWave(
                  type: SpinKitWaveType.center,
                  color: Color(0xFF3498db),
                  size: 25,
                  itemCount: 10,
                  duration: Duration(seconds: 2),
                ),
        ],
      ),
    );
  }
}
