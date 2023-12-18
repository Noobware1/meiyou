import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:media_kit/media_kit.dart' as media_kit;
import 'package:media_kit_video/media_kit_video.dart' as vid;
import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/core/resources/subtitle_decoders/models/cue.dart';
import 'package:meiyou/domain/entities/extracted_media.dart';
import 'package:meiyou/domain/entities/link_and_source.dart';
import 'package:meiyou/presentation/blocs/player/selected_video_data.dart';
import 'package:meiyou/presentation/blocs/player/server_and_video_cubit.dart';
import 'package:meiyou/presentation/blocs/player/subtitle_cubit.dart';
import 'package:meiyou/presentation/providers/player_providers.dart';
import 'package:meiyou_extensions_lib/models.dart';

abstract interface class VideoPlayerRepository {
  Subtitle getDefaultSubtitle(List<Subtitle> subtites);

  VideoSource getDefaultQuailty(List<VideoSource> sources);

  String? getVideoTitle(BuildContext context);

  Future<ResponseState<List<SubtitleCue>>> getSubtitleCues(Subtitle subtitle,
      {Map<String, String>? headers});

  // void loadPlayer({
  //   required BuildContext context,
  //   required PlayerProviders providers,
  //   required Player player,
  //   required vid.VideoController videoController,
  //   Duration? startPostion,
  //   void Function()? onDoneCallback,
  // });

  StreamSubscription loadPlayer(
      {required ExtractedMediaCubit<Video> extractedMediaCubit,
      required SelectedVideoDataCubit selectedVideoDataCubit,
      required PlayerProviders providers,
      required media_kit.Player player,
      required vid.VideoController videoController,
      Duration? startPostion,
      void Function()? onDoneCallback});

  Future<void> changeSource(
      {required Video video,
      required int selectedSource,
      required media_kit.Player player,
      required SubtitleCubit subtitleCubit,
      Duration? startPostion});

  void changeEpisode({
    required BuildContext context,
    required Episode episode,
    required int index,
  });

  List<LinkAndSourceEntity> convertExtractedVideoDataList(
      List<ExtractedMediaEntity> data);
}
