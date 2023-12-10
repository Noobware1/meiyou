// ignore_for_file: avoid_init_to_null

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:media_kit/media_kit.dart' as media_kit;
import 'package:media_kit_video/media_kit_video.dart' as vid;
import 'package:meiyou/core/utils/extenstions/context.dart';
import 'package:meiyou/data/models/extracted_video_data.dart';
import 'package:meiyou/data/models/link_and_source.dart';
import 'package:meiyou/domain/entities/extracted_video_data.dart';
import 'package:meiyou/domain/repositories/video_player_repository.dart';
import 'package:meiyou/domain/usecases/plugin_repository_usecases/load_link_and_media_use_case.dart';
import 'package:meiyou/presentation/blocs/current_episode_cubit.dart';
import 'package:meiyou/presentation/blocs/episodes_bloc.dart';
import 'package:meiyou/presentation/blocs/episodes_selector_cubit.dart';
import 'package:meiyou/presentation/blocs/player/selected_video_data.dart';
import 'package:meiyou/presentation/blocs/player/server_and_video_cubit.dart';
import 'package:meiyou/presentation/blocs/pluign_manager_usecase_provider_cubit.dart';
import 'package:meiyou/presentation/blocs/season_cubit.dart';
import 'package:meiyou/presentation/providers/player_provider.dart';
import 'package:meiyou_extenstions/dart_eval/dart_eval_bridge.dart';
import 'package:meiyou_extenstions/extenstions.dart';
import 'package:meiyou_extenstions/models.dart';

class VideoPlayerRepositoryImpl implements VideoPlayerRepository {
  @override
  VideoSource getDefaultQuailty(List<VideoSource> sources) {
    // TODO: implement getDefaultQuailty
    throw UnimplementedError();
  }

  @override
  Subtitle getDefaultSubtitle(List<Subtitle> subtites) {
    // TODO: implement getDefaultSubtitle
    throw UnimplementedError();
  }

  Episode getCurrentEpisode(BuildContext context) {
    return context.bloc<EpisodesCubit>().state[context
        .bloc<EpisodesSelectorCubit>()
        .state]![context.bloc<CurrentEpisodeCubit>().state];
  }

  @override
  String? getVideoTitle(BuildContext context) {
    final mediaItem = context.repository<MediaDetails>().mediaItem;
    if (mediaItem is Anime) {
      final episode = getCurrentEpisode(context);
      if (episode.name == context.repository<MediaDetails>().name) {
        return null;
      }
      return 'E${episode.episode} - ${episode.name}';
    } else if (mediaItem is TvSeries) {
      final season = context.bloc<SeasonCubit>().state;
      final episode = getCurrentEpisode(context);

      return '${season.name ?? "S${season.season}"}:E${episode.episode} - ${episode.name ?? "Episode ${episode.episode}"}';
    }
    return null;
  }

  @override
  void changeEpisode(
      {required BuildContext context,
      required Episode episode,
      required int index}) {
    if (context
            .bloc<EpisodesCubit>()
            .state[context.bloc<EpisodesSelectorCubit>().state]![index] ==
        getCurrentEpisode(context)) return;

    context.bloc<CurrentEpisodeCubit>().changeEpisode(index);
    context.bloc<SelectedVideoDataCubit>().resetState();

    context.bloc<ExtractedVideoDataCubit>().initStream(context
        .bloc<PluginRepositoryUseCaseProviderCubit>()
        .state
        .provider!
        .loadLinkAndMediaStreamUseCase(
          LoadLinkAndMediaStreamUseCaseParams(episode.data),
        ));

    loadPlayer(
        context: context,
        player: playerProvider(context).player,
        videoController: playerProvider(context).controller);

    context.pop();
  }

  @override
  void loadPlayer(
      {required BuildContext context,
      required media_kit.Player player,
      required vid.VideoController videoController,
      Duration? startPostion,
      void Function()? onDoneCallback}) async {
    final selectedVideoDataCubit = context.bloc<SelectedVideoDataCubit>();
    late StreamSubscription? subscription;
    (int, Video, int)? best = null;
    subscription =
        context.bloc<ExtractedVideoDataCubit>().stream.listen((state) async {
      if (state.data.isNotEmpty) {
        best = _getBestVideoSource(state);
        selectedVideoDataCubit.setStateByIndexes(best!.$1, best!.$3);
        subscription?.cancel();
        subscription = null;

        await changeSource(
            video: best!.$2, selectedSource: best!.$3, player: player);
        onDoneCallback?.call();
      }
    }, onDone: () {
      context.bloc<ExtractedVideoDataCubit>().state.data.isEmpty;
      throw Exception('No video sources found');
    });

    return;
  }

  Future<void> _startFrom(Duration? duration, media_kit.Player player) async {
    if (duration == null) {
      player.play();
      return;
    }
    await player.stream.duration.first;
    await player.seek(duration);
    await player.play();
  }

  (int, Video, int) _getBestVideoSource(ExtractedVideoDataState state) {
    final e = state.data.first;
    return (
      state.data.indexOf(e),
      e.video,
      e.video.videoSources.indexOf(e.video.videoSources
              .tryfirstWhere((it) => it.quality == VideoQuality.hlsMaster) ??
          e.video.videoSources.reduce((high, low) =>
              (high.quality?.height ?? 0) > (low.quality?.height ?? 0)
                  ? high
                  : low))
    );
  }

  @override
  Future<void> changeSource(
      {required Video video,
      required int selectedSource,
      required media_kit.Player player,
      Duration? startPostion}) async {
    await player.open(media_kit.Media(video.videoSources[selectedSource].url,
        httpHeaders: video.headers));
    await player.setVideoTrack(media_kit.VideoTrack.auto());
    if (startPostion != null) await _startFrom(startPostion, player);
  
  }

  @override
  List<LinkAndSource> convertExtractedVideoDataList(
      List<ExtractedVideoDataEntity> data) {
    return data
        .mapAsList((it) => LinkAndSource.fromExtractedVideoData(
            ExtractedVideoData.fromEntity(it)))
        .faltten();
  }
}
