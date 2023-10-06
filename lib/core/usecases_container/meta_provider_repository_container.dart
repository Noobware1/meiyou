import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/core/usecases_container/usecase_container.dart';
import 'package:meiyou/domain/repositories/meta_provider_repository.dart';
import 'package:meiyou/domain/usecases/get_main_page_usecase.dart';
import 'package:meiyou/domain/usecases/get_mapped_episodes_usecase.dart';
import 'package:meiyou/domain/usecases/get_mapped_movie.dart';
import 'package:meiyou/domain/usecases/get_media_details_usecase.dart';
import 'package:meiyou/domain/usecases/get_meta_results_usecase.dart';


class MetaProviderRepositoryContainer
    extends UseCaseContainer<MetaProviderRepositoryContainer> {
  final MetaProviderRepository _repository;

  MetaProviderRepositoryContainer(this._repository);

  // String get mainPageUseCase => 'mainPageUseCase';
  // String get mediaDetailsUseCase => 'mediaDetailsUseCase';
  // String get searchUseCase => 'searchUseCase';
  // String get mappedEpisodeUseCase => 'mappedEpisodeUseCase';
  // String get mappedMovieUseCase => 'mappedMovieUseCase';

  @override
  Set<UseCase> get usecases => {
        // mainPageUseCase:
        GetMainPageUseCase(_repository),
        // mediaDetailsUseCase:
        GetMediaDetailUseCase(_repository),
        // searchUseCase:
        GetSearchUseCase(_repository),
        // mappedEpisodeUseCase:
        GetMappedEpisodesUseCase(_repository),
        // mappedMovieUseCase:
        GetMappedMovie(_repository),
      };
}

// void main(List<String> args) {
//   final a = MetaProviderRepositoryContainer(
//       MetaProviderRepositoryImpl(TMDB(), Anilist()));

//   final b = a.get<GetMediaDetailUseCase>();
//   print(b.runtimeType);
// }
