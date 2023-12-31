// ignore_for_file: avoid_init_to_null

import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:media_kit/media_kit.dart' as media_kit;
import 'package:media_kit_video/media_kit_video.dart' as vid;
import 'package:meiyou/core/client.dart';
import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/core/resources/subtitle_decoders/exceptions/subtitle_parsing_expection.dart';
import 'package:meiyou/core/resources/subtitle_decoders/models/cue.dart';
import 'package:meiyou/core/resources/subtitle_decoders/parser/subrip_parser.dart';
import 'package:meiyou/core/resources/subtitle_decoders/parser/webvtt_parser.dart';
import 'package:meiyou/core/resources/subtitle_decoders/subtitle_parser.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';
import 'package:meiyou/data/models/extracted_media.dart';
import 'package:meiyou/data/models/link_and_source.dart';
import 'package:meiyou/domain/entities/extracted_media.dart';
import 'package:meiyou/domain/repositories/video_player_repository.dart';
import 'package:meiyou/domain/usecases/plugin_repository_usecases/load_extracted_media_usecase.dart';
import 'package:meiyou/presentation/blocs/current_episode_cubit.dart';
import 'package:meiyou/presentation/blocs/episodes_bloc.dart';
import 'package:meiyou/presentation/blocs/episodes_selector_cubit.dart';
import 'package:meiyou/presentation/blocs/player/playing_cubit.dart';
import 'package:meiyou/presentation/blocs/player/selected_video_data.dart';
import 'package:meiyou/presentation/blocs/player/server_and_video_cubit.dart';
import 'package:meiyou/presentation/blocs/player/subtitle_cubit.dart';
import 'package:meiyou/presentation/blocs/pluign_manager_usecase_provider_cubit.dart';
import 'package:meiyou/presentation/blocs/season_cubit.dart';
import 'package:meiyou/presentation/providers/player_provider.dart';
import 'package:meiyou/presentation/providers/player_providers.dart';
import 'package:meiyou_extensions_lib/extenstions.dart';
import 'package:meiyou_extensions_lib/models.dart';

class VideoPlayerRepositoryImpl implements VideoPlayerRepository {
  @override
  VideoSource getDefaultQuailty(List<VideoSource> sources) {
    // TODO: implement getDefaultQuailty
    throw UnimplementedError();
  }

  @override
  Subtitle getDefaultSubtitle(List<Subtitle> subtites) {
    assert(subtites.isNotEmpty);
    return subtites.tryfirstWhere(
            (e) => e.language.toString().toLowerCase().contains('en')) ??
        subtites.first;
  }

