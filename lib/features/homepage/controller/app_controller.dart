import 'package:get/get.dart';
import 'package:youtube/features/homepage/view/widgets/youtube_bottom_sheet.dart';

enum RouteName { Home, Explore, Add, Subsecribtion, Library }


//this app controller contain the bootom navagation bar controller

class AppController extends GetxService {
  RxInt currentIndex = 0.obs;

  void changePageIndex(int index) {
    if (RouteName.values[index] == RouteName.Add) {
      // _showBottomSheet();
    } else {
      currentIndex(index);
    }
  }
  //add upload video
  void _showBottomSheet() {
    Get.bottomSheet(YoutubeBottomSheet());
  }
}
