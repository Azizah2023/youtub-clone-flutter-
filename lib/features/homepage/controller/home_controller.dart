import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube/common/models/youtube_video_result.dart';
import 'package:youtube/core/repository/youtube_repository.dart';
import 'package:youtube/features/login/controller/auth_controller.dart';

class HomeController extends GetxController {
  final authController = Get.find<AuthController>();
  int nextPageToken = 0;

  ScrollController scrollController = ScrollController();
  bool isLoding = false;
  bool isLoadingMore = false;
  Rx<YoutubeVideoResult> youtubeResult = YoutubeVideoResult(items: []).obs;

  @override
  void onInit() {
    _videoLoad();
    _increment();
    _event();
    super.onInit();
  }

  _increment() {
    nextPageToken++;
    update();
  }

  void _event() {
    scrollController.addListener(() async {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        await _updateIsLoading(false);  // 2

        update();
        print('call');
        await _increment();
        await _videoLoad();

        update();
      } else {
        await _updateIsLoading(true);  // 1

        update();
        print('dont call');
      }
    });
  }

  _videoLoad() async {
    await _updateIsLoading(true); //

    update();
    YoutubeVideoResult? youtubeVideoResult = await YoutubeRepository.to
        .loadVideos(youtubeResult.value.nextPagetoken ?? "");

    if (youtubeVideoResult != null &&
        youtubeVideoResult.items != null &&
        youtubeVideoResult.items!.length > 0) {
      youtubeResult.update((youtube) {
        youtube?.nextPagetoken = youtubeVideoResult.nextPagetoken;
        youtube?.items!.addAll(youtubeVideoResult.items!);
      });
    }
    await _updateIsLoading(false); //

    update();
  }

  AddtoFireBase(String? videoId) async {
    CollectionReference<Map<String, dynamic>> doc = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(authController.displayUserEmail.value)
        .collection('history');
    final cheker = await FirebaseFirestore.instance
        .collection('users')
        .doc(authController.displayUserEmail.value)
        .collection('history')
        .where('videoid', isEqualTo: videoId)
        .get();
    try {
      if (cheker.docs.isEmpty) {
        doc.doc().set({"videoid": videoId, 'time': Timestamp.now()});
      } else {
        return print('video already added to user history');
      }
    } catch (e) {
      print(e);
    }
  }

  _updateIsLoading(bool currentStatus) async { //
    isLoadingMore = currentStatus;
    update();
  }
}
