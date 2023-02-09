import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube/Home/models/youtube_video_result.dart';
import 'package:youtube/Home/repository/youtube_repository.dart';

class HomeController extends GetxController {
  static HomeController get to => Get.find();
  int nextPageToken = 0;

  ScrollController scrollController = ScrollController();
  bool isLoadingMore = false;
  Rx<YoutubeVideoResult> youtubeResult = YoutubeVideoResult(items: []).obs;

  @override
  void onInit() {
    _videoLoad();
    _increment();
    _event();
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
        print('call');
        _videoLoad();
        _increment();
        isLoadingMore = true;
        update();
      } else {
        print('dont call');
        isLoadingMore = false;
        update();
      }
    });
  }

  void _videoLoad() async {
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
  }
}
