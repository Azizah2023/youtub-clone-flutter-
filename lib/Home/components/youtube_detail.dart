import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:youtube/Home/controller/video_controller.dart';
import 'package:youtube/Home/controller/youtube_detail_controller.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubeDetail extends GetView<YoutubeDetailController> {
  TextEditingController commint = new TextEditingController();
  YoutubeDetail({super.key});

  Widget _titleZone() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  controller.video.value.snippet!.title!,
                  style: TextStyle(fontSize: 15, color: Colors.amber),
                ),
                Row(
                  children: [
                    Text(
                      "Views ${controller.statistics.value.viewCount ?? '-'}",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.red.withOpacity(0.5),
                      ),
                    ),
                    Text(" · "),
                    Text(
                      DateFormat("yyyy-MM-dd")
                          .format(controller.video.value.snippet!.publishTime!),
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        // showcomment(),
      ],
    );
  }

  Widget _descriptionZone() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Obx(
        () => Text(
          controller.video.value.snippet!.description!,
          style: TextStyle(
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buttonOne(String iconPath, String text) {
    return Column(
      children: [
        SvgPicture.asset("assets/svg/icons/$iconPath.svg"),
        Text(text)
      ],
    );
  }

  Widget _buttonZone() {
    return Obx(
      () => Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buttonOne(
                  "like", controller.statistics.value.likeCount.toString()),
              _buttonOne("dislike",
                  controller.statistics.value.dislikeCount.toString()),
              _buttonOne("share", "share"),
              _buttonOne("save", "save"),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              children: [
                new Card(
                  color: Colors.grey[200],
                  child: new Container(
                    padding: EdgeInsets.all(10.0),
                    child: new Column(
                      children: <Widget>[
                        new Row(
                          children: <Widget>[
                            new Expanded(
                                child: new Text(
                              "Comment",
                            )),
                            new Expanded(
                              child: TextFormField(
                                controller: commint,
                                decoration:
                                    InputDecoration(hintText: "commint"),
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  saveComment();
                                },
                                icon: Icon(Icons.send))
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                showcomment(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  saveComment() async {
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
        'text': commint.text,
        'videoid': controller.playController.initialVideoId
      });
    });

    print('prssed');
  }

  Widget showcomment() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('videocomments')
          .where('videoid', isEqualTo: controller.playController.initialVideoId)
          .snapshots(),
      builder: (ctx, snapshot) {
        if (snapshot.hasData) {
          return Container(
            width: 400,
            height: 150,
            child: ListView.separated(
              shrinkWrap: true,
              separatorBuilder: (context, index) =>
                  Divider(color: Colors.black),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 30),
                            child: CircleAvatar(),
                          ),
                          Text('name:'),
                          Text(snapshot.data!.docs[index]['name'])
                        ],
                      ),
                      Row(
                        children: [Text(snapshot.data!.docs[index]['text'])],
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        } else {
          return SizedBox();
        }
      },
    );
  }

  Widget get line => Container(
        height: 1,
        color: Colors.black.withOpacity(0.1),
      );

  Widget _ownerZone() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: GetBuilder<YoutubeDetailController>(builder: (controller) {
        return Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey.withOpacity(0.5),
              backgroundImage: Image.network(controller
                      .youtuber.value.snippet!.thumbnails!.medium!.url!)
                  .image,
            ),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    controller.youtuber.value.snippet!.title!,
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    "  ${controller.youtuber.value.statistics!.subscriberCount}",
                    style: TextStyle(
                        fontSize: 14, color: Colors.black.withOpacity(0.6)),
                  ),
                ],
              ),
            ),
            GestureDetector(
              child: Text(
                "",
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            )
          ],
        );
      }),
    );
  }

  Widget _description() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _titleZone(),
          line,
          _descriptionZone(),
          _buttonZone(),
          SizedBox(height: 20),
          // line,
          // _ownerZone()
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black38,
      ),
      body: Column(
        children: [
          YoutubePlayer(
            controller: controller.playController,
            showVideoProgressIndicator: true,
            progressIndicatorColor: Colors.blueAccent,
            topActions: <Widget>[
              const SizedBox(width: 8.0),
              Expanded(
                child: Text(
                  controller.playController.metadata.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.settings,
                  color: Colors.white,
                  size: 25.0,
                ),
                onPressed: () {},
              ),
            ],
            onReady: () {},
            onEnded: (data) {},
          ),
          Expanded(
            child: _description(),
          )
        ],
      ),
    );
  }
}
