import 'dart:async';

import 'package:async/async.dart' hide Result;
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:meiyou/core/injection/injection.dart';
import 'package:meiyou/core/utils/log/logger.dart';
import 'package:meiyou/core/utils/stream_utils/comnine_stream.dart';
import 'package:meiyou/features/details/domain/models/content_list_view_type.dart';
import 'package:meiyou/features/details/domain/models/media_screen_state.dart';
import 'package:meiyou/features/details/presentation/media_screen.dart';
import 'package:meiyou/shared/domain/models/extension_category.dart';
import 'package:meiyou/shared/domain/models/media.dart';
import 'package:meiyou/shared/domain/models/media_content.dart';
import 'package:meiyou/shared/domain/models/repositories_params/media_content_repository_params.dart';
import 'package:meiyou/shared/domain/models/repositories_params/media_repository_params.dart';
import 'package:meiyou/shared/domain/models/repositories_params/source_repository_params.dart';
import 'package:meiyou/shared/domain/usecases/media_content_repository_usecases/get_content_list_by_media_id_as_stream_usecase.dart';
import 'package:meiyou/shared/domain/usecases/media_content_repository_usecases/get_content_list_by_media_id_usecase.dart';
import 'package:meiyou/shared/domain/usecases/media_content_repository_usecases/sync_content_list_with_source_usecase.dart';
import 'package:meiyou/shared/domain/usecases/media_content_repository_usecases/update_content_usecase.dart';
import 'package:meiyou/shared/domain/usecases/media_repository_usecases/get_media_by_id_as_stream_usecase.dart';
import 'package:meiyou/shared/domain/usecases/media_repository_usecases/get_media_by_id_usecase.dart';
import 'package:meiyou/shared/domain/usecases/media_repository_usecases/update_media_from_source_usecase.dart';
import 'package:meiyou/shared/domain/usecases/media_repository_usecases/update_media_usecase.dart';
import 'package:meiyou/shared/domain/usecases/source_repository_usecases/get_media_content_list_usecase.dart';
import 'package:meiyou/shared/domain/usecases/source_repository_usecases/get_media_details_usecase.dart';
import 'package:meiyou/shared/presentation/notifers/async_state_notifer.dart';
import 'package:meiyou/shared/presentation/notifers/state_notifer.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:nice_dart/nice_dart.dart';

class MediaScreenViewModel {
  // final int _mediaId;
  // final ExtensionCategory _category;
  final GetMediaByIdUseCase _getMediaByIdUseCase = getIt.get();
  final GetMediaByIdAsStreamUseCase _getMediaByIdAsStreamUseCase = getIt.get();
  final GetContentListByMediaIdUseCase _getContentListByMediaIdUseCase =
      getIt.get();
  final GetContentListByMediaIdAsStreamUseCase
      _getContentListByMediaIdAsStreamUseCase = getIt.get();
  final UpdateMediaUseCase _updateMediaUsecase = getIt.get();
  final UpdateMediaFromSourceUseCase _updateMediaFromSourceUseCase =
      getIt.get();
  final UpdateContentUseCase _updateContentUsecase = getIt.get();
  final GetMediaDetailsUseCase _getMediaDetailsUseCase = getIt.get();
  final GetMediaContentListUseCase _getMediaContentListUseCase = getIt.get();
  final SyncContentListWithSourceUseCase _syncContentListWithSourceUseCase =
      getIt.get();
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey;
  final AnimationController progressContoller;
  final ScrollController scrollController;
  bool isFirstRefresh = false;

  MediaScreenViewModel({
    required int mediaId,
    required ExtensionCategory category,
    required TickerProvider tickerProvider,
    // required State<MediaScreen> stateWidget,
  })  : refreshIndicatorKey = GlobalKey<RefreshIndicatorState>(),
        progressContoller = AnimationController(
          vsync: tickerProvider,
          duration: Durations.long1,
        ),
        scrollController = ScrollController() {
    _init(mediaId, category);
  }

