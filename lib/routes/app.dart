import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:youtube/Home/controller/upload_controller.dart';
import 'package:youtube/Home/controller/history_controller.dart';

import 'package:youtube/Home/pages/home.dart';
import 'package:youtube/Home/pages/library.dart';
import 'package:youtube/Home/pages/subsecribtion.dart';

//this app dart contain the bootom navagation bar

class App extends GetView<AppController> {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        switch (RouteName.values[controller.currentIndex.value]) {
          case RouteName.Home:
            return Home();

          case RouteName.Subsecribtion:
            return Subsecribtion(); // rout to subsecribtion page

          case RouteName.Library:
            Get.delete<HistoryController>();
            return Library(); // rout to subsecribtion Library

          case RouteName.Add:
            break;
          case RouteName.Explore:
            // TODO: Handle this case.
            break;
        }
        return Container();
      }),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: controller.currentIndex.value,
          showSelectedLabels: true,
          selectedItemColor: Colors.black,
          onTap: controller.changePageIndex,
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset("assets/svg/icons/home_off.svg"),
              activeIcon: SvgPicture.asset("assets/svg/icons/home_on.svg"),
              label: "home",
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/svg/icons/compass_off.svg",
                width: 22,
              ),
              activeIcon: SvgPicture.asset(
                "assets/svg/icons/compass_on.svg",
                width: 22,
              ),
              label: "explore",
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: SvgPicture.asset(
                  "assets/svg/icons/plus.svg",
                  width: 35,
                ),
              ),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset("assets/svg/icons/subs_off.svg"),
              activeIcon: SvgPicture.asset("assets/svg/icons/subs_on.svg"),
              label: "subsecriabtion",
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset("assets/svg/icons/library_off.svg"),
              activeIcon: SvgPicture.asset("assets/svg/icons/library_on.svg"),
              label: "library",
            ),
          ],
        ),
      ),
    );
  }
}
