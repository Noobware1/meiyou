import 'dart:async';
import 'dart:math';

import 'package:async/async.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart' hide Video;
import 'package:media_kit_video/media_kit_video_controls/src/controls/extensions/duration.dart';
import 'package:meiyou/core/helper/media_content_helper.dart';
import 'package:meiyou/core/injection/injection.dart';
import 'package:meiyou/core/utils/exceptions/no_asset_exception.dart';
import 'package:meiyou/core/utils/extensions/context.dart';
import 'package:meiyou/core/utils/log/logger.dart';
import 'package:meiyou/core/utils/stream_utils/comnine_stream.dart';
import 'package:meiyou/core/utils/stream_utils/state_stream.dart';
import 'package:meiyou/features/details/domain/models/content_list_view_type.dart';
import 'package:meiyou/features/player/domain/models/player_seek_bar_state.dart';
import 'package:meiyou/features/player/presentation/widgets/player_video_settings/player_video_settings.dart';
import 'package:meiyou/features/player/presentation/widgets/video_source_selector/video_source_selector.dart';
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
import 'package:meiyou/shared/presentation/widgets/content_holder/content_holder_theme.dart';
import 'package:meiyou/shared/presentation/widgets/content_list_view/content_list_view.dart';
import 'package:meiyou/shared/presentation/widgets/content_list_view/content_list_view_theme.dart';
import 'package:meiyou/shared/presentation/widgets/responsive_widget.dart';
import 'package:meiyou/shared/presentation/widgets/sheets/adaptive_sheet.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:nice_dart/nice_dart.dart';

typedef LinkAndVideo = LinkAndAsset<Video>;

class PlayerScreenViewModel {
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

