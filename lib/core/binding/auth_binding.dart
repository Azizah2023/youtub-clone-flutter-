import 'package:youtube/features/homepage/controller/app_controller.dart';
import 'package:youtube/core/repository/youtube_repository.dart';
import 'package:youtube/features/login/controller/auth_controller.dart';
import 'package:youtube/features/login/controller/setting_controller.dart';
import 'package:get/get.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController());

    Get.put(YoutubeRepository(), permanent: true); //api
    Get.put(AppController());
  }
}
