import 'package:meiyou_extensions_lib/models.dart';
import 'package:nice_dart/nice_dart.dart';

typedef LinkAndData<T extends ContentData> = Pair<ContentDataLink, T>;

abstract interface class SourceRepository {
  Future<Result<Map<HomePageRequest, HomePage>>> getFullHomePage(Source source);

  Future<Result<HomePage>> getHomePage(
      Source source, int page, HomePageRequest request);

  Future<Result<SearchPage>> getSearchPage(
      Source source, int page, String query, FilterList filters);

  Future<Result<InfoPage>> getInfoPage(Source source, ContentItem contentItem);

  Future<Result<Content>> loadLazyContent(LazyContent lazyContent);

  Future<Result<List<ContentDataLink>>> getDataLinks(Source source, String url);

  Future<Result<T?>> getContentData<T extends ContentData>(
      Source source, ContentDataLink link);
}

class LoadingException implements Exception {
  const LoadingException();

  @override
  String toString() {
    return 'LoadingException';
  }
}
