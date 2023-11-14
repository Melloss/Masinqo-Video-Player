import 'dart:async';
import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:in_app_review/in_app_review.dart';

import '../controllers/ad_controller.dart';
import '../utilities/color_pallet.dart';
import '../utilities/media_query.dart';
import '../controllers/data_controller.dart';
import '../utilities/snack_bar.dart';

class VideoListScreen extends StatefulWidget {
  const VideoListScreen({super.key});

  @override
  State<VideoListScreen> createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen> with ColorPallet {
  DataController dataController = Get.find();
  AdController adController = Get.find();
  late StreamSubscription<ConnectivityResult> subscription;
  late ConnectivityResult _connectivityResult;
  int selectedIndex = -1;

  @override
  void initState() {
    _connectivityResult = ConnectivityResult.none;
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      setState(
        () {
          _connectivityResult = result;
        },
      );
      // Lock the orientation to portrait when the screen is created
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      // this loads ad
      adController.loadAd();
    });
    super.initState();
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: dataController.backgroundColor,
      appBar: AppBar(
        toolbarHeight: 40,
        backgroundColor: dataController.backgroundColor,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: dataController.backgroundColor,
          statusBarIconBrightness: Brightness.light,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 7, right: 7),
            child: IconButton(
                onPressed: () async {
                  Share.share('Share this app');
                },
                icon: const Icon(Icons.share)),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 7, right: 10),
            child: IconButton(
              onPressed: () async {
                try {
                  final InAppReview inAppReview = InAppReview.instance;
                  if (await inAppReview.isAvailable()) {
                    await inAppReview.requestReview();
                  }
                } catch (error) {
                  //(error.toString());
                }
              },
              icon: const Icon(Icons.rate_review),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildTop(),
          _buildVideoList(),
        ],
      ),
    );
  }

  _buildTop() {
    return Expanded(
      child: SizedBox(
        width: screenWidth(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Transform.rotate(
                  angle: math.pi * 0.3,
                  child: Image.asset(
                    'assets/masinko_box.png',
                    fit: BoxFit.cover,
                    width: 100,
                  ),
                ),
                SizedBox(
                  height: 40,
                  child: Row(
                    children: [
                      Text(
                        'Masinqo',
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge!
                            .copyWith(
                                color: splashBackgroundColor,
                                fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(width: 5),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          'Video Player',
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(
                                  color: splashBackgroundColor,
                                  fontWeight: FontWeight.w400),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  _buildVideoTile(int index) {
    return InkWell(
      onTap: () {
        // here it checks the internet connectivity and loads the ad
        if (_connectivityResult == ConnectivityResult.mobile) {
          adController.selectedIndex = index;
          adController.interstitialAd?.show();
        } else {
          showSnackbar('No Internet Connection',
              'Pls Connect to Internet, and Try Again!');
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: Row(
          children: [
            Stack(children: [
              Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                width: 120,
                height: 80,
                child: Shimmer.fromColors(
                  baseColor: Colors.blueGrey,
                  highlightColor: splashBackgroundColor,
                  child: Container(
                    color: dataController.backgroundColor,
                  ),
                ),
              ),
              Container(
                clipBehavior: Clip.antiAlias,
                width: 120,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: FutureBuilder<ConnectivityResult>(
                    future: Connectivity().checkConnectivity(),
                    builder: (context, snapshot) {
                      try {
                        return CachedNetworkImage(
                          imageUrl: dataController.videoList[index].thumbnail,
                          fit: BoxFit.fill,
                        );
                      } catch (error) {
                        return Container();
                      }
                    }),
              ),
              Positioned(
                  top: 0,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Icon(
                    Icons.play_circle,
                    size: 25,
                    color: splashBackgroundColor,
                  ))
            ]),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dataController.videoList[index].title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 5),
                Text(
                  dataController.videoList[index].description.length > 40
                      ? '${dataController.videoList[index].description.substring(0, 40)}...'
                      : dataController.videoList[index].description,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  _buildVideoList() {
    return Container(
      width: screenWidth(context),
      height: screenHeight(context) * 0.75,
      padding: const EdgeInsets.only(top: 50),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 5,
          )
        ],
        color: splashBackgroundColor,
        borderRadius: const BorderRadius.only(topRight: Radius.circular(80)),
      ),
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: dataController.videoList.length,
        itemBuilder: (context, index) {
          return _buildVideoTile(index);
        },
      ),
    );
  }
}
