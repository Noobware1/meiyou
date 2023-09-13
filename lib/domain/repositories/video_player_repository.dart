import 'package:meiyou/domain/entities/episode.dart';
import 'package:meiyou/domain/entities/subtitle.dart';
import 'package:meiyou/domain/entities/video.dart';
import 'package:meiyou/domain/usecases/provider_use_cases/get_episode_chunks_usecase.dart';

abstract class VideoPlayerRepository {
  void initialise();

  void dispose();

  VideoEntity getVideo(List<VideoEntity> videos);

  SubtitleEntity? getSubtitle(List<SubtitleEntity>? subtitles);

  SeekEpisodeState? seekEpisode({
    required Map<num, List<EpisodeEntity>> episodeSeasonsMap,
    required bool forward,
    required num currentSeason,
    required String currentEpKey,
    required int currentEpIndex,
    required GetEpisodeChunksUseCase getEpisodeChunksUseCase,
  });
}

class SeekEpisodeState {
  final int currentEpIndex;
  final num currentSeason;
  final String currentEpKey;

  const SeekEpisodeState(
      {required this.currentEpIndex,
      required this.currentSeason,
      required this.currentEpKey});

  @override
  String toString() {
    return 'currentSeason: $currentSeason\ncurrentEpKey: $currentEpKey\ncurrentEpIndex: $currentEpIndex';
  }
}
