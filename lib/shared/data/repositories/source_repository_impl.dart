import 'package:collection/collection.dart';
import 'package:meiyou/core/utils/exceptions/home_page_not_supported.dart';
import 'package:meiyou/core/utils/extensions/result.dart';
import 'package:meiyou/core/utils/log/logger.dart';
import 'package:meiyou/shared/data/data_sources/preferences/source_preferences.dart';
import 'package:meiyou/shared/domain/models/extension_category.dart';
import 'package:meiyou/shared/domain/models/home_page_data.dart';
import 'package:meiyou/shared/domain/models/source.dart' as m;
import 'package:meiyou/shared/domain/models/repositories_params/source_repository_params.dart';
import 'package:meiyou/shared/domain/repositories/source_repository.dart';
import 'package:meiyou/shared/domain/source_manager/source_manager.dart';
import 'package:meiyou/shared/domain/extension_manager/extension_manger.dart';
import 'package:meiyou/core/utils/comparator/case_insensitive_comparator.dart';
import 'package:meiyou/core/utils/stream_utils/comnine_stream.dart';
import 'package:meiyou/core/utils/stream_utils/state_stream.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:nice_dart/nice_dart.dart';

class SourceRepositoryImpl implements SourceRepository {
  final SourcePreferences _preferences;
  final ExtensionManager _extensionManager;
  final SourceManager _manager;

  SourceRepositoryImpl(
      {required SourcePreferences preferences,
      required SourceManager manager,
      required ExtensionManager extensionManager})
      : _preferences = preferences,
        _extensionManager = extensionManager,
        _manager = manager;

  StateStream<List<m.InstalledSource>> _getSources(ExtensionCategory category) {
    return _manager.getCatalogueSources(category).map((e) {
      return e
          .map((e) => e
                  .toInstalledSource(
                category: category,
              )
                  .let((it) {
                final installedExtension =
                    _extensionManager.getInstalledExtension(it.id, category);
                return it.copyWith(
                  icon: installedExtension?.icon,
                  version: installedExtension?.versionName,
                );
              }))
          .toList();
    });
  }

  @override
  StateStream<List<m.InstalledSource>> getEnabledSourcesUseCase(
      GetEnabledSourcesUseCaseParams params) {
    final category = params.category;
    final prefPinnedSources = _preferences.pinnedSourcesForCategory(category);
    final prefDisabledSources =
        _preferences.disabledSourcesForCategory(category);
    final prefEnabledLanguages = _preferences.enabledLanguages();
    final prefLastUsedSource = _preferences.lastUsedSourceByCategory(category);
    final sources = _getSources(category);

    List<m.InstalledSource> filterSources(
        {required List<String> pinnedSources,
        required List<String> disabledSource,
        required List<String> enabledLanguages,
        required int lastUsedSource,
        required List<m.InstalledSource> sources}) {
      return sources
          .whereNot((element) => disabledSource.contains(element.id.toString()))
          .sorted((a, b) => CaseInsensitiveComparator.compare(a.name, b.name))
          .map((e) {
            final flag = pinnedSources.contains(e.id.toString())
                ? m.Pin.pinned
                : m.Pin.unPinned;

            final toFlatten = [e.copyWith(pin: flag)];

            final isUsedLast = lastUsedSource == e.id;

            if (isUsedLast) {
              toFlatten.add(e.copyWith(isUsedLast: true));
            }

            return toFlatten;
          })
          .flattened
          .toList();
    }

    final initalData = filterSources(
      pinnedSources: prefPinnedSources.get(),
      disabledSource: prefDisabledSources.get(),
      enabledLanguages: prefEnabledLanguages.get(),
      lastUsedSource: prefLastUsedSource.get(),
      sources: sources.state,
    );

    final stream = CombineStream.combine5(
      prefPinnedSources.changes(),
      prefDisabledSources.changes(),
      prefEnabledLanguages.changes(),
      prefLastUsedSource.changes(),
      sources,
      (pinnedSources, disabledSource, enabledLanguages, lastUsedSource,
              sources) =>
          filterSources(
              pinnedSources: pinnedSources,
              disabledSource: disabledSource,
              enabledLanguages: enabledLanguages,
              lastUsedSource: lastUsedSource,
              sources: sources),
      initalDataA: prefPinnedSources.get(),
      initalDataB: prefDisabledSources.get(),
      initalDataC: prefEnabledLanguages.get(),
      initalDataD: prefLastUsedSource.get(),
      initalDataE: sources.state,
    ).distinct(
      (a, b) => const ListEquality<m.InstalledSource>().equals(a, b),
    );

    return StateStream.fromStream(stream, initialData: initalData);
  }

