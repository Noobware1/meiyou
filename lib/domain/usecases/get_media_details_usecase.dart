import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/entities/media_details.dart';
import 'package:meiyou/domain/entities/meta_response.dart';
import 'package:meiyou/domain/repositories/media_details_repository.dart';

class GetMediaDetailUseCase
    implements
        UseCase<Future<ResponseState<MediaDetailsEntity>>, MetaResponseEntity> {
  final MediaDetailsRepository _repository;

  const GetMediaDetailUseCase(this._repository);

  @override
  Future<ResponseState<MediaDetailsEntity>> call(MetaResponseEntity params) {
    return _repository.getMediaDetails(params);
  }
}
