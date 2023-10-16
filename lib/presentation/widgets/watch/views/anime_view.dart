import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meiyou/core/constants/default_sized_box.dart';
import 'package:meiyou/core/resources/snackbar.dart';
import 'package:meiyou/core/utils/add_padding_onrientation_change.dart';
import 'package:meiyou/domain/entities/episode.dart';
import 'package:meiyou/presentation/player/video_controls/cubits/current_episode_cubit.dart'; // import 'package:meiyou/presentation/widgets/add_space.dart';
import 'package:meiyou/presentation/widgets/episode_holder.dart';
import 'package:meiyou/presentation/widgets/episode_selector/episode_selector/episode_selector_bloc.dart';
import 'package:meiyou/presentation/widgets/layout_builder.dart';
import 'package:meiyou/presentation/widgets/not_found.dart';
import 'package:meiyou/presentation/widgets/video_server/video_server_view.dart';
import 'package:meiyou/presentation/widgets/watch/state/fetch_seasons_episodes/fetch_seasons_episodes_bloc.dart';

class AnimeView extends StatelessWidget {
  final void Function(SelectedServer server)? onServerSelected;

  final void Function(EpisodeEntity episode)? onEpisodeSelected;
  const AnimeView({super.key, this.onServerSelected, this.onEpisodeSelected});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FetchSeasonsEpisodesBloc, FetchSeasonsEpisodesState>(
        listener: (context, state) {
      if (state is FetchSeasonsEpisodesFailed) {
        showSnackBAr(context, text: state.error.toString());
      }
    }, builder: (context, state) {
      if (state is FetchSeasonsEpisodesFailed) {
        return const NotFound();
      } else if (state is FetchSeasonsEpisodesSucess) {
        return BlocBuilder<EpisodeSelectorBloc, EpisodeSelectorState>(
            builder: (context, state) {
          if (state.current.isEmpty && state.episodes.isEmpty) {
            return defaultSizedBox;
          } else {
            return ResponsiveBuilder(
              forSmallScreen: _forSmallScreen(context, state.episodes),
              forLagerScreen: buildEpisodes(context, state.episodes),
            );
          }
        });
      } else {
        return const Center(child: CircularProgressIndicator());
      }
    });
  }

  Widget _forSmallScreen(BuildContext context, List<EpisodeEntity> episodes) =>
      Padding(
        padding: addPaddingOnOrientation(context,
            defaultPadding: const EdgeInsets.only(left: 2, right: 2)),
        child: buildEpisodes(context, episodes),
      );

  Widget buildEpisodes(BuildContext context, List<EpisodeEntity> episodes) =>
      Column(
        children: List.generate(
            episodes.length,
            (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: EpisodeHolder(
                    onTap: () {
                      if (onEpisodeSelected != null) {
                        onEpisodeSelected!.call(episodes[index]);
                      } else {
                        BlocProvider.of<CurrentEpisodeCubit>(context)
                            .changeEpisode(index);
                      }
                      VideoServerListView.showDialog(
                          context, episodes[index].url, onServerSelected);
                    },
                    number: episodes[index].number,
                    desc: episodes[index].desc,
                    rated: episodes[index].rated,
                    thumbnail: episodes[index].thumbnail,
                    title: episodes[index].title,
                  ),
                )),
      );
}
