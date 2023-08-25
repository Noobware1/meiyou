import 'package:meiyou/core/resources/providers/base_provider.dart';
import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/entities/video_server.dart';
import 'package:meiyou/domain/repositories/watch_provider_repository.dart';

class ProviderLoadVideoServersUseCase
    implements UseCase<Future<ResponseState<List<VideoSeverEntity>>>, String> {
  final WatchProviderRepository _repository;
  final BaseProvider _provider;

  const ProviderLoadVideoServersUseCase(
      {required WatchProviderRepository repository,
      required BaseProvider provider})
      : _repository = repository,
        _provider = provider;

  @override
  Future<ResponseState<List<VideoSeverEntity>>> call(String params) {
    return _repository.loadVideoServers(_provider, params);
  }
}
