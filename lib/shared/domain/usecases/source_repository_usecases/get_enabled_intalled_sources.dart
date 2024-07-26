import 'package:meiyou/core/utils/usecases/usecase.dart';
import 'package:meiyou/shared/domain/models/source.dart';
import 'package:meiyou/shared/domain/models/repositories_params/source_repository_params.dart';
import 'package:meiyou/shared/domain/repositories/source_repository.dart';
import 'package:meiyou/core/utils/stream_utils/state_stream.dart';

class GetEnabledSourcesUseCase extends UseCase<
    StateStream<List<InstalledSource>>, GetEnabledSourcesUseCaseParams> {
  final SourceRepository _repository;

  GetEnabledSourcesUseCase(this._repository);

  @override
  StateStream<List<InstalledSource>> call(
      GetEnabledSourcesUseCaseParams params) {
    return _repository.getEnabledSourcesUseCase(params);
  }
}
