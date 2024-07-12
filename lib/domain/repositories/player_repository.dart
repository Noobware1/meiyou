import 'dart:async';
import 'dart:math';

import 'package:async/async.dart';
import 'package:collection/collection.dart';
import 'package:get_it/get_it.dart';

import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart' hide Video;
import 'package:media_kit_video/media_kit_video_controls/src/controls/extensions/duration.dart';
import 'package:meiyou/core/utils/extensions/iterable.dart';

import 'package:meiyou/core/utils/resources/combine_stream.dart';
import 'package:meiyou/core/utils/resources/get_it/get_it.dart';
import 'package:meiyou/data/repositories/helpers/content_data_loader.dart';
import 'package:meiyou/domain/models/history.dart';
import 'package:meiyou/domain/models/p.dart';
import 'package:meiyou/domain/models/progress.dart';
import 'package:meiyou/domain/progress/progress_repository.dart';
import 'package:meiyou/domain/repositories/history_repository.dart';
import 'package:meiyou/domain/library/library_repository.dart';
import 'package:meiyou/extension/models/entension_type.dart';
import 'package:meiyou/presentation/common/notifers/link_and_data_notifer.dart';
import 'package:meiyou/presentation/home/source_selector/selected_source.dart';
import 'package:meiyou/presentation/info/services/episode_notifer.dart';
import 'package:meiyou/presentation/info/services/episode_list_selector.dart';
import 'package:meiyou/presentation/info/services/info_screen_notifer.dart';
import 'package:meiyou/presentation/info/services/season_selector.dart';
import 'package:meiyou/presentation/info/widgets/season_selector.dart';
import 'package:meiyou/presentation/player/notifers/player_state_notifer.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:nice_dart/nice_dart.dart';

extension on Content {
  bool get isEpisodic => this is Anime || this is Series;
}

extension<E> on List<E> {
  E findOrPut(int index, E Function() put) {
    if (index < 0 || index >= length) {
      insert(index, put());
    }
    return this[index];
  }
}

class PlayerRepository {
  static final ContentDataLoader<Video> _contentDataLoader =
      ContentDataLoader<Video>();

  InfoPage get _infoPage => getIt.get<InfoScreenNotifer>().state.value!;

  final SelectedSource _selectedSource = getIt.get();

  CancelableCompleter<void>? _completer;

  Duration? _playFrom() {
    final infoPage = _infoPage;
    final progress = infoPage.getContentProgress();
    if (progress == null) return null;
    return infoPage.content!.when(
        movie: (movie) {
          return progress is! MovieProgress ? null : progress.position;
        },
        series: (series) {
          if (progress is! SeriesProgress) return null;
          final season = getIt.get<SeasonSelectorNotifer>().state;
          final episode = getIt.get<EpisodeNotifer>().state;
          return progress
              .seasonProgress[season].episodeProgress[episode].position;
        },
        anime: (anime) {
          final episode = getIt.get<EpisodeNotifer>().state;
          return progress is! AnimeProgress
              ? null
              : progress.episodeProgress[episode].position;
        },
        lazy: (_) => throw Exception('Not supported'));
  }

  void saveHistory(DateTime lastSeen, String progressString) {
    final historyRepo = getIt.get<HistoryRepository>();

    final history = historyRepo
            .getFromHistory(
              ExtensionType.Video,
              _selectedSource.source!.id,
              _infoPage.name,
            )
            ?.let((it) => it.copyWith(
                  lastSeen: lastSeen,
                  progressString: progressString,
                )) ??
        History(
          title: _infoPage.name,
          poster: _infoPage.posterImage ?? '',
          url: _infoPage.url,
          sourceId: _selectedSource.source!.id,
          type: ExtensionType.Video,
          lastSeen: lastSeen,
          progressString: progressString,
        );

    historyRepo.updateHistory(history);
  }

  void saveProgress() {
    final (position, total) = getIt
        .get<Player>()
        .state
        .let((it) => (it.position.inMilliseconds, it.duration.inMilliseconds));
    final lastSeen = DateTime.now();
    if (position <= 0 || total <= 0) return;

    final progressStr =
        getIt.get<ProgressRepository>().saveProgress(position, total);

    saveHistory(lastSeen, progressStr);
  }

