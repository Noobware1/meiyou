import 'package:flutter/cupertino.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart' as vid;
import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/core/resources/subtitle_decoders/models/cue.dart';
import 'package:meiyou/domain/entities/extracted_video_data.dart';
import 'package:meiyou/domain/entities/link_and_source.dart';
import 'package:meiyou/presentation/blocs/player/subtitle_cubit.dart';
import 'package:meiyou/presentation/providers/player_providers.dart';
import 'package:meiyou_extenstions/models.dart';

abstract interface class VideoPlayerRepository {
  Subtitle getDefaultSubtitle(List<Subtitle> subtites);

  VideoSource getDefaultQuailty(List<VideoSource> sources);

  String? getVideoTitle(BuildContext context);

  Future<ResponseState<List<SubtitleCue>>> getSubtitleCues(Subtitle subtitle,
      {Map<String, String>? headers});

  void loadPlayer({
    required BuildContext context,
    required PlayerProviders providers,
    required Player player,
    required vid.VideoController videoController,
    Duration? startPostion,
    void Function()? onDoneCallback,
  });

  Future<void> changeSource(
      {required Video video,
      required int selectedSource,
      required Player player,
      required SubtitleCubit subtitleCubit,
      Duration? startPostion});

  void changeEpisode({
    required BuildContext context,
    required Episode episode,
    required int index,
  });

  List<LinkAndSourceEntity> convertExtractedVideoDataList(
      List<ExtractedVideoDataEntity> data);
}
