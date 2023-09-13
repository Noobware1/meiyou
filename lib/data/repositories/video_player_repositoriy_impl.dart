import 'package:meiyou/core/utils/extenstions/list.dart';
import 'package:meiyou/data/models/video.dart';
import 'package:meiyou/domain/entities/episode.dart';
import 'package:meiyou/domain/entities/subtitle.dart';
import 'package:meiyou/domain/entities/video.dart';
import 'package:meiyou/domain/repositories/video_player_repository.dart';
import 'package:meiyou/domain/usecases/provider_use_cases/get_episode_chunks_usecase.dart';

class VideoPlayerRepositoryImpl implements VideoPlayerRepository {
  @override
  void dispose() {
    // TODO: implement dispose
  }

  @override
  Video getVideo(List<VideoEntity> videos) {
    assert(videos.isNotEmpty);
    if (videos.length == 1) {
      return Video.formEntity(videos[0]);
    }
    return videos.map(Video.formEntity).reduce((high, low) =>
        high.quality.quaility > low.quality.quaility ? high : low);
  }

  @override
  SubtitleEntity? getSubtitle(List<SubtitleEntity>? subtitles) {
    if (subtitles == null) return null;
    return subtitles.firstWhere((it) => it.lang.toLowerCase().contains('eng'));
  }

  SeekEpisodeState? seekEpisode({
    required Map<num, List<EpisodeEntity>> episodeSeasonsMap,
    required bool forward,
    required num currentSeason,
    required String currentEpKey,
    required int currentEpIndex,
    required GetEpisodeChunksUseCase getEpisodeChunksUseCase,
  }) {
    var chunks =
        getEpisodeChunksUseCase.call(episodeSeasonsMap[currentSeason]!);
    currentEpIndex = forward ? currentEpIndex + 1 : currentEpIndex - 1;

    //checks if episode to seek is present in the current episodes chunk
    if (chunks[currentEpKey]!.containsIndex(currentEpIndex)) {
      return SeekEpisodeState(
          currentEpIndex: currentEpIndex,
          currentSeason: currentSeason,
          currentEpKey: currentEpKey);
    } else {
      //checks if episode to seek is present int the next episode chunk
      final keys = chunks.keys.toList();
      currentEpIndex = forward
          ? keys.indexOf(currentEpKey) + 1
          : keys.indexOf(currentEpKey) - 1;
      if (keys.containsIndex(currentEpIndex)) {
        currentEpKey = keys[currentEpIndex];
        final currentEpisodes = chunks[currentEpKey]!;

        currentEpIndex =
            forward ? 0 : currentEpisodes.indexOf(currentEpisodes.last);
        return SeekEpisodeState(
            currentEpIndex: currentEpIndex,
            currentSeason: currentSeason,
            currentEpKey: currentEpKey);
      } else {
//checks if the episode to seek is present in the next seasons episode chunk
        final keys = episodeSeasonsMap.keys.toList();
        currentEpIndex = forward
            ? keys.indexOf(currentSeason) + 1
            : keys.indexOf(currentSeason) - 1;
        if (!keys.containsIndex(currentEpIndex)) {
          return null;
        }

        currentSeason = keys[currentEpIndex];
        chunks =
            getEpisodeChunksUseCase.call(episodeSeasonsMap[currentSeason]!);
        currentEpKey = forward ? chunks.keys.first : chunks.keys.last;
        currentEpIndex = forward
            ? 0
            : chunks[currentEpKey]!.indexOf(chunks[currentEpKey]!.last);

        return SeekEpisodeState(
            currentEpIndex: currentEpIndex,
            currentSeason: currentSeason,
            currentEpKey: currentEpKey);
      }
    }
  }

  @override
  void initialise() {}
}

