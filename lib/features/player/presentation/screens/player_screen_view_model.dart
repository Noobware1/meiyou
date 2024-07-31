import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart' hide Video;
import 'package:meiyou/core/injection/injection.dart';
import 'package:meiyou/core/utils/exceptions/no_asset_exception.dart';
import 'package:meiyou/core/utils/log/logger.dart';
import 'package:meiyou/shared/data/media_asset_loader/media_asset_loader_impl.dart';
import 'package:meiyou/shared/domain/media_asset_loader/media_asset_loader.dart';
import 'package:meiyou/shared/domain/models/extension_category.dart';
import 'package:meiyou/shared/domain/models/link_and_asset.dart';
import 'package:meiyou/shared/domain/models/media_content.dart';
import 'package:meiyou/shared/domain/models/media.dart' as m;
import 'package:meiyou/shared/domain/models/repositories_params/media_content_repository_params.dart';
import 'package:meiyou/shared/domain/models/repositories_params/media_repository_params.dart';
import 'package:meiyou/shared/domain/source_manager/source_manager.dart';
import 'package:meiyou/shared/domain/usecases/media_content_repository_usecases/get_content_by_id_usecase.dart';
import 'package:meiyou/shared/domain/usecases/media_content_repository_usecases/get_content_list_by_media_id_usecase.dart';
import 'package:meiyou/shared/domain/usecases/media_repository_usecases/get_media_by_id_usecase.dart';
import 'package:meiyou/shared/presentation/notifers/state_notifer.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:nice_dart/nice_dart.dart';

typedef LinkAndVideo = LinkAndAsset<Video>;

class PlayerScreenViewModel {
  final MediaAssetLoader<Video> _videoLoader = MediaAssetLoaderImpl<Video>();

  final GetMediaByIdUseCase _getMediaByIdUseCase = getIt.get();
  final SourceManager sourceManager = getIt.get();
  final GetContentByIdUseCase _getContentByIdUseCase = getIt.get();
  final GetContentListByMediaIdUseCase _getContentListByMediaIdUseCase =
      getIt.get();
  final videoKey = GlobalKey<VideoState>();
  late final Player player;
  late final VideoController videoController;
  late final StateNotifier<PlayerScreenState> stateListenable;
  final VoidCallback _exitCallback;

  PlayerScreenViewModel({
    required int mediaId,
    required ExtensionCategory category,
    required int contentId,
    required VoidCallback exitCallback,
  }) : _exitCallback = exitCallback {
    player = Player(
      configuration: const PlayerConfiguration(bufferSize: 32 * 1024 * 1024),
    );
    videoController = VideoController(player);
    _initStateListenable(
        mediaId: mediaId, contentId: contentId, category: category);
    _load(state.content);
  }

  StreamSubscription? _linkAndVideoSubscription;

  PlayerScreenState get state => stateListenable.state;

  final currentVideoNotifer = StateNotifier<int>(0);

  Video get currentVideo =>
      state.linkAndAssets[currentVideoNotifer.state].asset;

  final currentVideoSourceNotifer = StateNotifier<int>(0);

  VideoSource get currentVideoSource =>
      currentVideo.sources[currentVideoSourceNotifer.state];

  VideoTrack get currentVideoTrack => player.state.track.video;

  Stream<List<VideoTrack>> get videoTracksStream => player.stream.tracks
      .map((tracks) => [VideoTrack.auto(), ...tracks.video.sublist(2)]);

  SubtitleTrack get currentSubtitleTrack => player.state.track.subtitle;

  Stream<List<SubtitleTrack>> get subtitleTracksStream => player.stream.tracks
      .map((tracks) => [SubtitleTrack.no(), ...tracks.subtitle.sublist(2)]);

  AudioTrack get currentAudioTrack => player.state.track.audio;

  Stream<List<AudioTrack>> get audioTracksStream => player.stream.tracks
      .map((tracks) => [AudioTrack.auto(), ...tracks.audio.sublist(2)]);

  final playerFitNotifier = StateNotifier<BoxFit>(BoxFit.contain);

  static const _allowedFits = [
    BoxFit.contain,
    BoxFit.cover,
    BoxFit.fill,
  ];

  void changeFit() {
    var index = _allowedFits.indexOf(playerFitNotifier.state);
    index = (index + 1) % _allowedFits.length;
    playerFitNotifier.setState(_allowedFits[index]);
  }

  void setVideoSource(VideoSource source) {
    try {
      final videoIndex = state.linkAndAssets.indexWhere((linkAndAsset) =>
          linkAndAsset.asset.sources
              .any((element) => VideoSourceEquality().equals(element, source)));

      final sourceIndex = state.linkAndAssets[videoIndex].asset.sources
          .indexWhere(
              (element) => VideoSourceEquality().equals(element, source));

      _updateAndOpenVideoSource(
          videoIndex: videoIndex, sourceIndex: sourceIndex);
    } catch (e, s) {
      logger.severe('Error setting video source', e, s);
    }
  }

  void setVideoTrack(VideoTrack track) {
    player.setVideoTrack(track);
  }

  void setSubtitleTrack(SubtitleTrack track) {
    player.setSubtitleTrack(track);
  }

