// import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube/Home/components/custom_appbar.dart';
import 'package:youtube/Home/components/video_widget.dart';
import 'package:youtube/Home/controller/home_controller.dart';
import 'package:youtube/login/controller/auth_controller.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final HomeController controller = Get.put(HomeController());
  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(
        () => Stack(
          children: [
            CustomScrollView(
              controller: controller.scrollController,
              slivers: [
                SliverAppBar(
                  backgroundColor: Colors.white,
                  title: CustomAppBar(),
                  floating: true,
                  snap: true,
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return GestureDetector(
                        onTap: () {
                          AddtoFireBase(controller
                              .youtubeResult.value.items![index].id?.videoId);

                          //page route
                          Get.toNamed(
                              "/detail/${controller.youtubeResult.value.items![index].id?.videoId}");
                        },
                        child: VideoWidget(
                            video:
                                controller.youtubeResult.value.items![index]),
                      );
                    },
                    childCount: controller.youtubeResult.value.items == null
                        ? 0
                        : controller.youtubeResult.value.items?.length,
                  ),
                )
              ],
            ),
            controller.isLoadingMore
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                    ],
                  )
                : Container(
                    child: Text(""),
                  )
          ],
        ),
      ),
    );
  }

  // sve video to firebase
  void AddtoFireBase(String? videoId) async {
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
}