  Future<void> loadPlayer({
    required void Function() onReady,
    required void Function(Exception) onError,
  }) async {
    try {
      try {
        await _completer?.operation.cancel();
      } catch (_) {}

      await getIt.player.stop();

      _completer = CancelableCompleter();
      final url = _infoPage.content!.isMovie
          ? (_infoPage.content as Movie).url
          : getIt.get<EpisodeNotifer>().episode(_infoPage.content!).data;

      final LinkAndVideoNotifer linkAndDataNotifer = getIt
          .get<LinkAndVideoNotifer>()
        ..initStream(_contentDataLoader.getContentDataStream(
            _selectedSource.source!, url));

      _completer
          ?.completeOperation(CancelableOperation.fromFuture(run(() async {
        final linkAndData = (await linkAndDataNotifer.first).linkAndData.first;
        linkAndDataNotifer
          ..select(0)
          ..selectSource(0);
        await open(
            linkAndData.second, linkAndDataNotifer.state.selectedSourceIndex,
            play: false, startFrom: _playFrom());

        onReady.call();
      })));

      return _completer?.operation.value;
    } catch (e) {
      onError(e is Exception ? e : Exception(e.toString()));
      if (!(_completer?.isCompleted ?? true)) {
        _completer?.completeError(e);
      }
    }
  }

  SubtitleTrack _deaultSubtitle(Video video) {
    final subtitles = video.subtitles;
    if (subtitles.isEmptyOrNull) return SubtitleTrack.no();
    return subtitles!
        .firstWhere((element) => element.language?.toLowerCase() == 'english',
            orElse: () => subtitles.first)
        .let((it) => SubtitleTrack.uri(
              it.url,
              language: it.language,
            ));
  }

  Future<void> open(Video video, int index,
      {required bool play, Duration? startFrom}) async {
    await getIt.player.open(
      video.toMedia(index),
      play: play,
    );
    await getIt.player.stream.duration.first;
    await getIt.player.setVideoTrack(VideoTrack.auto());
    await getIt.player.setSubtitleTrack(_deaultSubtitle(video));

    if (startFrom != null) {
      await getIt.player.seek(startFrom);
    }
  }

  void unloadPlayer() {
    if (_completer?.isCompleted == false) {
      _completer?.complete();
    }
    _completer = null;
    _contentDataLoader.clearCache();
  }

  SeekBarState seekBarState() => getIt.get<Player>().let(
        (player) => SeekBarState(
          current: player.state.position,
          buffered: player.state.buffer,
          total: player.state.duration,
        ),
      );

  Stream<SeekBarState> seekBarStateFlow() {
    return getIt.get<Player>().let((it) {
      return CombineStream.combine3(
        it.stream.position,
        it.stream.buffer,
        it.stream.duration,
        (a, b, c) => SeekBarState(
          current: a,
          buffered: b,
          total: c,
        ),
        initalDataA: it.state.position,
        initalDataB: it.state.buffer,
        initalDataC: it.state.duration,
      );
    });
  }

  bool isNextEpisodeAvailable() {
    if (_infoPage.content!.isEpisodic) {
      return getIt.get<EpisodeNotifer>().hasNext(_infoPage.content!);
    }
    return false;
  }

  void nextEpisode() {
    if (!isNextEpisodeAvailable()) return;
    getIt.get<EpisodeNotifer>().next();
    getIt.get<PlayerStateNotifer>().load();
  }

  void playEpisode() {
    getIt.get<PlayerStateNotifer>().load();
  }

  bool isPreviousEpisodeAvailable() {
    if (_infoPage.content!.isEpisodic) {
      return getIt.get<EpisodeNotifer>().hasPrevious();
    }
    return false;
  }

  void previousEpisode() {
    if (!isPreviousEpisodeAvailable()) return;
    getIt.get<EpisodeNotifer>().previous();
    getIt.get<PlayerStateNotifer>().load();
  }

  Future<void> playOrPause() {
    return getIt.player.playOrPause();
  }

  Future<void> play() {
    return getIt.player.play();
  }

  Future<void> pause() {
    return getIt.player.pause();
  }

