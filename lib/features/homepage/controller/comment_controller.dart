import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'package:youtube/features/homepage/controller/video_controller.dart';
import 'package:youtube/features/homepage/controller/youtube_detail_controller.dart';

import '../../login/controller/auth_controller.dart';

class CommentController extends GetxController {
  
  final Controller = Get.find<YoutubeDetailController>();

  saveComment(String? Text) async {
    print('-----------------');
    VideoController videoController = Get.find(tag: Get.parameters["videoId"]);
    String name = '';
    String image = '';
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.email)
        .get()
        .then((value) async {
      name = value['displayName'];
      image = value['image'];
      await FirebaseFirestore.instance.collection('videocomments').add({
        'name': name,
        'image': image,
        'text': Text,
        'videoid': Controller.playController.initialVideoId
      });
    });

    print('prssed');
  }
}
