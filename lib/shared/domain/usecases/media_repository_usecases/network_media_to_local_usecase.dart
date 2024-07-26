import 'package:meiyou/core/utils/usecases/async_usecase.dart';
import 'package:meiyou/shared/domain/models/media.dart';
import 'package:meiyou/shared/domain/models/repositories_params/media_repository_params.dart';
import 'package:meiyou/shared/domain/repositories/media_repository.dart';
import 'package:nice_dart/nice_dart.dart';

class NetworkMediaToLocalUseCase
    extends AsyncUsecase<Media, NetworkMediaToLocalParams> {
  final MediaRepository _mediaRepository;

  NetworkMediaToLocalUseCase(this._mediaRepository);

  @override
  Future<Result<Media>> call(NetworkMediaToLocalParams params) {
    return _mediaRepository.networkMediaToLocal(params);
  }
}
