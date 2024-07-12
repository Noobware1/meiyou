import 'package:meiyou/core/database/database.dart';
import 'package:meiyou/core/utils/resources/get_it/get_it.dart';
import 'package:meiyou/domain/models/p.dart';
import 'package:meiyou/extension/models/entension_type.dart';
import 'package:meiyou/presentation/home/source_selector/selected_source.dart';
import 'package:meiyou/presentation/info/services/episode_list_selector.dart';
import 'package:meiyou/presentation/info/services/episode_notifer.dart';
import 'package:meiyou/presentation/info/services/info_screen_notifer.dart';
import 'package:meiyou/presentation/info/services/season_selector.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:nice_dart/nice_dart.dart';

class ProgressRepository {
  final DataBase dataBase;

  ProgressRepository(this.dataBase);

  ContentProgress? getContentProgress(
    int sourceId,
    ExtensionType type,
    String title,
    Content content,
  ) {
    final id = _getId(sourceId, type, title);
    return content.when(
        movie: (_) => dataBase.movieProgress.getSync(id),
        series: (_) => dataBase.seriesProgress.getSync(id),
        anime: (_) => dataBase.animeProgress.getSync(id),
        lazy: (_) => null);
  }

  int _getId(
    int sourceId,
    ExtensionType type,
    String title,
  ) {
    return sourceId.hashCode ^ type.hashCode ^ title.hashCode;
  }

  String saveProgress(int position, int total) {
    final infoPage = getIt.get<InfoScreenNotifer>().state.value!;
    final (sourceId, type) =
        getIt.get<SelectedSource>().let((it) => (it.source!.id, it.type));

    final prevProgress = getContentProgress(
      sourceId,
      type,
      infoPage.name,
      infoPage.content!,
    );
    final progressId =
        prevProgress?.id ?? _getId(sourceId, type, infoPage.name);

    final (contentProgress, progressString) = infoPage.content!.when(
        movie: (_) => (
              MovieProgress(
                id: progressId,
                positionMilliseconds: position,
                durationMilliseconds: total,
              ),
              ''
            ),
        series: (series) {
          final season = getIt.get<SeasonSelectorNotifer>().state;
          final seasonNumber = series.data[season].season.number ?? season + 1;
          final episodeList = getIt.get<EpisodeListSelectorNotifer>().index;
          final lastSeenEpisode = getIt.get<EpisodeNotifer>().state;
          final episodeNumber =
              series.data[season].episodes[lastSeenEpisode].number ??
                  lastSeenEpisode + 1;
          final List<SeasonProgress> seasonProgress =
              prevProgress is! SeriesProgress
                  ? []
                  : prevProgress.seasonProgress;

          final currentSeasonProgress = seasonProgress
              .indexWhere(
            (element) => element.seasonIndex == season,
          )
              .let((it) {
            final SeasonProgress newSeasonProgress;
            var index = it;
            if (index == -1) {
              index = seasonProgress.length;
              newSeasonProgress = SeasonProgress(
                seasonIndex: season,
                episodeProgress: [],
              );
              seasonProgress.add(newSeasonProgress);
            }
            return seasonProgress[index];
          });

          currentSeasonProgress.episodeProgress
              .indexWhere((element) => element.episodeIndex == lastSeenEpisode)
              .let((it) {
            var index = it;
            if (index == -1) {
              index = currentSeasonProgress.episodeProgress.length;
              currentSeasonProgress.episodeProgress.add(EpisodeProgress(
                episodeIndex: lastSeenEpisode,
              ));
            }
            final episode = currentSeasonProgress.episodeProgress[index];
            currentSeasonProgress.episodeProgress[index] = episode.copyWith(
              positionMilliseconds: position,
              durationMilliseconds: total,
            );
          });

          return (
            SeriesProgress(
              id: progressId,
              seasonIndex: season,
              episodeIndex: lastSeenEpisode,
              episodeListIndex: episodeList,
              seasonProgress: seasonProgress,
            ),
            'S:${seasonNumber}E:$episodeNumber'
          );
        },
        anime: (anime) {
          final episode = getIt.get<EpisodeNotifer>().state;
          final episodeNumber = anime.episodes[episode].number ?? episode + 1;
          final episodeList = getIt.get<EpisodeListSelectorNotifer>().index;
          final List<EpisodeProgress> episodeProgress =
              prevProgress is! AnimeProgress
                  ? []
                  : prevProgress.episodeProgress;

          final index = episodeProgress
              .indexWhere((element) => element.episodeIndex == episode)
              .let((it) {
            var index = it;
            if (index == -1) {
              index = episodeProgress.length;
              episodeProgress.add(EpisodeProgress(episodeIndex: episode));
            }
            return index;
          });

          episodeProgress[index] = episodeProgress[index].copyWith(
            positionMilliseconds: position,
            durationMilliseconds: total,
          );

          return (
            AnimeProgress(
              id: progressId,
              episodeListIndex: episodeList,
              episodeIndex: episode,
              episodeProgress: episodeProgress,
            ),
            'Ep: $episodeNumber'
          );
        },
        lazy: (_) => throw Exception('Not supported'));

    dataBase.writeProgress(contentProgress);
    return progressString;
  }
}