  bool isPlaying() {
    return getIt.player.state.playing;
  }

  Stream<bool> isPlayingStream() {
    return getIt.player.stream.playing;
  }

  bool isBuffering() {
    return getIt.player.state.buffering;
  }

  Stream<bool> isBufferingStream() {
    return getIt.player.stream.buffering;
  }

  List<VideoTrack> videoTracks() {
    return [VideoTrack.auto(), ...getIt.player.state.tracks.video.sublist(2)]
        .toList();
  }

  VideoTrack selectedVideoTrack() {
    return getIt.player.state.track.video;
  }

  Future<void> setVideoTrack(VideoTrack videoTrack) async {
    if (videoTrack.id == selectedVideoTrack().id) return;
    return await getIt.player.setVideoTrack(videoTrack);
  }

  List<SubtitleTrack> subtitleTracks() {
    return [
      SubtitleTrack.no(),
      ...?getIt
          .get<LinkAndVideoNotifer>()
          .state
          .data
          .subtitles
          ?.map((e) => SubtitleTrack.uri(
                e.url,
                language: e.language,
              ))
    ];

    //  ...getIt.get<LinkAndVideoNotifer>().state.linkAndData
  }

  SubtitleTrack selectedSubtitleTrack() {
    return getIt.player.state.track.subtitle;
  }

  Future<void> setSubtitleTrack(SubtitleTrack subtitleTrack) async {
    if (subtitleTrack.id == selectedSubtitleTrack().id) return;

    return await getIt.player.setSubtitleTrack(subtitleTrack);
  }

  List<AudioTrack> audioTracks() {
    return getIt.player.state.tracks.audio.sublist(1);
  }

  AudioTrack selectedAudioTrack() {
    return getIt.player.state.track.audio;
  }

  Future<void> setAudioTrack(AudioTrack audioTrack) async {
    if (audioTrack.id == selectedAudioTrack().id) return;
    return await getIt.player.setAudioTrack(audioTrack);
  }

  Future<void> setVideoSource(VideoSource videoSource) async {
    final notifer = getIt.get<LinkAndVideoNotifer>();

    final videoIndex = notifer.state.linkAndData
        .indexWhere((element) => element.second.sources.contains(videoSource));

    final video = notifer.state.linkAndData[videoIndex].second;

    final index = video.sources.indexOf(videoSource);

    final sourceIndex = video.sources.indexOf(videoSource);

    notifer.select(videoIndex);
    notifer.selectSource(sourceIndex);

    await getIt.player.stop();
    await open(
      video,
      index,
      play: getIt.player.state.playing,
      startFrom: getIt.player.state.position,
    );
  }

  Future<void> _seek(Duration duration) {
    return getIt.player.seek(duration);
  }

  Future<void> fastforward(int seconds) {
    var result = getIt.player.state.position + Duration(seconds: seconds);
    result = result.clamp(
      Duration.zero,
      getIt.player.state.duration,
    );
    return _seek(result);
  }

  Future<void> rewind(int seconds) {
    var result = getIt.player.state.position - Duration(seconds: seconds);
    result = result.clamp(
      Duration.zero,
      getIt.player.state.duration,
    );
    return _seek(result);
  }

  Future<void> skip(int seconds) {
    return getIt.player.seek(
      getIt.player.state.position + Duration(seconds: seconds),
    );
  }

  // Future<void> setSpeed(double speed) {
  //   return getIt.player.setSpeed(speed);
  // }

  // Future<void> setVolume(double volume) {
  //   return getIt.player.setVolume(volume);
  // }
}

extension on GetIt {
  Player get player => get<Player>();
}

class SeekBarState {
  final Duration current;
  final Duration buffered;
  final Duration total;

  const SeekBarState({
    required this.current,
    required this.buffered,
    required this.total,
  });
}

extension on Video {
  Media toMedia(int index) {
    return Media(
      sources[index].url,
      httpHeaders: headers?.toMap().map(
            (key, value) => MapEntry(key, value.first),
          ),
    );
  }
}

extension on VideoTrack {
  Quality toQuality() {
    return Quality(w ?? 0, h ?? 0);
  }
}
