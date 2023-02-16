import 'package:get/get.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/route_manager.dart';
import 'package:youtube/features/homepage/view/screen/app.dart';
import 'package:youtube/features/homepage/view/widgets/youtube_detail.dart';
import 'package:youtube/features/homepage/controller/youtube_detail_controller.dart';
import 'package:youtube/features/homepage/controller/youtube_search_controller.dart';
import 'package:youtube/features/homepage/view/screen/youtube_search.dart';

import 'package:youtube/features/login/screens/forgot_password_screen.dart';
import 'package:youtube/features/login/screens/login_screen.dart';
import 'package:youtube/features/login/screens/setting/edit_profile_screen.dart';
import 'package:youtube/features/login/screens/setting/profile.dart';
import 'package:youtube/features/login/screens/setting/settings_screen.dart';
import 'package:youtube/features/login/screens/signup_screen.dart';

// import 'home/screen/signup_screen.dart';
import '../binding/auth_binding.dart';

class AppRoutes {
  static const login = Routes.loginScreen;

  static final routes = [
    GetPage(
        name: Routes.loginScreen,
        page: () => Login_Screen(),
        binding: AuthBinding()),
    GetPage(
        name: Routes.signScreen,
        page: () => SignUpScreen(),
        binding: AuthBinding()),
    GetPage(
        name: Routes.forgotpasswordScreen,
        page: () => ForgotPasswordScreen(),
        binding: AuthBinding()),
    GetPage(
        name: Routes.profileScreen,
        page: () => ProfileScreen(),
        binding: AuthBinding()),
    GetPage(
        name: Routes.editProfileScreen,
        page: () => EditProfileScreen(),
        binding: AuthBinding()),
    GetPage(
        name: Routes.settingsScreen,
        page: () => SettingScreen(),
        binding: AuthBinding()),

    GetPage(
        name: Routes.mainScreen,
        page: () => App()),

    GetPage(name: "/", page: () => App()),
    GetPage(
      name: "/detail/:videoId",
      page: () => YoutubeDetail(),
      binding: BindingsBuilder(
            () => Get.lazyPut<YoutubeDetailController>(
                () => YoutubeDetailController()),
      ),
    ),
    GetPage(
      name: "/search",
      page: () => YoutubeSearch(),
      binding: BindingsBuilder(
            () => Get.lazyPut<YoutubeSearchController>(
                () => YoutubeSearchController()),
      ),
    )
  ];
}

class Routes {
  static const loginScreen = '/loginScreen';
  static const signScreen = '/signScreen';
  static const forgotpasswordScreen = '/forgotpasswordScreen';
  static const profileScreen = '/profileScreen';
  static const editProfileScreen = '/editProfileScreen';
  static const settingsScreen = '/settingsScreen';
  static const mainScreen='/mainScreen';
}
