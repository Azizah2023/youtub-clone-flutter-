// import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube/features/homepage/view/widgets/custom_appbar.dart';
import 'package:youtube/features/homepage/view/widgets/video_widget.dart';
import 'package:youtube/features/homepage/controller/home_controller.dart';
import 'package:youtube/features/login/controller/auth_controller.dart';

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
                            controller.AddtoFireBase(controller
                                .youtubeResult.value.items![index].id?.videoId);

                            //page route
                            Get.toNamed(
                                "/detail/${controller.youtubeResult.value.items![index].id?.videoId}");
                          },
                          child: VideoWidget(
                              video: controller
                                  .youtubeResult.value.items![index]));
                    },
                    childCount: controller.youtubeResult.value.items == null
                        ? 0
                        : controller.youtubeResult.value.items?.length,
                  ),
                )
              ],
            ),
            controller.isLoadingMore || controller.isLoding
                ? Stack(
                    children: [
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: CircularProgressIndicator()),
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
}
