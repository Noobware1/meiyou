import 'dart:typed_data';

import 'package:async/async.dart' hide Result;
import 'package:collection/collection.dart';
import 'package:meiyou/core/helper/locale_helper.dart';
import 'package:meiyou/core/utils/extensions/result.dart';
import 'package:meiyou/core/utils/log/logger.dart';
import 'package:meiyou/shared/data/data_sources/preferences/source_preferences.dart';
import 'package:meiyou/shared/data/extension/extension_manager_impl.dart';
import 'package:meiyou/shared/domain/models/extension_category.dart';
import 'package:meiyou/shared/domain/models/extension_list.dart';
import 'package:meiyou/shared/domain/models/source.dart' as m;
import 'package:meiyou/shared/domain/models/source_repository_params.dart';
import 'package:meiyou/shared/domain/repositories/source_repository.dart';
import 'package:meiyou/shared/domain/source_manager/source_manager.dart';
import 'package:meiyou/shared/extension_manager/extension_manger.dart';
import 'package:meiyou/shared/utils/comparator/case_insensitive_comparator.dart';
import 'package:meiyou/shared/utils/stream_utils/comnine_stream.dart';
import 'package:meiyou/shared/utils/stream_utils/state_stream.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:nice_dart/nice_dart.dart';
import 'package:okhttp/interceptor.dart';

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
      getEnabledSourcesUseCaseParams params) {
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
  Future<Result<FullHomePageData>> getFullHomePage(
      GetFullHomePageParams params) {
    final sourceId = params.sourceId;
    final category = params.category;
    return runAsyncCatching(() async {
      final source = _getSourceOrThrow(sourceId, category);
      final requests = source.homePageRequests();
      final FullHomePageData results = {};

      for (final request in requests) {
        try {
          final result = await source.getHomePage(1, request);
          results[request] = result;
        } catch (e, s) {
          logger.warning('Failed to load ${request.data}', e, s);
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
  Future<Result<MediaDetails>> getMediaDetails(GetMediaDetailsParams params) {
    final sourceId = params.sourceId;
    final category = params.category;
    final url = params.url;

    return runAsyncCatching(() {
      final source = _getSourceOrThrow(sourceId, category) as CatalogueSource;
      return source.getMediaDetails(url);
    });
  }

  @override
  Future<Result<List<MediaLink>>> getMediaLinks(GetMediaLinksParams params) {
    final sourceId = params.sourceId;
    final category = params.category;
    final url = params.url;

    return runAsyncCatching(() {
      final source = _getSourceOrThrow(sourceId, category) as CatalogueSource;
      return source.getMediaLinks(url);
    });
  }

  @override
  Future<Result<Media>> getMedia(GetMediaParams params) {
    final sourceId = params.sourceId;
    final category = params.category;
    final link = params.link;

    return runAsyncCatching(() {
      final source = _getSourceOrThrow(sourceId, category) as CatalogueSource;
      return source.getMedia(link).then((value) =>
          value.let((it) => it ?? (throw Exception('No Media found'))));
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
      language: LocaleHelper.getLocalizedDisplayName(lang),
      pin: m.Pin.unPinned,
      version: '',
      icon: null,
    );
  }
}
