import 'package:flutter/material.dart';
import 'package:injecktor/injecktor.dart';

import 'package:meiyou/presentation/core/injectktor_widget.dart';
import 'package:meiyou/presentation/info/content_widget/content_widget.dart';
import 'package:meiyou/presentation/info/services/episode_cubit.dart';
import 'package:meiyou/presentation/info/services/episode_list_selector.dart';
import 'package:meiyou/presentation/info/widgets/episode_list.dart';
import 'package:meiyou/presentation/info/widgets/episode_list_selector.dart';
import 'package:meiyou_extensions_lib/models.dart';

class AnimeWidget extends InjecktorWidget implements ContentWidget {
  const AnimeWidget({
    super.key,
    required this.content,
    required this.onSelected,
  });

  @override
  final Anime content;

  @override
  final void Function() onSelected;

  @override
  Widget build(BuildContext context) {
    addSingleton(context, () => EpisodeCubit(0));
    addSingleton(
        context,
        () => EpisodeListSelectorCubit(
            episodeCubit: InjectKtor.get(), episodes: content.episodes));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (content.episodes.length > ContentWidget.maxEpisodeLimit)
          const EpisodeListSelector(),
        EpisodesList(episodes: content.episodes, onSelected: onSelected),
      ],
    );
  }
}
