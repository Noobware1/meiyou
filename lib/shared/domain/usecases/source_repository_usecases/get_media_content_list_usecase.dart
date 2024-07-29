import 'package:meiyou/core/utils/usecases/async_usecase.dart';
import 'package:meiyou/shared/domain/models/repositories_params/source_repository_params.dart';
import 'package:meiyou/shared/domain/repositories/source_repository.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:nice_dart/nice_dart.dart';

class GetMediaContentListUseCase
    extends AsyncUseCase<List<IMediaContent>, GetMediaContentListParams> {
  final SourceRepository _repository;

  GetMediaContentListUseCase(this._repository);

  @override
  Future<Result<List<IMediaContent>>> call(GetMediaContentListParams params) {
    return _repository.getMediaContentList(params);
  }
}
