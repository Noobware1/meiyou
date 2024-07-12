import 'package:meiyou/core/utils/usecases/async_usecase.dart';
import 'package:meiyou/shared/domain/models/source_repository_params.dart';
import 'package:meiyou/shared/domain/repositories/source_repository.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:nice_dart/nice_dart.dart';

class GetMediaDetailsUseCase extends AsyncUsecase<MediaDetails, GetMediaDetailsParams> {
  final SourceRepository _sourceRepository;

  GetMediaDetailsUseCase(this._sourceRepository);

  @override
  Future<Result<MediaDetails>> call(GetMediaDetailsParams params) =>
      _sourceRepository.getMediaDetails(params);
}
