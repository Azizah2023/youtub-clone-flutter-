import 'package:get/get.dart';
import 'package:youtube/Home/controller/upload_controller.dart';
import 'package:youtube/Home/repository/youtube_repository.dart';

class InitBinding implements Bindings {
  @override
  void dependencies() {

    Get.put(YoutubeRepository(), permanent: true);
    Get.put(AppController());
  }
}
