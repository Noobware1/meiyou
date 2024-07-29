import 'package:meiyou/core/utils/usecases/usecase.dart';
import 'package:meiyou/shared/domain/models/repositories_params/media_repository_params.dart';
import 'package:meiyou/shared/domain/repositories/media_repository.dart';

class UpdateMediaFromSourceUseCase
    extends UseCase<Future<int>, UpdateMediaFromSourceParams> {
  final MediaRepository repository;

  UpdateMediaFromSourceUseCase(this.repository);

  @override
  Future<int> call(UpdateMediaFromSourceParams params) {
    return repository.updateMediaFromSource(params);
  }
}
