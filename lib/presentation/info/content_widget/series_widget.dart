import 'package:flutter/material.dart';
import 'package:injecktor/injecktor.dart';

import 'package:meiyou/presentation/core/injectktor_widget.dart';
import 'package:meiyou/presentation/info/content_widget/content_widget.dart';
import 'package:meiyou/presentation/info/services/episode_cubit.dart';
import 'package:meiyou/presentation/info/services/episode_list_selector.dart';
import 'package:meiyou/presentation/info/services/season_selector.dart';
import 'package:meiyou/presentation/info/widgets/episode_list.dart';
import 'package:meiyou/presentation/info/widgets/episode_list_selector.dart';
import 'package:meiyou/presentation/info/widgets/season_selector.dart';
import 'package:meiyou_extensions_lib/models.dart';

class SeriesWidget extends InjecktorWidget implements ContentWidget {
  const SeriesWidget({
    super.key,
    required this.content,
    required this.onSelected,
  });

  @override
  final Series content;

  @override
  final void Function() onSelected;

  @override
  Widget build(BuildContext context) {
    addSingleton(context, () => EpisodeCubit(0));
    addSingleton(context, () => SeasonSelectorCubit());
    addSingleton(
        context,
        () => EpisodeListSelectorCubit(
              episodeCubit: InjectKtor.get(),
              episodes: episodes,
            ));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (content.data.length > 1) const SeasonSelector(),
        if (episodes.length > ContentWidget.maxEpisodeLimit)
          const EpisodeListSelector(),
        EpisodesList(
          episodes: episodes,
          onSelected: onSelected,
        ),
      ],
    );
  }

  List<Episode> get episodes =>
      content.data[InjectKtor.get<SeasonSelectorCubit>().state].episodes;
}
