import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:youtube/routes.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key}) ;

  Widget _logo() {
    return Container(
      child: Image.asset(
        "assets/images/youtube.png",height: 50,
        width: 70,
      ),
    );
  }

  Widget _actions() {
    return Row(
      children: [
        GestureDetector(
          onTap: () {},
          child: Container(
            width: 23,
            height: 23,
            child: SvgPicture.asset("assets/svg/icons/bell.svg"),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GestureDetector(
            onTap: () {
              Get.toNamed("/search");
            },
            child: Container(
              width: 30,
              height: 30,
              child: SvgPicture.asset("assets/svg/icons/search.svg"),
            ),
          ),
        ),
        IconButton(
            onPressed: () {
              FirebaseAuth.instance.currentUser != null ||
                  GetStorage().read<bool>("auth") == true
                  ? Get.toNamed(Routes.profileScreen)
                  :
              Get.toNamed(Routes.loginScreen);


            },
            icon: CircleAvatar(
              backgroundColor: Colors.grey,
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _logo(),
            _actions(),
          ],
        ));
  }
}