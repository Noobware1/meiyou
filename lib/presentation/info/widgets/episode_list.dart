import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:meiyou/core/utils/resources/get_it/get_it.dart';
import 'package:meiyou/domain/models/p.dart';

import 'package:meiyou/domain/models/progress.dart';
import 'package:meiyou/presentation/core/card_holder.dart';
import 'package:meiyou/presentation/core/getIt_widget.dart';
import 'package:meiyou/presentation/info/content_widget/content_widget.dart';
import 'package:meiyou/presentation/info/services/episode_notifer.dart';
import 'package:meiyou/presentation/info/services/episode_list_selector.dart';
import 'package:meiyou/presentation/info/services/info_screen_notifer.dart';
import 'package:meiyou/presentation/info/widgets/episode_list_selector.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:nice_dart/nice_dart.dart';

class EpisodesList extends StatelessWidget {
  final List<Episode> episodes;
  final Map<int, EpisodeProgress>? progress;
  final VoidCallback onSelected;
  const EpisodesList({
    super.key,
    required this.episodes,
    required this.onSelected,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return GetItListenableBuilder<EpisodeListSelectorNotifer, Pair<int, int>>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (episodes.length > ContentWidget.maxEpisodeLimit)
              const EpisodeListSelector(),
            for (var i = state.first; i <= state.second; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: CardHolder.Episode(
                  onTap: () {
                    getIt.get<EpisodeNotifer>().select(i);
                    onSelected();
                  },
                  episode: episodes[i],
                  fallbackImage: getIt
                      .get<InfoScreenNotifer>()
                      .state
                      .value!
                      .let((it) => it.bannerImage ?? it.posterImage),
                  index: i,
                  progress: progress?[i],
                ),
              )
          ],
        );
      },
    );
  }

  String? get fallbackImage => episodes.first.image;
}
