import 'dart:io' show Platform;

import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../screens/video_play_screen.dart';

class AdController extends GetxController {
  int selectedIndex = -1;
  InterstitialAd? interstitialAd;
  final _adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/1033173712'
      : 'ca-app-pub-3940256099942544/4411468910';

  /// Loads an interstitial ad.
  void loadAd() {
    try {
      InterstitialAd.load(
        adUnitId: _adUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (ad) {
            ad.fullScreenContentCallback = FullScreenContentCallback(
              onAdFailedToShowFullScreenContent: (ad, err) {
                Get.to(() => VideoPlayScreen(index: selectedIndex));
                // Dispose the ad here to free resources.
                ad.dispose();
              },
              // Called when the ad dismissed full screen content.
              onAdDismissedFullScreenContent: (ad) {
                Get.to(() => VideoPlayScreen(index: selectedIndex));
                ad.dispose();
              },
            );

            //print('$ad loaded.');
            // Keep a reference to the ad so you can show it later.
            interstitialAd = ad;
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {
            //print('InterstitialAd failed to load: $error');
          },
        ),
      );
    } catch (error) {
      //print(error);
    }
  }
}
