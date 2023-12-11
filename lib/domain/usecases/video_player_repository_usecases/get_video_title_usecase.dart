import 'package:flutter/material.dart';
import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/repositories/video_player_repository.dart';

class GetVideoTitleUseCase implements UseCase<String?, BuildContext> {
  final VideoPlayerRepository _videoPlayerRepository;

  GetVideoTitleUseCase(this._videoPlayerRepository);

  @override
  String? call(BuildContext params) {
    return _videoPlayerRepository.getVideoTitle(params);
  }
}
