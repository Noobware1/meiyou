import 'package:meiyou/core/resources/providers/base_provider.dart';
import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/entities/season.dart';
import 'package:meiyou/domain/repositories/cache_repository.dart';
import 'package:meiyou/domain/repositories/watch_provider_repository.dart';

class LoadSeasonsParams {
  final BaseProvider provider;
  final String url;

  const LoadSeasonsParams({required this.provider, required this.url});
}

class LoadSeasonsUseCase
    implements
        UseCase<Future<ResponseState<List<SeasonEntity>>>, LoadSeasonsParams> {
  final WatchProviderRepository _repository;

  const LoadSeasonsUseCase(this._repository);

  @override
  Future<ResponseState<List<SeasonEntity>>> call(LoadSeasonsParams params) {
    return _repository.loadSeason(params.provider, params.url);
  }
}
