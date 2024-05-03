import 'dart:async';

import 'package:async/async.dart';
import 'package:collection/collection.dart';

import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart' hide Video;

import 'package:injecktor/injecktor.dart';
import 'package:meiyou/core/utils/resources/combine_stream.dart';
import 'package:meiyou/data/repositories/helpers/content_data_loader.dart';
import 'package:meiyou/presentation/common/cubits/link_and_data_cubit.dart';
import 'package:meiyou/presentation/home/source_selector/selected_source.dart';
import 'package:meiyou/presentation/info/services/episode_cubit.dart';
import 'package:meiyou/presentation/info/services/info_screen_cubit.dart';
import 'package:meiyou/presentation/player/cubits/player_cubit.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:nice_dart/nice_dart.dart';

extension on Content {
  bool get isEpisodic => this is Anime || this is Series;
}

class PlayerRepository {
  final ContentDataLoader<Video> _contentDataLoader =
      ContentDataLoader<Video>();

  InfoPage get _infoPage => InjectKtor.get<InfoScreenCubit>().state.value!;

  final SelectedSource _selectedSource = InjectKtor.get();

  CancelableCompleter<void>? _completer;

  Future<void> loadPlayer({
    required void Function() onReady,
    required void Function(Exception) onError,
  }) async {
    try {
      try {
        await _completer?.operation.cancel();
      } catch (_) {}

      await InjectKtor.player.stop();

      _completer = CancelableCompleter();
      final url = _infoPage.content!.isMovie
          ? (_infoPage.content as Movie).url
          : InjectKtor.get<EpisodeCubit>().episode(_infoPage.content!).data;

      final LinkAndVideoCubit linkAndDataCubit =
          InjectKtor.get<LinkAndVideoCubit>()
            ..initStream(_contentDataLoader.getContentDataStream(
                _selectedSource.state!, url));

      _completer
          ?.completeOperation(CancelableOperation.fromFuture(run(() async {
        final linkAndData =
            (await linkAndDataCubit.stream.first).linkAndData.first;
        linkAndDataCubit.select(0);
        await open(linkAndData.second, 0, play: false);

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

  Future<void> open(Video video, int index,
      {required bool play, Duration? startFrom}) async {
    await InjectKtor.player
        .open(
      video.toMedia(index),
      play: play,
    )
        .then((value) async {
      await InjectKtor.player.setVideoTrack(VideoTrack.auto());
      await InjectKtor.player.setSubtitleTrack(SubtitleTrack.no());

      if (startFrom != null) {
        await InjectKtor.player.stream.duration.first;
        await InjectKtor.player.seek(startFrom);
      }
      // player.setAudioTrack(
      //     player.state.tracks.audio.firstWhere((track) => track.id == '1'));
    });
  }

  void unloadPlayer() {
    if (_completer?.isCompleted == false) {
      _completer?.complete();
    }
    _completer = null;
    _contentDataLoader.clearCache();
  }

  SeekBarState seekBarState() {
    return InjectKtor.get<Player>().let(
      (player) => SeekBarState(
        current: player.state.position,
        buffered: player.state.buffer,
        total: player.state.duration,
      ),
    );
  }

  Stream<SeekBarState> seekBarStateFlow() {
    return InjectKtor.get<Player>().let((it) {
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
      return InjectKtor.get<EpisodeCubit>().hasNext(_infoPage.content!);
    }
    return false;
  }

  void nextEpisode() {
    if (!isNextEpisodeAvailable()) return;
    InjectKtor.get<EpisodeCubit>().next();
    InjectKtor.get<PlayerCubit>().load();
  }

  void playEpisode() {
    InjectKtor.get<PlayerCubit>().load();
  }

  bool isPreviousEpisodeAvailable() {
    if (_infoPage.content!.isEpisodic) {
      return InjectKtor.get<EpisodeCubit>().hasPrevious();
    }
    return false;
  }

  void previousEpisode() {
    if (!isPreviousEpisodeAvailable()) return;
    InjectKtor.get<EpisodeCubit>().previous();
    InjectKtor.get<PlayerCubit>().load();
  }

  Future<void> playOrPause() {
    return InjectKtor.player.playOrPause();
  }

  Future<void> play() {
    return InjectKtor.player.play();
  }

  Future<void> pause() {
    return InjectKtor.player.pause();
  }

  bool isPlaying() {
    return InjectKtor.player.state.playing;
  }

  Stream<bool> isPlayingStream() {
    return InjectKtor.player.stream.playing;
  }

  bool isBuffering() {
    return InjectKtor.player.state.buffering;
  }

  Stream<bool> isBufferingStream() {
    return InjectKtor.player.stream.buffering;
  }

  List<VideoTrack> videoTracks() {
    return [
      VideoTrack.auto(),
      ...InjectKtor.player.state.tracks.video.sublist(2)
    ].toList();
  }

  VideoTrack selectedVideoTrack() {
    return InjectKtor.player.state.track.video;
  }

  Future<void> setVideoTrack(VideoTrack videoTrack) async {
    if (videoTrack.id == selectedVideoTrack().id) return;
    return await InjectKtor.player.setVideoTrack(videoTrack);
  }

  List<SubtitleTrack> subtitleTracks() {
    return InjectKtor.player.state.tracks.subtitle.sublist(1);
  }

  SubtitleTrack selectedSubtitleTrack() {
    return InjectKtor.player.state.track.subtitle;
  }

  Future<void> setSubtitleTrack(SubtitleTrack subtitleTrack) async {
    if (subtitleTrack.id == selectedSubtitleTrack().id) return;

    return await InjectKtor.player.setSubtitleTrack(subtitleTrack);
  }

  List<AudioTrack> audioTracks() {
    return InjectKtor.player.state.tracks.audio.sublist(1);
  }

  AudioTrack selectedAudioTrack() {
    return InjectKtor.player.state.track.audio;
  }

  Future<void> setAudioTrack(AudioTrack audioTrack) async {
    if (audioTrack.id == selectedAudioTrack().id) return;
    return await InjectKtor.player.setAudioTrack(audioTrack);
  }

  Future<void> setVideoSource(int index) async {
    final cubit = InjectKtor.get<LinkAndVideoCubit>();
    final videoSource = cubit.state.linkAndData
        .map((e) => e.second.sources)
        .flattened
        .toList()[index];

    final video = cubit.state.linkAndData
        .firstWhere((element) => element.second.sources.contains(videoSource))
        .second;

    await InjectKtor.player.stop();
    cubit.select(index);
    await open(
      video,
      index,
      play: InjectKtor.player.state.playing,
      startFrom: InjectKtor.player.state.position,
    );
  }

  Future<void> seek(Duration duration) {
    return InjectKtor.player.seek(duration);
  }

  Future<void> skip(int seconds) {
    return InjectKtor.player.seek(
      InjectKtor.player.state.position + Duration(seconds: seconds),
    );
  }

  // Future<void> setSubtitle(Subtitle subtitle) {
  //   return InjectKtor.player.setSubtitle(subtitle);
  // }

  // Future<void> setSpeed(double speed) {
  //   return InjectKtor.player.setSpeed(speed);
  // }

  // Future<void> setVolume(double volume) {
  //   return InjectKtor.player.setVolume(volume);
  // }
}

extension on InjectKtorInterface {
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
