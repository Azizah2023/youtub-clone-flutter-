import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube/Home/models/video.dart';
import 'package:youtube/Home/models/youtube_video_result.dart';
import 'package:youtube/Home/repository/youtube_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube/login/controller/auth_controller.dart';

class HistoryController extends GetxController {
  static HistoryController get to => Get.find();
  int nextPageToken = 3;
  List History = [];

  AuthController authController = Get.find<AuthController>();

  ScrollController scrollController = ScrollController();
  // bool isLoadingMore = false;
  Rx<YoutubeVideoResult> youtubeResult = YoutubeVideoResult(items: []).obs;
  late SharedPreferences _profs;
  String key = "searchKey";
  RxList<String> history = RxList<String>.empty(growable: true);

  @override
  void onInit() {
    History.clear();
    _videoHistory();
    _increment();
    // _event();

    super.onInit();
  }

  void _increment() {
    nextPageToken++;
    update();
  }

  void _event() {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        _videoHistory();
        _increment();
      }
    });
  }
  //

  void _videoHistory() async {
    QuerySnapshot<Map<String, dynamic>> userDocHistory =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(authController.displayUserEmail.value)
            .collection('history')
            .orderBy('time', descending: false)
            // .limit(nextPageToken)
            .get();
    for (var i = 0; i < userDocHistory.docs.length; i++) {
      if (History.contains(userDocHistory.docs[i]['videoid'])) {
        print('Already Added');
        print(History);
      } else {
        History.add(userDocHistory.docs[i]['videoid']);
      }
    }

    for (var i = History.length - 1; i >= 0; i--) {
      Video? youtubeVideoResult =
          await YoutubeRepository.to.getVideoByID(History[i]);

      if (youtubeVideoResult != null) {
        youtubeResult.update(
          (youtube) {
            // youtube?.nextPagetoken = youtubeVideoResult.nextPagetoken;
            youtube?.items!.add(youtubeVideoResult);
          },
        );
      }
    }
  }
}
