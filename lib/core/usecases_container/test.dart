import 'package:meiyou/data/data_source/providers/meta_providers/anilist.dart';
import 'package:meiyou/data/data_source/providers/meta_providers/tmdb.dart';
import 'package:meiyou/data/repositories/meta_provider_repository_impl.dart';
import 'package:meiyou/domain/usecases/get_main_page_usecase.dart';

import '../../domain/usecases/get_mapped_episodes_usecase.dart';
import '../../domain/usecases/get_mapped_movie.dart';
import '../../domain/usecases/get_media_details_usecase.dart';
import '../../domain/usecases/get_meta_results_usecase.dart';
import '../usecases/usecase.dart';

void main(List<String> args) {
  final repository = MetaProviderRepositoryImpl(TMDB(), Anilist());
  Map<String, UseCase> usecases = {
    '5': GetMainPageUseCase(repository),
    '4': GetMediaDetailUseCase(repository),
    '3': GetSearchUseCase(repository),
    '2': GetMappedEpisodesUseCase(repository),
    '1': GetMappedMovie(repository),
  };

  T get<T>() {
    return usecases.values.firstWhere((element) => element is T) as T;
  }

  final b = get<GetMediaDetailUseCase>();
  print(b.runtimeType);
}