  void _init(
    int mediaId,
    ExtensionCategory category,
  ) {
    final media = _getMediaByIdUseCase(
        GetMediaByIdParams(category: category, id: mediaId));

    if (media == null) {
      throw Exception('Media not found');
    }

    final contentList = _getContentListByMediaIdUseCase(
        GetContentListByMediaIdParams(
            category: media.category, mediaId: mediaId));

    final needRefreshInfo = !media.initalized;
    final needRefreshContent = contentList.isEmpty;
    if (needRefreshInfo || needRefreshContent) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        isFirstRefresh = true;
        refreshIndicatorKey.currentState?.show();
      });
    }

    _initStateListenable(
      media: media,
      contentList: contentList,
      needRefreshInfo: needRefreshInfo,
      needRefreshContent: needRefreshContent,
    );

    _initSubscription(
      mediaId: mediaId,
      media: media,
      contentList: contentList,
    );

    _initSourceOperations(
      needRefreshInfo: needRefreshInfo,
      needRefreshContent: needRefreshContent,
    );
  }

  void _initStateListenable({
    required Media media,
    required List<MediaContent> contentList,
    required bool needRefreshInfo,
    required bool needRefreshContent,
  }) {
    stateListenable = StateNotifier(
      MediaScreenState(
        media: media,
        contentList: contentList,
        isRefreshing: needRefreshInfo || needRefreshContent,
      ),
    );
  }

  Future<void> _initSourceOperations({
    required bool needRefreshInfo,
    required bool needRefreshContent,
  }) async {
    _sourceOperations = CancelableOperation.fromFuture(Future.wait([
      if (needRefreshInfo) _loadMediaDetailsFromSource(),
      if (needRefreshContent) _loadMediaContentListFromSource(),
    ]));

    await _sourceOperations?.valueOrCancellation();
    stateListenable.setState(_state.copyWith(isRefreshing: false));
    _sourceOperations = null;
  }

  void _initSubscription({
    required int mediaId,
    required Media media,
    required List<MediaContent> contentList,
  }) {
    _subscription = CombineStream.combine2(
      _getMediaByIdAsStreamUseCase(
          GetMediaByIdAsStreamParams(category: media.category, id: mediaId)),
      _getContentListByMediaIdAsStreamUseCase(
          GetContentListByMediaIdAsStreamParams(
              category: media.category, mediaId: mediaId)),
      (media, contentList) {
        return _state.copyWith(media: media, contentList: contentList);
      },
      initalDataOne: media,
      initalDataTwo: contentList,
    ).listen((newState) {
      if (!stateListenable.isDisposed) {
        stateListenable.setState(newState);
      }
    })
      ..onError((
        Object error,
        StackTrace stackTrace,
      ) {
        logger.severe('Error in media screen view model', error, stackTrace);
      });
  }

  late final StateNotifier<MediaScreenState> stateListenable;

  MediaScreenState get _state => stateListenable.state;

  late final StreamSubscription<MediaScreenState> _subscription;

  CancelableOperation<List<void>>? _sourceOperations;

  Future<void> _loadAllFromSource() async {
    try {
      await _sourceOperations?.cancel();

      stateListenable.setState(_state.copyWith(isRefreshing: true));

      _sourceOperations = CancelableOperation.fromFuture(Future.wait([
        _loadMediaDetailsFromSource(),
        _loadMediaContentListFromSource(),
      ]));

      await _sourceOperations?.valueOrCancellation();
      _sourceOperations = null;

      stateListenable.setState(_state.copyWith(isRefreshing: false));
    } catch (e) {
      logger.severe('Failed to load all from source', e);
    }
  }

  Future<void> _loadMediaDetailsFromSource() async {
    try {
      final details = await _getMediaDetailsUseCase(GetMediaDetailsParams(
        sourceId: _state.media.sourceId,
        category: _state.media.category,
        media: _state.media,
      ));
      await _updateMediaFromSourceUseCase(UpdateMediaFromSourceParams(
        localMedia: _state.media,
        networkMedia: details.getOrThrow(),
      ));
    } catch (e, s) {
      logger.severe('Failed to get media details from source', e, s);
    }
  }

  Future<void> _loadMediaContentListFromSource() async {
    try {
      final result =
          await _getMediaContentListUseCase(GetMediaContentListParams(
        sourceId: _state.media.sourceId,
        category: _state.media.category,
        media: _state.media,
      ));

      await _syncContentListWithSourceUseCase(
        SyncContentListWithSourceParams(
          contentList: result.getOrThrow(),
          media: _state.media,
        ),
      );
    } catch (e, s) {
      logger.severe('Failed to get media content list from source', e, s);
    }
  }

  void dispose() {
    _sourceOperations?.cancel();
    _subscription.cancel();
    stateListenable.dispose();
  }

  Future<void> toggleFavorite() async {
    await _updateMediaUsecase(UpdateMediaParams(
        media: _state.media..favorite = !_state.media.favorite));
  }

  Future<void> trackMedia() async {}

  Future<void> openWebView() async {}

  Future<void> refresh() async {
    if (isFirstRefresh) {
      isFirstRefresh = false;
      await _sourceOperations?.valueOrCancellation();
    } else {
      await _loadAllFromSource();
    }
  }

  void toggleViewType() {
    final ContentListViewType type;
    if (_state.contentListViewType == ContentListViewType.list) {
      progressContoller.forward();
      type = ContentListViewType.grid;
    } else {
      progressContoller.reverse();
      type = ContentListViewType.list;
    }
    stateListenable.setState(_state.copyWith(contentListViewType: type));
  }
}
