import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/entities/extracted_video_data.dart';
import 'package:meiyou/domain/entities/link_and_source.dart';
import 'package:meiyou/domain/repositories/video_player_repository.dart';

class ConvertExtractedVideoDataListUseCase
    implements
        UseCase<List<LinkAndSourceEntity>, List<ExtractedVideoDataEntity>> {
  final VideoPlayerRepository _repository;

  ConvertExtractedVideoDataListUseCase(this._repository);

  @override
  List<LinkAndSourceEntity> call(List<ExtractedVideoDataEntity> params) {
    return _repository.convertExtractedVideoDataList(params);
  }
}
