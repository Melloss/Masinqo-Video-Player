import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../controllers/ad_controller.dart';
import '../utilities/media_query.dart';
import '../controllers/data_controller.dart';
import '../utilities/snack_bar.dart';

class VideoPlayScreen extends StatefulWidget {
  final int index;
  const VideoPlayScreen({super.key, required this.index});

  @override
  State<VideoPlayScreen> createState() => _VideoPlayScreenState();
}

class _VideoPlayScreenState extends State<VideoPlayScreen> {
  late VideoPlayerController _controller;
  DataController dataController = Get.find();
  AdController adController = Get.find();
  bool isPlaying = false;
  bool showVideoControllers = true;
  double sliderValue = 0.0;

  @override
  void initState() {
    try {
      //initializing controller
      _controller = VideoPlayerController.networkUrl(
          Uri.parse(dataController.videoList[widget.index].url))
        ..initialize().then((_) {
          if (mounted) {
            setState(() {});
          }
        }).onError((error, stackTrace) {
          showSnackbar('No Internet', 'Pls, Connect to Internet and Try Again',
              color: Colors.white, horizontalMargin: 50);
        });
      // used to set landscape mode
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

      // used to set full screen mode
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive, overlays: []);

      // listens for every change towards the video
      _controller.addListener(
        () {
          if (mounted) {
            setState(() {
              sliderValue =
                  _controller.value.position.inMilliseconds.toDouble();
            });
          }
        },
      );
      _controller.play();
      if (mounted) {
        setState(() {
          isPlaying = true;
        });
      }
    } catch (error) {
      //print('$error');
    }

    super.initState();
  }

  //this method transform Duration object into readable minute : second format
  String formatDuration(Duration duration) {
    return '${duration.inMinutes.remainder(60).toString().padLeft(2, '0')}:${duration.inSeconds.remainder(60).toString().padLeft(2, '0')}';
  }

  // used to hide all the controller after 5 seconds
  void implementAutoHide() async {
    final timer = Timer(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          showVideoControllers = false;
        });
      }
    });
    if (!timer.isActive) {
      timer.cancel();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    // to set portrait mode
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    // to disable full screen mode
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: []);
    adController.loadAd();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),
      body: Center(
        child: _controller.value.isInitialized
            ? Stack(
                children: [
                  _buildVideoDisplayer(),
                  _buildVideoControllers(),
                  _buildBackButton(),
                ],
              )
            : const SpinKitThreeBounce(
                color: Color(0xFF3498db),
                size: 17,
                duration: Duration(seconds: 2),
              ),
      ),
    );
  }

  //this method display the video
  _buildVideoDisplayer() {
    return InkWell(
      onTap: () {
        setState(() {
          showVideoControllers = !showVideoControllers;
        });
        // used to set full screen mode
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive,
            overlays: []);
        implementAutoHide();
      },
      child: VideoPlayer(_controller),
    );
  }

  // This is where all controllers are build
  _buildVideoControllers() {
    return Positioned(
      bottom: 0,
      child: Visibility(
        visible: showVideoControllers,
        child: SizedBox(
          width: screenWidth(context),
          height: 120,
          child: Column(
            children: [
              // This is the Video Slider
              Slider(
                value: sliderValue,
                onChanged: (value) {
                  if (mounted) {
                    setState(() {
                      sliderValue = value;
                      showVideoControllers = true;
                    });
                  }

                  _controller.seekTo(Duration(milliseconds: value.toInt()));
                },
                min: 0.0,
                max: _controller.value.duration.inMilliseconds.toDouble(),
                activeColor: dataController.backgroundColor,
                inactiveColor: Colors.white.withOpacity(0.4),
              ),
              // This is Play and Pause Button
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    height: 60,
                    width: 60,
                    child: IconButton(
                      onPressed: () {
                        if (isPlaying) {
                          _controller.pause();
                        } else {
                          _controller.play();
                          implementAutoHide();
                        }
                        if (mounted) {
                          setState(() {
                            isPlaying = !isPlaying;
                          });
                        }
                      },
                      icon: Center(
                        child: Icon(
                          isPlaying ? Icons.pause : Icons.play_arrow,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  // This Widget forward the video to 10s
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 1),
                    width: 60,
                    height: 60,
                    child: IconButton(
                        onPressed: () {
                          if (mounted) {
                            setState(() {
                              showVideoControllers = true;
                            });
                          }

                          _controller.seekTo(_controller.value.position +
                              const Duration(seconds: 10));
                        },
                        icon: const Center(
                          child: Icon(
                            Icons.forward_10,
                            size: 30,
                            color: Colors.white,
                          ),
                        )),
                  ),
                  // This one move the video backward 10s
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 1),
                    width: 60,
                    height: 60,
                    child: IconButton(
                        onPressed: () {
                          if (mounted) {
                            setState(() {
                              showVideoControllers = true;
                            });
                          }

                          _controller.seekTo(_controller.value.position -
                              const Duration(seconds: 10));
                        },
                        icon: const Center(
                          child: Icon(
                            Icons.replay_10,
                            size: 30,
                            color: Colors.white,
                          ),
                        )),
                  ),
                  // This Show the video position and duration in second and minute
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: 150,
                    height: 30,
                    child: Center(
                      child: Text(
                        '${formatDuration(_controller.value.position)} / ${formatDuration(_controller.value.duration)}',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              color: Colors.white,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildBackButton() {
    return Positioned(
      top: 10,
      left: 10,
      child: Visibility(
        visible: showVideoControllers,
        child: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
    );
  }
}
