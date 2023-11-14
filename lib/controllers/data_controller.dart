import 'dart:convert' show jsonDecode, jsonEncode;

import 'package:flutter/material.dart' show Color, Colors;
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utilities/snack_bar.dart';
import '../models/video_model.dart';

class DataController extends GetxController {
  List<Video> videoList = [];
  Color backgroundColor = Colors.blue;

  // this method initialize all Video object
  _initVideos(List videos) {
    String imageNotFoundUrl =
        'https://static.vecteezy.com/system/resources/previews/005/337/799/original/icon-image-not-found-free-vector.jpg';
    for (var video in videos) {
      videoList.add(
        Video(
          title: video['videoTitle'],
          thumbnail: video['videoThumbnail'].toString().isEmpty
              ? imageNotFoundUrl
              : video['videoThumbnail'],
          description: video['videoDescription'] ?? '',
          url: video['videoUrl'],
        ),
      );
    }
  }

  //this method convets hex color value to real Color object
  Color _hexToColor(String hex) {
    final buffer = StringBuffer();
    buffer.write(hex.replaceFirst('#', ''));
    return Color(int.parse('FF$buffer', radix: 16));
  }

  // this method is used to save fetched data to local storage
  _saveTodLocalStorage(List videoList, String backgroundColor) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString('videoList', jsonEncode(videoList));
    await pref.setString('backgroundColor', backgroundColor);
  }

  // This method checks whether fetching is successful or not
  Future<bool> isFetchingSuccessful() async {
    try {
      var pref = await SharedPreferences.getInstance();
      // here it checks whether the data is stored locally or not
      if (pref.containsKey('videoList') == true) {
        List videos = jsonDecode(pref.getString('videoList')!);
        String backgroundColorHex = pref.getString('backgroundColor')!;
        _initVideos(videos);
        backgroundColor = _hexToColor(backgroundColorHex);
        return true;
      } else {
        // checking the app internet connectivity
        final connectivityResult = await Connectivity().checkConnectivity();
        if (connectivityResult == ConnectivityResult.mobile ||
            connectivityResult == ConnectivityResult.wifi ||
            connectivityResult == ConnectivityResult.ethernet) {
          // fetching data
          final response =
              await http.get(Uri.parse('https://app.et/devtest/list.json'));
          if (response.statusCode == 200 || response.statusCode == 201) {
            Map<String, dynamic> data = jsonDecode(response.body);
            backgroundColor = _hexToColor(data['appBackgroundHexColor']);

            _initVideos(data['videos']);
            _saveTodLocalStorage(data['videos'], data['appBackgroundHexColor']);
            return true;
          } else {
            showSnackbar(
                'Failed', 'Unable to fetch data from the server, Try Again');
          }
        } else {
          showSnackbar('No Internet Connection',
              'Pls Connect to Internet, and Try Again!');
        }
      }
    } catch (error) {
      showSnackbar('Failed', '$error');
    }
    return false;
  }
}
