import 'dart:convert';

import 'package:meiyou/core/resources/client.dart';
import 'package:meiyou/core/resources/expections.dart';
import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/core/resources/subtitle_decoders/exceptions/subtitle_parsing_expection.dart';
import 'package:meiyou/core/resources/subtitle_decoders/models/cue.dart';
import 'package:meiyou/core/resources/subtitle_decoders/parser/subrip_parser.dart';
import 'package:meiyou/core/resources/subtitle_decoders/parser/webvtt_parser.dart';
import 'package:meiyou/core/resources/subtitle_decoders/subtitle_parser.dart';
import 'package:meiyou/core/resources/subtitle_format.dart';
import 'package:meiyou/core/utils/extenstions/list.dart';
import 'package:meiyou/core/utils/network.dart';
import 'package:meiyou/data/models/subtitle.dart';
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
    return videos.map(Video.formEntity).reduce(
        (high, low) => high.quality.width > low.quality.width ? high : low);
  }

  @override
  SubtitleEntity? getSubtitle(List<SubtitleEntity>? subtitles) {
    if (subtitles == null || subtitles.isEmpty) return null;
    return subtitles.firstWhere((it) => it.lang.toLowerCase().contains('eng'));
  }

  @override
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
          episode: chunks[currentEpKey]![currentEpIndex],
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
            currentEpKey: currentEpKey,
            episode: currentEpisodes[currentEpIndex]);
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
          currentEpKey: currentEpKey,
          episode: chunks[currentEpKey]![currentEpIndex],
        );
      }
    }
  }

  @override
  Future<ResponseState<List<SubtitleCue>>> getSubtitleCues(
      SubtitleEntity subtitle,
      [Map<String, String>? headers]) {
    return tryWithAsync(() async {
      final String subtitleData = utf8
          .decode((await client.get(subtitle.url, headers: headers)).bodyBytes);

      final SubtitleParser parser;
      switch (subtitle.format) {
        case SubtitleFormat.vtt:
          parser = WebVttParser();
          break;
        case SubtitleFormat.srt:
          parser = SubripParser();
          break;
        default:
          throw SubtitleParsingException(
              'Cannot find parser for format ${subtitle.format}');
      }

      return parser.parse(subtitleData);
    });
  }

  @override
  void initialise() {}
}
