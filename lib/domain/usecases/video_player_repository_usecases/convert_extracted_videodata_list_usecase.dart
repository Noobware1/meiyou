import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/entities/extracted_media.dart';
import 'package:meiyou/domain/entities/link_and_source.dart';
import 'package:meiyou/domain/repositories/video_player_repository.dart';

class ConvertExtractedVideoDataListUseCase
    implements
        UseCase<List<LinkAndSourceEntity>, List<ExtractedMediaEntity>> {
  final VideoPlayerRepository _repository;

  ConvertExtractedVideoDataListUseCase(this._repository);

  @override
  List<LinkAndSourceEntity> call(List<ExtractedMediaEntity> params) {
    return _repository.convertExtractedVideoDataList(params);
  }
}
