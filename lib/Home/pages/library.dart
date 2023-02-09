import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube/Home/components/custom_appbar.dart';
import 'package:youtube/Home/components/video_widget.dart';
import 'package:youtube/Home/controller/history_controller.dart';
import 'package:youtube/Home/controller/home_controller.dart';
import 'package:youtube/Home/controller/youtube_search_controller.dart';
import 'package:youtube/routes.dart';

class Library extends StatelessWidget {
  Library({super.key});

  // final YoutubeSearchController controller = Get.put(YoutubeSearchController());
  HistoryController controller = Get.put(HistoryController());

  @override
  Widget build(BuildContext context) {
    return FirebaseAuth.instance.currentUser != null ||
            GetStorage().read<bool>("auth") == true
        ? SafeArea(
            child: Obx(
              () => CustomScrollView(
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
                            //page route
                            print(controller
                                .youtubeResult.value.items![index].id);
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
                  ),
                ],
              ),
            ),
          )
        : Center(
            child: TextButton(
                onPressed: () {
                  Get.toNamed(Routes.loginScreen);
                },
                child: Text("Please Login")));
  }
}
