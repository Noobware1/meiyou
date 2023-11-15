import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/entities/episode.dart';
import 'package:meiyou/domain/repositories/video_player_repository.dart';
import 'package:meiyou/domain/usecases/provider_use_cases/get_episode_chunks_usecase.dart';

class SeekEpisodeUseCaseParams {
  final Map<num, List<EpisodeEntity>> episodeSeasonsMap;
  final bool forward;
  final num currentSeason;
  final String currentEpKey;
  final int currentEpIndex;
  final GetEpisodeChunksUseCase getEpisodeChunksUseCase;
  const SeekEpisodeUseCaseParams(
      {required this.episodeSeasonsMap,
      required this.forward,
      required this.currentSeason,
      required this.currentEpKey,
      required this.currentEpIndex,
      required this.getEpisodeChunksUseCase});
}

class SeekEpisodeUseCase
    extends UseCase<SeekEpisodeState?, SeekEpisodeUseCaseParams> {
  final VideoPlayerRepository _repository;

  SeekEpisodeUseCase(this._repository);

  @override
  SeekEpisodeState? call(SeekEpisodeUseCaseParams params) {
    return _repository.seekEpisode(
      episodeSeasonsMap: params.episodeSeasonsMap,
      forward: params.forward,
      currentSeason: params.currentSeason,
      currentEpKey: params.currentEpKey,
      currentEpIndex: params.currentEpIndex,
      getEpisodeChunksUseCase: params.getEpisodeChunksUseCase,
    );
  }
}
