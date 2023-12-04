import 'package:flutter/cupertino.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:meiyou/data/models/media/video/subtitle.dart';
import 'package:meiyou/data/models/media/video/video_source.dart';
import 'package:meiyou/data/models/media/video/video.dart' as vid;
import 'package:meiyou/domain/entities/episode.dart';

abstract interface class VideoPlayerRepository {
  Subtitle getDefaultSubtitle(List<Subtitle> subtites);

  VideoSource getDefaultQuailty(List<VideoSource> sources);

  String? getVideoTitle(BuildContext context);

  void loadPlayer({
    required BuildContext context,
    required Player player,
    required VideoController videoController,
    Duration? startPostion,
    void Function()? onDoneCallback,
  });

  Future<void> changeSource(
      {required vid.Video video,
      required int selectedSource,
      required Player player,
      Duration? startPostion});

  void changeEpisode({required BuildContext context, required EpisodeEntity episode, required int index});
}