  void setAudioTrack(AudioTrack track) {
    player.setAudioTrack(track);
  }

  void seek(Duration duration) {
    player.seek(duration);
  }

  void _load(MediaContent content) {
    bool isFirst = true;
    _linkAndVideoSubscription =
        _videoLoader.getAssetStream(state.source, content).listen(
            (linkAndAssets) {
              stateListenable.setState(state.copyWith(
                linkAndAssets: linkAndAssets,
                isLoading: false,
              ));
              if (isFirst) {
                isFirst = false;
                _updateAndOpenVideoSource();
              }
            },
            onDone: () {
              _linkAndVideoSubscription?.cancel();
              _linkAndVideoSubscription = null;
            },
            cancelOnError: false,
            onError: (Object error, StackTrace stacktrace) {
              if (error is NoAssetException) {
                _exitCallback.call();
                logger.severe(
                    'No asset found for content: ${content.id}', e, stacktrace);
              } else {
                logger.warning('Error loading asset for content: ${content.id}',
                    e, stacktrace);
              }
            });
  }

  void _updateAndOpenVideoSource({int videoIndex = 0, int sourceIndex = 0}) {
    _setVideoAndSource(videoIndex: videoIndex, sourceIndex: sourceIndex);
    _openCurrentVideoSource();
  }

  void _setVideoAndSource({required int videoIndex, required int sourceIndex}) {
    currentVideoNotifer.setState(videoIndex);
    currentVideoSourceNotifer.setState(sourceIndex);
  }

  Future<void> _openCurrentVideoSource({
    bool autoPlay = true,
    Duration? startFrom,
  }) async {
    final video = currentVideo;

    await player.open(
      video.toPlayableMedia(currentVideoSourceNotifer.state),
      play: autoPlay,
    );
    await player.stream.duration.first;
    await player.setVideoTrack(VideoTrack.auto());
    await player.setSubtitleTrack(_deaultSubtitle(video));

    if (startFrom != null) {
      await player.seek(startFrom);
    }
  }

  SubtitleTrack _deaultSubtitle(Video video) {
    final subtitles = video.subtitles;
    if (subtitles.isEmptyOrNull) return SubtitleTrack.no();
    return subtitles!
        .firstWhere(
            (element) =>
                element.language?.equals('english', ignoreCase: true) ?? false,
            orElse: () => subtitles.first)
        .let((it) => SubtitleTrack.uri(
              it.url,
              language: it.language,
            ));
  }

  void _initStateListenable({
    required int mediaId,
    required int contentId,
    required ExtensionCategory category,
  }) {
    final media = _getMediaByIdUseCase(
        GetMediaByIdParams(id: mediaId, category: category))!;

    final source = sourceManager.getSource(media.sourceId, media.category)!;

    final contentList = _getContentListByMediaIdUseCase(
        GetContentListByMediaIdParams(
            category: media.category, mediaId: mediaId));

    final currentContentIndex =
        contentList.indexWhere((element) => element.id == contentId);

    stateListenable = StateNotifier(PlayerScreenState.inital(
      media: media,
      source: source,
      contentList: contentList,
      currentContentIndex: currentContentIndex,
    ));
  }

  void _releaseCache() {
    _videoLoader.releaseAllCache();
  }

  void dispose() {
    _linkAndVideoSubscription?.cancel();
    _releaseCache();
    stateListenable.dispose();
    currentVideoNotifer.dispose();
    currentVideoSourceNotifer.dispose();
    player.dispose();
  }
}

extension on Video {
  Media toPlayableMedia(int index) {
    return Media(
      sources[index].url,
      extras: extra,
      httpHeaders:
          headers?.toMap().map((key, value) => MapEntry(key, value.join(','))),
    );
  }
}

class VideoSourceEquality {
  bool equals(VideoSource e1, VideoSource e2) {
    return e1.url == e2.url &&
        e1.format == e2.format &&
        e1.quality == e2.quality &&
        e1.isBackup == e2.isBackup &&
        e1.title == e2.title;
  }
}

class PlayerScreenState {
  final bool isLoading;
  final List<LinkAndVideo> linkAndAssets;
  final int currentContentIndex;
  final List<MediaContent> contentList;
  final m.Media media;
  final Source source;

  PlayerScreenState({
    required this.isLoading,
    required this.linkAndAssets,
    required this.contentList,
    required this.currentContentIndex,
    required this.media,
    required this.source,
  });

  PlayerScreenState.inital({
    required this.currentContentIndex,
    required this.contentList,
    required this.media,
    required this.source,
  })  : isLoading = false,
        linkAndAssets = [];

  MediaContent get content => contentList[currentContentIndex];

  PlayerScreenState copyWith({
    bool? isLoading,
    List<LinkAndVideo>? linkAndAssets,
    int? currentContentIndex,
    List<MediaContent>? contentList,
    m.Media? media,
    Source? source,
  }) {
    return PlayerScreenState(
      isLoading: isLoading ?? this.isLoading,
      linkAndAssets: linkAndAssets ?? this.linkAndAssets,
      currentContentIndex: currentContentIndex ?? this.currentContentIndex,
      contentList: contentList ?? this.contentList,
      media: media ?? this.media,
      source: source ?? this.source,
    );
  }
}
