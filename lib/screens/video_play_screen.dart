import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../utilities/media_query.dart';
import '../controllers/data_controller.dart';

class VideoPlayScreen extends StatefulWidget {
  final int index;
  const VideoPlayScreen({super.key, required this.index});

  @override
  State<VideoPlayScreen> createState() => _VideoPlayScreenState();
}

class _VideoPlayScreenState extends State<VideoPlayScreen> {
  late VideoPlayerController _controller;
  DataController dataController = Get.find();
  bool isPlaying = false;
  bool showVideoControllers = true;
  double sliderValue = 0.0;

  @override
  void initState() {
    //initializing controller
    _controller = VideoPlayerController.networkUrl(
        Uri.parse(dataController.videoList[widget.index].url))
      ..initialize().then((_) {
        if (mounted) {
          setState(() {});
        }
      });
    // used to set landscape mode
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    // used to set full screen mode
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive, overlays: []);
    _controller.addListener(() {
      if (mounted) {
        setState(() {
          sliderValue = _controller.value.position.inMilliseconds.toDouble();
        });
      }
    });
    _controller.play();
    if (mounted) {
      setState(() {
        isPlaying = true;
      });
    }

    super.initState();
  }

  //this method transform Duration object into readable minute : second format
  String formatDuration(Duration duration) {
    return '${duration.inMinutes.remainder(60).toString().padLeft(2, '0')}:${duration.inSeconds.remainder(60).toString().padLeft(2, '0')}';
  }

  // used to hide all the controller after 5 seconds
  void implementAutoHide() {
    Timer(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          showVideoControllers = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(),
      body: Center(
        child: _controller.value.isInitialized
            ? Stack(
                children: [
                  InkWell(
                      onTap: () {
                        setState(() {
                          showVideoControllers = !showVideoControllers;
                        });
                        implementAutoHide();
                      },
                      child: VideoPlayer(_controller)),
                  Positioned(
                    bottom: 0,
                    child: Visibility(
                      visible: showVideoControllers,
                      child: SizedBox(
                        width: screenWidth(context),
                        height: 120,
                        child: Column(
                          children: [
                            Slider(
                              value: sliderValue,
                              onChanged: (value) {
                                if (mounted) {
                                  setState(() {
                                    sliderValue = value;
                                    showVideoControllers = true;
                                  });
                                }

                                _controller.seekTo(
                                    Duration(milliseconds: value.toInt()));
                              },
                              min: 0.0,
                              max: _controller.value.duration.inMilliseconds
                                  .toDouble(),
                              activeColor: dataController.backgroundColor,
                              inactiveColor: Colors.white.withOpacity(0.4),
                            ),
                            Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10),
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
                                        isPlaying
                                            ? Icons.pause
                                            : Icons.play_arrow,
                                        size: 40,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 1),
                                  width: 60,
                                  height: 60,
                                  child: IconButton(
                                      onPressed: () {
                                        if (mounted) {
                                          setState(() {
                                            showVideoControllers = true;
                                          });
                                        }

                                        _controller.seekTo(
                                            _controller.value.position +
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
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 1),
                                  width: 60,
                                  height: 60,
                                  child: IconButton(
                                      onPressed: () {
                                        if (mounted) {
                                          setState(() {
                                            showVideoControllers = true;
                                          });
                                        }

                                        _controller.seekTo(
                                            _controller.value.position -
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
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  width: 150,
                                  height: 30,
                                  child: Center(
                                    child: Text(
                                      '${formatDuration(_controller.value.position)} / ${formatDuration(_controller.value.duration)}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(
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
                  ),
                  Positioned(
                      top: 5,
                      left: 5,
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
                      ))
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
}
