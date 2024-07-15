import 'package:meiyou/shared/domain/models/source.dart';
import 'package:meiyou/shared/domain/models/source_repository_params.dart';
import 'package:meiyou/core/utils/stream_utils/state_stream.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:nice_dart/nice_dart.dart';

typedef FullHomePageData = Map<HomePageRequest, HomePage>;

abstract class SourceRepository {
  StateStream<List<InstalledSource>> getEnabledSourcesUseCase(
      getEnabledSourcesUseCaseParams params);

  Future<Result<FullHomePageData>> getFullHomePage(
      GetFullHomePageParams params);

  Future<Result<HomePage>> getHomePage(GetHomePageParams params);

  Future<Result<SearchPage>> getSearchPage(GetSearchPageParams params);

  Future<Result<MediaDetails>> getMediaDetails(GetMediaDetailsParams params);

  Future<Result<List<MediaLink>>> getMediaLinks(GetMediaLinksParams params);

  Future<Result<Media>> getMedia(GetMediaParams params);
}
