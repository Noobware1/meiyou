import 'dart:async';

import 'package:async/async.dart' hide Result;
import 'package:meiyou/core/utils/log/logger.dart';
import 'package:meiyou/core/utils/stream_utils/comnine_stream.dart';
import 'package:meiyou/shared/domain/models/extension_category.dart';
import 'package:meiyou/shared/domain/models/media.dart';
import 'package:meiyou/shared/domain/models/media_content.dart';
import 'package:meiyou/shared/domain/models/repositories_params/media_content_repository_params.dart';
import 'package:meiyou/shared/domain/models/repositories_params/media_repository_params.dart';
import 'package:meiyou/shared/domain/models/repositories_params/source_repository_params.dart';
import 'package:meiyou/shared/domain/usecases/media_content_repository_usecases/get_content_list_by_media_id_as_stream_usecase.dart';
import 'package:meiyou/shared/domain/usecases/media_content_repository_usecases/get_content_list_by_media_id_usecase.dart';
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
  final ExtensionCategory _category;
  final GetMediaByIdUseCase _getMediaByIdUseCase;
  final GetContentListByMediaIdUseCase _getContentListByMediaIdUseCase;
  final UpdateMediaUseCase _updateMediaUsecase;
  final UpdateMediaFromSourceUseCase _updateMediaFromSourceUseCase;
  final UpdateContentUseCase _updateContentUsecase;
  final GetMediaDetailsUseCase _getMediaDetailsUseCase;
  final GetMediaContentListUseCase _getMediaContentListUseCase;

  MediaScreenViewModel({
    required int mediaId,
    required ExtensionCategory category,
    required GetMediaByIdUseCase getMediaByIdUseCase,
    required GetMediaByIdAsStreamUseCase getMediaByIdAsStreamUseCase,
    required GetContentListByMediaIdUseCase getContentListByMediaIdUseCase,
    required GetContentListByMediaIdAsStreamUseCase
        getContentListByMediaIdAsStreamUseCase,
    required UpdateMediaUseCase updateMediaUsecase,
    required UpdateMediaFromSourceUseCase updateMediaFromSourceUseCase,
    required UpdateContentUseCase updateContentUsecase,
    required GetMediaDetailsUseCase getMediaDetailsUseCase,
    required GetMediaContentListUseCase getMediaContentListUseCase,
  })  : _category = category,
        _getMediaByIdUseCase = getMediaByIdUseCase,
        _updateMediaFromSourceUseCase = updateMediaFromSourceUseCase,
        _getContentListByMediaIdUseCase = getContentListByMediaIdUseCase,
        _updateMediaUsecase = updateMediaUsecase,
        _updateContentUsecase = updateContentUsecase,
        _getMediaDetailsUseCase = getMediaDetailsUseCase,
        _getMediaContentListUseCase = getMediaContentListUseCase {
    final media = _getMediaByIdUseCase(
        GetMediaByIdParams(category: _category, id: mediaId));

    if (media == null) {
      return;
    }
    final contentList = _getContentListByMediaIdUseCase(
        GetContentListByMediaIdParams(category: _category, mediaId: mediaId));

    _subscription = CombineStream.combine2(
            getMediaByIdAsStreamUseCase(
                GetMediaByIdAsStreamParams(category: _category, id: mediaId)),
            getContentListByMediaIdAsStreamUseCase(
                GetContentListByMediaIdAsStreamParams(
                    category: _category,
                    mediaId: mediaId)), (media, contentList) {
      return _state.copyWith(media: media, contentList: contentList);
    }, initalDataOne: media, initalDataTwo: contentList)
        .listen((newState) {
      if (!stateListenable.isDisposed) {
        stateListenable.setState(newState);
      }
    });

    final needRefreshInfo = !media.initalized;
    final needRefreshContent = contentList.isEmpty;

    stateListenable = StateNotifier(
      MediaScreenState(
        media: media,
        contentList: contentList,
        isRefreshing: needRefreshInfo || needRefreshContent,
      ),
    );
  }

  // _refresh({
  //   bool refreshInfo = true,
  //   bool refreshContent = true,
  //   required Media media,
  // }) async {
  //   if (!refreshInfo && !refreshContent) {
  //     return;
  //   }

  //   final futures = Future.wait([
  //     if (refreshInfo)
  //       _getMediaDetailsUseCase(GetMediaDetailsParams(
  //           sourceId: media.sourceId, category: media.category, media: media)),
  //     if (refreshContent)
  //       _getMediaContentListUseCase(GetMediaContentListParams(
  //           sourceId: media.sourceId, category: media.category, media: media)),
  //   ]);

  //   final operation = CancelableOperation.fromFuture(futures);

  //   final result = await operation.valueOrCancellation();

  //   if (result == null) {
  //     logger.info('Job cancelled');
  //   }

  //   final mediaResult = result?.getOrNull(0) as Result<IMedia>?;
  //   final contentListResult =
  //       (result?.getOrNull(1) as Result<List<IMediaContent>>?);
  // }

  late final StreamSubscription<MediaScreenState> _subscription;

  Future<void> _loadMediaDetailsFromSource() async {
    try {
      final details = await _getMediaDetailsUseCase(GetMediaDetailsParams(
          sourceId: 0, category: _category, media: _state.media));
      await _updateMediaFromSourceUseCase(UpdateMediaFromSourceParams(
        localMedia: _state.media,
        networkMedia: details.getOrThrow(),
      ));
    } catch (e, s) {
      logger.severe('Failed to get media details from source', e, s);
    }
  }

  Future<void> _loadMediaContentListFromSource() async {}

  late final StateNotifier<MediaScreenState> stateListenable;

  MediaScreenState get _state => stateListenable.state;

  dispose() {
    _subscription.cancel();
    stateListenable.dispose();
  }

// final CancelableOperation<List<Future<Object>>>
}

class MediaScreenState {
  final Media media;
  final List<MediaContent> contentList;
  final bool isRefreshing;

  MediaScreenState({
    required this.media,
    required this.contentList,
    required this.isRefreshing,
  });

  MediaScreenState copyWith({
    Media? media,
    List<MediaContent>? contentList,
    bool? isRefreshing,
  }) {
    return MediaScreenState(
      media: media ?? this.media,
      contentList: contentList ?? this.contentList,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }
}
