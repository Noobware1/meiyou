import 'package:meiyou/core/utils/usecases/usecase.dart';
import 'package:meiyou/shared/domain/models/source.dart';
import 'package:meiyou/shared/domain/models/source_repository_params.dart';
import 'package:meiyou/shared/domain/repositories/source_repository.dart';
import 'package:meiyou/core/utils/stream_utils/state_stream.dart';

class getEnabledSourcesUseCase extends UseCase<
    StateStream<List<InstalledSource>>, getEnabledSourcesUseCaseParams> {
  final SourceRepository _repository;

  getEnabledSourcesUseCase(this._repository);

  @override
  StateStream<List<InstalledSource>> call(
      getEnabledSourcesUseCaseParams params) {
    return _repository.getEnabledSourcesUseCase(params);
  }
}
