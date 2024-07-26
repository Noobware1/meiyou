import 'package:meiyou/shared/domain/models/home_page_data.dart';
import 'package:meiyou/shared/domain/models/source.dart';
import 'package:meiyou/shared/domain/models/repositories_params/source_repository_params.dart';
import 'package:meiyou/core/utils/stream_utils/state_stream.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:nice_dart/nice_dart.dart';

abstract class SourceRepository {
  StateStream<List<InstalledSource>> getEnabledSourcesUseCase(
      GetEnabledSourcesUseCaseParams params);

  Future<Result<List<HomePageData>>> getFullHomePage(
      GetFullHomePageParams params);

  Future<Result<HomePage>> getHomePage(GetHomePageParams params);

  Future<Result<SearchPage>> getSearchPage(GetSearchPageParams params);

  Future<Result<IMedia>> getMediaDetails(GetMediaDetailsParams params);
}