    Future.microtask(() async {
      await _initStateListenable(
          mediaId: mediaId, contentId: contentId, category: category);
      _load(state.content!);
    }).catchError((e, s) {
      logger.severe('Error initializing player screen view model', e, s);
      _exitCallback.call();
    });
  }

  final Completer<void> _initCompleter = Completer<void>();

  Future<void> waitForInit() => _initCompleter.future;

  final MediaAssetLoader<Video> _videoLoader = MediaAssetLoaderImpl<Video>();
  final GetMediaByIdUseCase _getMediaByIdUseCase = getIt.get();
  final SourceManager sourceManager = getIt.get();
  final GetContentByIdUseCase _getContentByIdUseCase = getIt.get();
  final GetContentListByMediaIdUseCase _getContentListByMediaIdUseCase =
      getIt.get();
  final GlobalKey<VideoState> videoKey = GlobalKey<VideoState>();
  final VoidCallback _exitCallback;

  // player and video controller

  late final Player player;
  late final VideoController videoController;

  // stateListenables

  final StateNotifier<PlayerScreenState> stateListenable =
      StateNotifier(PlayerScreenState.inital());

  final controlVisibilityNotifier = StateNotifier<bool>(true);

  final currentVideoNotifier = StateNotifier<int>(0);

  final currentVideoSourceNotifier = StateNotifier<int>(0);

  final playerFitNotifier = StateNotifier<BoxFit>(BoxFit.contain);

  // streams

  late final StreamStateNotifier<bool> bufferingListenable =
      StateNotifier.fromStream(player.stream.buffering,
          initalState: player.state.buffering);

  late final StreamStateNotifier<bool> playPauseStateListenable =
      StateNotifier.fromStream(player.stream.playing,
          initalState: player.state.playing);

  late final StreamStateNotifier<List<String>> subtitleListenable =
      StateNotifier.fromStream(
    player.stream.subtitle,
    initalState: player.state.subtitle,
  );

  // late final StateStream<List<VideoTrack>> videoTracksStream =
  //     StateStream.fromStream(
  //   player.stream.tracks.map((tracks) => [VideoTrack.auto(), ...tracks.video]),
  //   initialData: [VideoTrack.auto()],
  // );

  // late final StreamStateNotifier<List<VideoTrack>> videoTracksListenable =
  //     StateNotifier.fromStream(
  //   player.stream.tracks
  //       .map((tracks) => [VideoTrack.auto(), ...tracks.video.sublist(2)]),
  //   initalState: [VideoTrack.auto()],
  // );

  // late final StreamStateNotifier<List<SubtitleTrack>> subtitleTracksListenable =
  //     StateNotifier.fromStream(
  //         player.stream.tracks.map(
  //             (tracks) => [SubtitleTrack.no(), ...tracks.subtitle.sublist(2)]),
  //         initalState: [SubtitleTrack.no()]);

  // late final StreamStateNotifier<List<AudioTrack>> audioTracksListenable =
  //     StateNotifier.fromStream(
  //         player.stream.tracks
  //             .map((tracks) => [AudioTrack.auto(), ...tracks.audio.sublist(2)]),
  //         initalState: [AudioTrack.auto()]);

  late final StreamStateNotifier<PlayerSeekBarState> seekBarStateListenable =
      PlayerSeekBarState(
    position: player.state.position,
    buffered: player.state.buffer,
    total: player.state.duration,
  ).let((it) => StateNotifier.fromStream(
          CombineStream.combine3(
            player.stream.position,
            player.stream.buffer,
            player.stream.duration,
            (position, buffered, duration) => PlayerSeekBarState(
                position: position, buffered: buffered, total: duration),
            initalDataA: it.position,
            initalDataB: it.buffered,
            initalDataC: it.total,
          ),
          initalState: it));

  // getters

  PlayerScreenState get state => stateListenable.state;

  bool get hasPrevious =>
      state.contentList.isNotEmpty &&
      state.content != null &&
      state.contentList.first.id != state.content!.id;

  bool get hasNext =>
      state.contentList.isNotEmpty &&
      state.content != null &&
      state.contentList.last.id != state.content!.id;

  Video get currentVideo =>
      state.linkAndAssets[currentVideoNotifier.state].asset;

  VideoSource get currentVideoSource =>
      currentVideo.sources[currentVideoSourceNotifier.state];

  List<LinkAndVideo> get linkAndAssets => state.linkAndAssets;

  List<VideoTrack> get videoTracks =>
      [VideoTrack.auto(), ...player.state.tracks.video.sublist(2)];

  VideoTrack get currentVideoTrack => player.state.track.video;

  List<SubtitleTrack> get subtitleTracks => [
        SubtitleTrack.no(),
        ...player.state.tracks.subtitle.sublist(2),
        ...?currentVideo.subtitles?.mapList((subtitle) => SubtitleTrack.uri(
              subtitle.url,
              language: subtitle.language,
            ))
      ];

  SubtitleTrack get currentSubtitleTrack => player.state.track.subtitle;

  List<AudioTrack> get audioTracks =>
      [AudioTrack.no(), ...player.state.tracks.audio.sublist(2)];

  AudioTrack get currentAudioTrack => player.state.track.audio;

  int get skipSeconds => 85;

  // methods

  Future<void> previous() {
    if (state.isLoading) {
      _linkAndVideoSubscription?.cancel();
    }

    final index = state.contentList
        .indexWhere((element) => element.id == state.content!.id);
    if (index == 0) return Future.value();

    return _load(state.contentList[index - 1]);
  }

  Future<void> next() {
    if (state.isLoading) {
      _linkAndVideoSubscription?.cancel();
    }

    final index = state.contentList
        .indexWhere((element) => element.id == state.content!.id);
    if (index == state.contentList.length - 1) return Future.value();

    return _load(state.contentList[index + 1]);
  }

  Future<void> showVideoSources(BuildContext context) {
    if (state.isLoading) return Future.value();
    return showAdaptiveDialog<void>(
        context: context,
        builder: (context) {
          return VideoSourceSelector(
            selectedSource: currentVideoSource,
            linkAndSources: Map.fromEntries(state.linkAndAssets
                .map((e) => MapEntry(e.link, e.asset.sources))),
            onSourceSelected: (source) {
              setVideoSource(source);
              Navigator.of(context).pop();
            },
          );
        });
  }

  Future<void> showMediaContentList(BuildContext context) {
    if (state.contentList.isEmpty) return Future.value();
    var type = ContentListViewType.list;
    return showModalAdaptiveSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (context) =>
            ResponsiveBuilder(builder: (context, constraints, screenSize) {
              return ContentListViewTheme.fromContext(
                context: context,
                screenSize: screenSize,
                child: ContentHolderTheme.fromContext(
                  context: context,
                  screenSize: screenSize,
                  child: StatefulBuilder(builder: (context, setState) {
                    return ContentListView(
                      size: screenSize,
                      media: state.media!,
                      groupedContent: MediaContentHelper.groupBySeasonAndSplit(
                          state.contentList),
                      type: type,
                      scrollable: true,
                      onViewTypeChange: (newType) {
                        setState(() {
                          type = newType;
                        });
                      },
                      padding: const EdgeInsets.all(8),
                      spacing: 8,
                      isRefreshing: false,
                      onContentSelected: (content) {
                        _load(content);
                      },
                    );
                  }),
                ),
              );
            }));
  }

  Future<void> showVideoSettings(BuildContext context) {
    if (state.isLoading) return Future.value();

    return showModalAdaptiveSheet(
        scrollControlDisabledMaxHeightRatio: 0.6,
        context: context,
        builder: (context) {
          return PlayerVideoSettings(
            videoTracks: videoTracks,
            selectedVideoTrack: currentVideoTrack,
            subtitleTracks: subtitleTracks,
            selectedSubtitleTrack: currentSubtitleTrack,
            audioTracks: audioTracks,
            selectedAudioTrack: currentAudioTrack,
            onVideoTrackSelected: setVideoTrack,
            onSubtitleTrackSelected: setSubtitleTrack,
            onAudioTrackSelected: setAudioTrack,
          );
        });
  }

  bool _controlsForceHidden = false;

  void forceHideControls() {
    if (_controlsForceHidden) return;
    _controlsForceHidden = true;
    controlVisibilityNotifier.setState(false);
  }

  void releaseHideControls() {
    _controlsForceHidden = false;
  }

  void playPause() {
    player.playOrPause();
  }

  Future<void> rewind(int seconds) {
    var result = player.state.position - Duration(seconds: seconds);
    result = result.clamp(
      Duration.zero,
      player.state.duration,
    );
    return player.seek(player.state.position - Duration(seconds: seconds));
  }

  Future<void> forward(int seconds) {
    var result = player.state.position + Duration(seconds: seconds);
    result = result.clamp(
      Duration.zero,
      player.state.duration,
    );
    return player.seek(player.state.position + Duration(seconds: seconds));
  }

  void toggleControlsVisibilty() {
    if (_controlsForceHidden) return;
    controlVisibilityNotifier.setState(!controlVisibilityNotifier.state);
  }

  void skipForward() {
    player.seek(player.state.position + Duration(seconds: skipSeconds));
  }

  static const _allowedFits = [
    BoxFit.contain,
    BoxFit.cover,
    BoxFit.fill,
  ];

  void changeVideoFit() {
    var index = _allowedFits.indexOf(playerFitNotifier.state);
    index = (index + 1) % _allowedFits.length;
    final fit = _allowedFits[index];
    playerFitNotifier.setState(fit);
    videoKey.currentState?.update(fit: fit);
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
        videoIndex: videoIndex,
        sourceIndex: sourceIndex,
        startFrom: player.state.position,
      );
    } catch (e, s) {
      logger.severe('Error setting video source', e, s);
    }
  }

  Future<void> setVideoTrack(VideoTrack track) {
    return player.setVideoTrack(track);
  }

  Future<void> setSubtitleTrack(SubtitleTrack track) {
    return player.setSubtitleTrack(track);
  }

  Future<void> setAudioTrack(AudioTrack track) {
    return player.setAudioTrack(track);
  }

  Future<void> seek(Duration duration) {
    return player.seek(duration);
  }

  StreamSubscription? _linkAndVideoSubscription;

  Future<void> _load(MediaContent content) async {
    bool isFirst = true;

    await player.stop();

    stateListenable.setState(state.copyWith(content: content, isLoading: true));

    _linkAndVideoSubscription = _videoLoader
        .getAssetStream(state.source!, content)
        .listen(
          (linkAndAssets) {
            stateListenable.setState(state.copyWith(
              linkAndAssets: linkAndAssets,
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
          },
        );
  }

  void _updateAndOpenVideoSource(
      {int videoIndex = 0, int sourceIndex = 0, Duration? startFrom}) {
    _setVideoAndSource(videoIndex: videoIndex, sourceIndex: sourceIndex);
    _openCurrentVideoSource(startFrom: startFrom);
  }

  void _setVideoAndSource({required int videoIndex, required int sourceIndex}) {
    currentVideoNotifier.setState(videoIndex);
    currentVideoSourceNotifier.setState(sourceIndex);
  }

  Future<void> _openCurrentVideoSource({
    Duration? startFrom,
  }) async {
    final video = currentVideo;

    await player.open(
      video.toPlayableMedia(currentVideoSourceNotifier.state),
      play: false,
    );
    await player.stream.duration.first;
    stateListenable.setState(state.copyWith(isLoading: false));
    await player.setVideoTrack(VideoTrack.auto());
    await player.setSubtitleTrack(_deaultSubtitle(video));
    await player.setAudioTrack(player.state.tracks.audio
        .firstWhere((track) => track.id == '1', orElse: () => AudioTrack.no()));
    if (startFrom != null) {
      await player.seek(startFrom);
    }

    await player.play();
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

  Future<void> _initStateListenable({
    required int mediaId,
    required int contentId,
    required ExtensionCategory category,
  }) async {
    try {
      final media = (await _getMediaByIdUseCase(
          GetMediaByIdParams(id: mediaId, category: category)))!;

      final source = sourceManager.getSource(media.sourceId, media.category)!;

      final content = (await _getContentByIdUseCase(
          GetContentByIdParams(id: contentId, category: category)))!;

      stateListenable.setState(
        state.copyWith(
          media: media,
          source: source,
          content: content,
        ),
      );

      _getContentListByMediaIdUseCase(GetContentListByMediaIdParams(
              category: media.category, mediaId: mediaId))
          .then((contentList) {
        stateListenable.setState(state.copyWith(contentList: contentList));
        _initCompleter.complete();
      });
    } catch (e, s) {
      logger.severe('Error initializing state listenable', e, s);
      _exitCallback.call();
    }
  }

  void _releaseCache() {
    _videoLoader.releaseAllCache();
  }

  void dispose() {
    _linkAndVideoSubscription?.cancel();
    _releaseCache();
    stateListenable.dispose();
    currentVideoNotifier.dispose();
    currentVideoSourceNotifier.dispose();
    playerFitNotifier.dispose();
    controlVisibilityNotifier.dispose();
    bufferingListenable.dispose();
    playPauseStateListenable.dispose();
    seekBarStateListenable.dispose();
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
  final MediaContent? content;
  final List<MediaContent> contentList;
  final m.Media? media;
  final Source? source;

  PlayerScreenState({
    required this.isLoading,
    required this.linkAndAssets,
    required this.contentList,
    required this.content,
    required this.media,
    required this.source,
  });

  PlayerScreenState.inital()
      : isLoading = true,
        media = null,
        content = null,
        source = null,
        contentList = [],
        linkAndAssets = [];

  PlayerScreenState copyWith({
    bool? isLoading,
    List<LinkAndVideo>? linkAndAssets,
    MediaContent? content,
    List<MediaContent>? contentList,
    m.Media? media,
    Source? source,
  }) {
    return PlayerScreenState(
      isLoading: isLoading ?? this.isLoading,
      linkAndAssets: linkAndAssets ?? this.linkAndAssets,
      content: content ?? this.content,
      contentList: contentList ?? this.contentList,
      media: media ?? this.media,
      source: source ?? this.source,
    );
  }
}
