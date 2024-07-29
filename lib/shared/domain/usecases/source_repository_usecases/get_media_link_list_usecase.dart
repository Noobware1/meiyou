import 'package:meiyou/core/utils/usecases/async_usecase.dart';
import 'package:meiyou/shared/domain/models/repositories_params/source_repository_params.dart';
import 'package:meiyou/shared/domain/repositories/source_repository.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:nice_dart/nice_dart.dart';

class GetMediaLinkListUsecase
    extends AsyncUseCase<List<MediaLink>, GetMediaLinkListParams> {
  final SourceRepository _sourceRepository;

  GetMediaLinkListUsecase(this._sourceRepository);

  @override
  Future<Result<List<MediaLink>>> call(GetMediaLinkListParams params) =>
      _sourceRepository.getMediaLinkList(params);
}
