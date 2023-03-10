import 'package:get/get.dart';
import 'package:youtube/common/models/statistics.dart';
import 'package:youtube/common/models/video.dart';
import 'package:youtube/common/models/youtuber.dart';
import 'package:youtube/core/repository/youtube_repository.dart';

class VideoController extends GetxController {
  Video video;
  VideoController({required this.video});
  Rx<Statistics> statistics = Statistics().obs;
  Rx<Youtuber> youtuber = Youtuber().obs;
  @override
  void onInit() async {
    Statistics? loadStatistics =
        await YoutubeRepository.to.getVideoInfoById(video.id!.videoId!);
    statistics(loadStatistics);
    Youtuber? loadYoutuber = await YoutubeRepository.to
        .getYoutuberInfoById(video.snippet!.channelId!);
    youtuber(loadYoutuber);
    super.onInit();
  }

  String get viewCountString => "Views ${statistics.value.viewCount ?? '-'}";
  String get youtuberThumbnailUrl {
    if (youtuber.value.snippet == null)
      return "https://via.placeholder.com/150";
    return youtuber.value.snippet!.thumbnails!.medium!.url!;
  }
}