  @override
  Future<ResponseState<List<SubtitleCue>>> getSubtitleCues(Subtitle subtitle) {
    return ResponseState.tryWithAsync(() async {
      final String subtitleData = utf8.decode(
          (await client.get(subtitle.url, headers: subtitle.headers))
              .bodyBytes);

      final SubtitleParser parser;
      switch (subtitle.format) {
        case SubtitleFormat.vtt:
          parser = WebVttParser();
          break;
        case SubtitleFormat.srt:
          parser = SubripParser();
          break;
        default:
          throw SubtitleParsingException(
              'Cannot find parser for format ${subtitle.format}');
      }

      return parser.parse(subtitleData);
    });
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
      return 'E${episode.episode} - ${episode.name ?? 'Episode ${episode.episode}'}';
    } else if (mediaItem is TvSeries) {
      final season = context.bloc<SeasonCubit>().state;
      final episode = getCurrentEpisode(context);

      return '${season.name ?? "S${season.season}"}:E${episode.episode} - ${episode.name ?? "Episode ${episode.episode}"}';
    }
    return null;
  }

  @override
  void changeEpisode({
    required BuildContext context,
    required Episode episode,
    required int index,
  }) {
    final isPlaying = context.bloc<PlayingCubit>().state;
    playerProvider(context).player.stop().then((value) {
      if (context
              .bloc<EpisodesCubit>()
              .state[context.bloc<EpisodesSelectorCubit>().state]![index] ==
          getCurrentEpisode(context)) return null;

      context.bloc<CurrentEpisodeCubit>().changeEpisode(index);
      context.bloc<SelectedVideoDataCubit>().resetState();

      context.bloc<ExtractedMediaCubit<Video>>().initStream(context
          .bloc<PluginRepositoryUseCaseProviderCubit>()
          .state
          .provider!
          .loadExtractedMediaStreamUseCase(
            LoadExtractedMediaStreamUseCaseParams(episode.data),
          ));

      return loadPlayer(
          extractedMediaCubit: context.bloc<ExtractedMediaCubit<Video>>(),
          selectedVideoDataCubit: context.bloc<SelectedVideoDataCubit>(),
          player: playerProvider(context).player,
          videoController: playerProvider(context).controller,
          providers: PlayerProviders.getFromContext(context),
          onDoneCallback: () {
            if (isPlaying) playerProvider(context).player.play();
          });
    });
  }

  @override
  StreamSubscription loadPlayer(
      {required ExtractedMediaCubit<Video> extractedMediaCubit,
      required SelectedVideoDataCubit selectedVideoDataCubit,
      required PlayerProviders providers,
      required media_kit.Player player,
      required vid.VideoController videoController,
      Duration? startPostion,
      void Function()? onDoneCallback}) {
    late StreamSubscription? subscription;
    (int, Video, int)? best = null;

    subscription = extractedMediaCubit.stream.listen((state) async {
      if (state.data.isNotEmpty) {
        subscription?.pause();
        best = _getBestVideoSource(state);

        selectedVideoDataCubit.setStateByIndexes(best!.$1, best!.$3);

        await changeSource(
          video: best!.$2,
          selectedSource: best!.$3,
          startPostion: startPostion,
          player: player,
          subtitleCubit: providers.subtitleCubit,
        );

        subscription?.cancel();
        subscription = null;

        onDoneCallback?.call();
      }
    }, onDone: () {
      subscription?.cancel();
    });

    return subscription!;
  }

  Future<void> _startFrom(Duration? duration, media_kit.Player player) async {
    if (duration == null) {
      return;
    }
    await player.stream.duration.first;
    await player.seek(duration);
  }

  (int, Video, int) _getBestVideoSource(ExtractedMediaState state) {
    final e = state.data.first;

    return (
      state.data.indexOf(e),
      (e.media as Video),
      (e.media as Video).videoSources.indexOf((e.media as Video)
              .videoSources
              .tryfirstWhere((it) => it.quality == VideoQuality.hlsMaster) ??
          (e.media as Video).videoSources.reduce((high, low) =>
              (high.quality?.height ?? 0) > (low.quality?.height ?? 0)
                  ? high
                  : low))
    );
  }

  @override
  Future<void> changeSource({
    required Video video,
    required int selectedSource,
    required media_kit.Player player,
    required SubtitleCubit subtitleCubit,
    Duration? startPostion,
  }) async {
    await player.open(
      media_kit.Media(video.videoSources[selectedSource].url,
          httpHeaders: video.headers),
      play: false,
    );
    await player.setVideoTrack(media_kit.VideoTrack.auto());
    await player.setAudioTrack(media_kit.AudioTrack.auto());
    if (video.subtitles.isNotNullAndEmpty) {
      subtitleCubit.addSubtitles(video.subtitles);
      subtitleCubit.changeSubtitle(getDefaultSubtitle(video.subtitles!));
    }

    await player.setSubtitleTrack(media_kit.SubtitleTrack.no());

    if (startPostion != null) await _startFrom(startPostion, player);
  }

  @override
  List<LinkAndSource> convertExtractedVideoDataList(
      List<ExtractedMediaEntity> data) {
    return data
        .mapAsList((it) =>
            LinkAndSource.fromExtractedVideoData(ExtractedMedia.fromEntity(it)))
        .faltten();
  }
}
