import 'package:flutter/cupertino.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart' as vid;
import 'package:meiyou_extenstions/models.dart';

abstract interface class VideoPlayerRepository {
  Subtitle getDefaultSubtitle(List<Subtitle> subtites);

  VideoSource getDefaultQuailty(List<VideoSource> sources);

  String? getVideoTitle(BuildContext context);

  void loadPlayer({
    required BuildContext context,
    required Player player,
    required vid.VideoController videoController,
    Duration? startPostion,
    void Function()? onDoneCallback,
  });

  Future<void> changeSource(
      {required Video video,
      required int selectedSource,
      required Player player,
      Duration? startPostion});

  void changeEpisode(
      {required BuildContext context,
      required Episode episode,
      required int index});
}
