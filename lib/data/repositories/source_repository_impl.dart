import 'package:meiyou/core/utils/resources/logger.dart';
import 'package:meiyou/core/utils/resources/network.dart';
import 'package:meiyou/domain/repositories/source_repository.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:nice_dart/nice_dart.dart';

class SourceRepositoryImpl implements SourceRepository {
  @override
  Future<Result<Map<HomePageRequest, HomePage>>> getFullHomePage(
      Source source) {
    assert(source.supportsHomePage);

    return runAsyncCatching(() async {
      final requests = source.homePageRequests();
      final timeout = source.homePageRequestTimeout > 0.0
          ? Duration(milliseconds: source.homePageRequestTimeout.toInt())
          : null;
      final Map<HomePageRequest, HomePage?> homePages = {
        for (var e in requests) e: null
      };

      for (final request in requests) {
        final result = await getHomePage(source, 1, request);
        if (result.isSuccess) {
          homePages[request] = result.getOrNull();
        } else {
          logRat.logInfo(
            'homePage request for ${request.name} failed!',
            result.exceptionOrNull().toString(),
          );
        }

        if (timeout != null) await Future.delayed(timeout);
      }

      return homePages.entries
              .where((it) =>
                  it.value != null &&
                  it.value!.data.isNotEmpty &&
                  it.value!.data.first.items.isNotEmpty)
              .map((it) => MapEntry(it.key, it.value!))
              .takeIf((it) => it.isNotEmpty)
              ?.let((it) => Map.fromEntries(it)) ??
          (throw const LoadingException());
    });
  }

  @override
  Future<Result<HomePage>> getHomePage(
      Source source, int page, HomePageRequest request) {
    assert(source.supportsHomePage);
    return runAsyncCatching(() => source.getHomePage(page, request));
  }

  @override
  Future<Result<SearchPage>> getSearchPage(
      Source source, int page, String query, FilterList filters) {
    assert(source is CatalogueSource);
    return runAsyncCatching(() => (source as CatalogueSource)
            .getSearchPage(page, query, filters)
            .then((value) {
          return value.takeIf((it) => it.items.isNotEmpty) ??
              (throw const LoadingException());
        }));
  }

  @override
  Future<Result<InfoPage>> getInfoPage(Source source, ContentItem contentItem) {
    return runAsyncCatching(() => source.getInfoPage(contentItem));
  }

  @override
  Future<Result<Content>> loadLazyContent(LazyContent lazyContent) {
    return runAsyncCatching(
      () => lazyContent.load().catchError(
        (error, stackTrace) {
          logRat.logError('Error loading lazy content', error, stackTrace);
          throw error;
        },
      ),
    );
  }

  @override
  Future<Result<List<ContentDataLink>>> getDataLinks(
      Source source, String url) {
    return runAsyncCatching(() async {
      final links = await source.getContentDataLinks(url);
      return links.takeIf((it) => it.isNotEmpty) ??
          (throw const LoadingException());
    });
  }

  @override
  Future<Result<T?>> getContentData<T extends ContentData>(
      Source source, ContentDataLink link) {
    return runAsyncCatching(() => source.getContentData(link).then(
          (value) => value is! T ? throw const LoadingException() : value as T?,
        ));
  }
}
