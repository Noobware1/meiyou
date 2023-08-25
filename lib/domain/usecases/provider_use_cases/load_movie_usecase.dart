import 'package:meiyou/core/resources/providers/base_provider.dart';
import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/entities/movie.dart';
import 'package:meiyou/domain/repositories/watch_provider_repository.dart';

class GetProviderLoadMovieUseCase
    implements UseCase<Future<ResponseState<MovieEntity>>, String> {
  final WatchProviderRepository _repository;
  final BaseProvider _provider;

  const GetProviderLoadMovieUseCase(
      {required WatchProviderRepository repository,
      required BaseProvider provider})
      : _repository = repository,
        _provider = provider;

  @override
  Future<ResponseState<MovieEntity>> call(String params) {
    return _repository.loadMovie(_provider, params);
  }
}