  @override
  Future<Result<List<HomePageData>>> getFullHomePage(
      GetFullHomePageParams params) {
    final sourceId = params.sourceId;
    final category = params.category;
    return runAsyncCatching(() async {
      final source = _getSourceOrThrow(sourceId, category);
      _checkSourceType(source);
      source as HttpSource;
      final requests = source.getHomePageRequestList();
      final List<HomePageData> results = [];

      for (final request in requests) {
        try {
          final result = await source.getHomePage(1, request).then(
                (homePage) => homePage.copyWith(
                    items: homePage.items
                        .where((e) => e.list.isNotEmpty)
                        .toList()),
              );
          if (result.items.isEmpty ||
              result.items.every((e) => e.list.isEmpty)) {
            logger.warning('Empty homepage for ${request.url}');
            continue;
          }
          results.add(HomePageData(
            request: request,
            homePage: result,
            page: 1,
          ));
        } catch (e, s) {
          logger.warning('Failed to load ${request.url}', e, s);
        }
      }

      return results.isEmpty
          ? (throw Exception('Failed to load homepage'))
          : results;
    });
  }

  @override
  Future<Result<HomePage>> getHomePage(GetHomePageParams params) {
    final sourceId = params.sourceId;
    final category = params.category;
    final page = params.page;
    final request = params.request;

    return runAsyncCatching(() {
      final source = _getSourceOrThrow(sourceId, category);
      _checkSourceType(source);
      source as HttpSource;
      return source.getHomePage(page, request);
    });
  }

  Source _getSourceOrThrow(int sourceId, ExtensionCategory category) {
    final source = _manager.getSource(sourceId, category);
    if (source == null) {
      throw Exception('Source not found');
    }

    return source;
  }

  void _checkSourceType(Source source) {
    if (source is! HttpSource) {
      throw HomePageNotSupported(source);
    }
  }

  @override
  Future<Result<SearchPage>> getSearchPage(GetSearchPageParams params) {
    final sourceId = params.sourceId;
    final category = params.category;
    final page = params.page;
    final query = params.query;
    final filters = params.filters;

    return runAsyncCatching(() {
      final source = _getSourceOrThrow(sourceId, category) as CatalogueSource;
      return source.getSearchPage(page, query, filters);
    });
  }

  @override
  Future<Result<IMedia>> getMediaDetails(GetMediaDetailsParams params) {
    final sourceId = params.sourceId;
    final category = params.category;
    final media = params.media;

    return runAsyncCatching(() {
      final source = _getSourceOrThrow(sourceId, category);
      return source.getMediaDetails(media);
    });
  }

  @override
  Future<Result<List<IMediaContent>>> getMediaContentList(
      GetMediaContentListParams params) {
    final sourceId = params.sourceId;
    final category = params.category;
    final media = params.media;

    return runAsyncCatching(() {
      final source = _getSourceOrThrow(sourceId, category);
      return source.getMediaContentList(media);
    });
  }

  @override
  Future<Result<List<MediaLink>>> getMediaLinkList(
      GetMediaLinkListParams params) {
    final sourceId = params.sourceId;
    final category = params.category;
    final content = params.content;

    return runAsyncCatching(() {
      final source = _getSourceOrThrow(sourceId, category);
      return source.getMediaLinkList(content);
    });
  }

  @override
  Future<Result<MediaAsset?>> getMediaAsset(GetMediaAssetsParams params) {
    final sourceId = params.sourceId;
    final category = params.category;
    final link = params.link;

    return runAsyncCatching(() {
      final source = _getSourceOrThrow(sourceId, category);
      return source.getMediaAsset(link);
    });
  }
}

extension on Source {
  m.InstalledSource toInstalledSource({
    required ExtensionCategory category,
  }) {
    return m.InstalledSource(
      id: id,
      name: name,
      category: category,
      isUsedLast: false,
      language: lang,
      pin: m.Pin.unPinned,
      version: '',
      icon: null,
    );
  }
}
