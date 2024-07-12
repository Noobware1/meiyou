import 'package:meiyou/core/utils/usecases/async_usecase.dart';
import 'package:meiyou/shared/domain/models/source_repository_params.dart';
import 'package:meiyou/shared/domain/repositories/source_repository.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:nice_dart/nice_dart.dart';

class GetMediaLinksUseCase
    extends AsyncUsecase<List<MediaLink>, GetMediaLinksParams> {
  final SourceRepository _sourceRepository;

  GetMediaLinksUseCase(this._sourceRepository);

  @override
  Future<Result<List<MediaLink>>> call(GetMediaLinksParams params) =>
      _sourceRepository.getMediaLinks(params);
}
