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
  final _repository = MetaProviderRepositoryImpl(TMDB(), Anilist());
  Map<String, UseCase> usecases = {
    '5': GetMainPageUseCase(_repository),
    '4': GetMediaDetailUseCase(_repository),
    '3': GetSearchUseCase(_repository),
    '2': GetMappedEpisodesUseCase(_repository),
    '1': GetMappedMovie(_repository),
  };

  T get<T>() {
    return usecases.values.firstWhere((element) => element is T) as T;
  }

  final b = get<GetMediaDetailUseCase>();
  print(b.runtimeType);
}
