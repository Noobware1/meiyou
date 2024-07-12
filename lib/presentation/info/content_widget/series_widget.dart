import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/resources/get_it/get_it.dart';

import 'package:meiyou/domain/models/progress.dart';

import 'package:meiyou/presentation/core/getIt_widget.dart';
import 'package:meiyou/presentation/info/content_widget/content_widget.dart';
import 'package:meiyou/presentation/info/services/episode_notifer.dart';
import 'package:meiyou/presentation/info/services/episode_list_selector.dart';
import 'package:meiyou/presentation/info/services/season_selector.dart';
import 'package:meiyou/presentation/info/widgets/episode_list.dart';
import 'package:meiyou/presentation/info/widgets/episode_list_selector.dart';
import 'package:meiyou/presentation/info/widgets/season_selector.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:nice_dart/nice_dart.dart';

class SeriesWidget extends StatelessWidget implements ContentWidget {
  const SeriesWidget({
    super.key,
    required this.content,
    required this.contentProgress,
    required this.onSelected,
  });

  static void registerWith(Series series, SeriesProgress? progress) {
    getIt.registerSingleton(SeasonSelectorNotifer(progress?.lastSeenSeason));
    getIt.registerSingleton(EpisodeNotifer(0));
    getIt.registerSingleton(EpisodeListSelectorNotifer(
        index: progress?.let(
                (it) => it.progress[it.lastSeenSeason]?.episodeListIndex) ??
            0,
        episodeNotifer: getIt.get(),
        episodes: _episodes(series)));
  }

  static void unregister() {
    getIt.unregisterIfRegistered<SeasonSelectorNotifer>();
    getIt.unregisterIfRegistered<EpisodeNotifer>();
    getIt.unregisterIfRegistered<EpisodeListSelectorNotifer>();
  }

  @override
  final Series content;

  @override
  final void Function() onSelected;

  @override
  final SeriesProgress? contentProgress;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (content.data.length > 1) const SeasonSelector(),
        GetItListenableBuilder<SeasonSelectorNotifer, int>(
            builder: (context, state) {
          return EpisodesList(
            episodes: _episodes(content, state),
            onSelected: onSelected,
            progress: contentProgress?.progress[state]?.episodeProgresses,
          );
        })
      ],
    );
  }

  static List<Episode> _episodes(Series series, [int? season]) {
    return series
        .data[season ?? getIt.get<SeasonSelectorNotifer>().state].episodes;
  }
}
