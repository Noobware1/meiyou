import 'package:flutter/widgets.dart';
import 'package:injecktor/injecktor.dart';
import 'package:meiyou/presentation/core/episode_holder.dart';
import 'package:meiyou/presentation/core/injectktor_widget.dart';
import 'package:meiyou/presentation/info/services/episode_cubit.dart';
import 'package:meiyou/presentation/info/services/episode_list_selector.dart';
import 'package:meiyou/presentation/info/services/info_screen_cubit.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:nice_dart/nice_dart.dart';

class EpisodesList extends StatelessWidget {
  final List<Episode> episodes;
  final VoidCallback onSelected;
  const EpisodesList({
    super.key,
    required this.episodes,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return InjecktorBlocBuilder<EpisodeListSelectorCubit, Pair<int, int>>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = state.first; i <= state.second; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 5, left: 5, right: 5),
                child: CardHolder.Episode(
                  onTap: () {
                    InjectKtor.get<EpisodeCubit>().select(i);
                    onSelected();
                  },
                  episode: episodes[i],
                  fallbackImage: InjectKtor.get<InfoScreenCubit>()
                      .state
                      .value!
                      .let((it) => it.bannerImage ?? it.posterImage),
                  index: i,
                ),
              )
          ],
        );
      },
    );
  }

  String? get fallbackImage => episodes.first.image;
}
