import 'package:meiyou/core/resources/providers/base_provider.dart';
import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/entities/video_server.dart';
import 'package:meiyou/domain/repositories/watch_provider_repository.dart';

class LoadVideoServersParams {
  final String url;
  final BaseProvider provider;

  LoadVideoServersParams({required this.url, required this.provider});
}

class LoadVideoServersUseCase
    implements UseCase<Future<ResponseState<List<VideoSeverEntity>>>, LoadVideoServersParams> {
  final WatchProviderRepository _repository;

  const LoadVideoServersUseCase(
    this._repository,
  );

  @override
  Future<ResponseState<List<VideoSeverEntity>>> call(LoadVideoServersParams params) {
    return _repository.loadVideoServers(params.provider, params.url);
  }
}
