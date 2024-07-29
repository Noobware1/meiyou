import 'package:meiyou/core/utils/usecases/async_usecase.dart';
import 'package:meiyou/shared/domain/models/repositories_params/source_repository_params.dart';
import 'package:meiyou/shared/domain/repositories/source_repository.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:nice_dart/nice_dart.dart';

class GetMediaAssetUseCase
    extends AsyncUseCase<MediaAsset?, GetMediaAssetsParams> {
  final SourceRepository _sourceRepository;

  GetMediaAssetUseCase(this._sourceRepository);

  @override
  Future<Result<MediaAsset?>> call(GetMediaAssetsParams params) {
    return _sourceRepository.getMediaAsset(params);
  }
}
