import 'package:flutter/material.dart';
import 'package:meiyou/core/router/routes.dart';
import 'package:meiyou/core/utils/extensions/list.dart';
import 'package:meiyou/core/utils/extensions/result.dart';
import 'package:meiyou/core/utils/log/logger.dart';
import 'package:meiyou/shared/domain/models/async_value.dart';
import 'package:meiyou/shared/domain/models/extension_category.dart';
import 'package:meiyou/shared/domain/models/media.dart';
import 'package:meiyou/shared/domain/models/repositories_params/media_repository_params.dart';
import 'package:meiyou/shared/domain/models/repositories_params/source_repository_params.dart';
import 'package:meiyou/shared/domain/usecases/media_repository_usecases/get_media_by_url_and_source_id_usecase.dart';
import 'package:meiyou/shared/domain/usecases/media_repository_usecases/network_media_to_local_usecase.dart';
import 'package:meiyou/shared/domain/usecases/source_repository_usecases/get_search_page_usecase.dart';
import 'package:meiyou/shared/presentation/notifers/async_state_notifer.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:nice_dart/nice_dart.dart';

class SearchScreenViewModel {
  SearchScreenViewModel(
      {required int sourceId,
      required ExtensionCategory category,
      required GetSearchPageUseCase getSearchPageUseCase,
      required NetworkMediaToLocalUseCase networkMediaToLocalUseCase,
      required GetMediaByUrlAndSourceIdUseCase getMediaByUrlAndSourceIdUseCase})
      : _sourceId = sourceId,
        _category = category,
        _getSearchPageUseCase = getSearchPageUseCase,
        _networkMediaToLocalUseCase = networkMediaToLocalUseCase,
        _getMediaByUrlAndSourceIdUseCase = getMediaByUrlAndSourceIdUseCase {
    scrollController.addListener(_scrollListener);
  }

  final int _sourceId;
  final ExtensionCategory _category;
  final GetSearchPageUseCase _getSearchPageUseCase;
  final NetworkMediaToLocalUseCase _networkMediaToLocalUseCase;
  final GetMediaByUrlAndSourceIdUseCase _getMediaByUrlAndSourceIdUseCase;

  final AsyncStateNotifier<SearchScreenState> stateListenable =
      AsyncStateNotifier.noData();

  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  int _page = 1;

  String get _query => searchController.text;

  Future<void> search([String? query]) async {
    _page = 1;

    stateListenable.setResultFuture(
      () => _getSearch(query ?? _query),
    );
  }

  Future<Result<SearchScreenState>> _getSearch(String query) {
    return runAsyncCatching(() async {
      final results = await _getSearchPageUseCase(GetSearchPageParams(
        filters: FilterList([]),
        sourceId: _sourceId,
        category: _category,
        query: query,
        page: _page,
      ));

      final searchPage = results.getOrThrow();

      final localMediaList =
          await searchPage.list.asyncMapNotNull((sourceMedia) async {
        final networkMedia =
            Media.formIMedia(sourceMedia, _sourceId, _category);
        final local = await _getMediaByUrlAndSourceIdUseCase(
            GetMediaByUrlAndSourceIdParams(
                url: networkMedia.url,
                sourceId: _sourceId,
                category: _category));

        return local ?? networkMedia;
      });

      return SearchScreenState(
        mediaList: localMediaList,
        hasNextPage: searchPage.hasNextPage,
      );
    });
  }

  bool _lock = false;

  Future<void> _loadNext() async {
    assert(stateListenable.state.hasData &&
        stateListenable.state.getOrThrow().hasNextPage);
    _lock = true;
    _page++;

    final result = await _getSearch(_query);

    if (result.isFailure) {
      logger.severe('Error loading next search page', result.exceptionOrNull());
    }

    final newData = result.getOrThrow().let((newState) =>
        stateListenable.state.getOrThrow().let((it) => it.copyFrom(newState)));

    stateListenable.setData(newData);

    _lock = false;
  }

  void _scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (stateListenable.state.hasData &&
          stateListenable.state.getOrThrow().hasNextPage &&
          !_lock) {
        _page++;
        _loadNext();
      }
    }
  }

  void dispose() {
    stateListenable.dispose();
    scrollController.dispose();
    searchController.dispose();
  }

  Future<void> onSelected(BuildContext context, Media media) async {
    final result = await _networkMediaToLocalUseCase(
        NetworkMediaToLocalParams(media: media));

    if (result.isSuccess) {
      final local = result.getOrThrow();

      if (!context.mounted) return;
      context.pushToMediaScreen(media);
    } else {
      logger.warning(
          'Failed to convert network media to local', result.exceptionOrNull());
    }
  }
}

class SearchScreenState {
  final List<Media> mediaList;
  final bool hasNextPage;

  SearchScreenState({required this.mediaList, required this.hasNextPage});

  SearchScreenState copyWith({
    List<Media>? mediaList,
    bool? hasNextPage,
  }) {
    return SearchScreenState(
      mediaList: mediaList ?? this.mediaList,
      hasNextPage: hasNextPage ?? this.hasNextPage,
    );
  }

  SearchScreenState copyFrom(SearchScreenState other) {
    return SearchScreenState(
      mediaList: mediaList + other.mediaList,
      hasNextPage: other.hasNextPage,
    );
  }
}
