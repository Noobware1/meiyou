import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:meiyou/core/constants/animation_duration.dart';
import 'package:meiyou/core/constants/default_sized_box.dart';
import 'package:meiyou/core/resources/snackbar.dart';
// import 'package:meiyou/core/usecases_container/watch_provider_repository_container.dart';
// import 'package:meiyou/core/utils/extenstions/context.dart';
import 'package:meiyou/domain/entities/episode.dart';
// import 'package:meiyou/domain/usecases/provider_use_cases/load_video_extractor_usecase.dart';
import 'package:meiyou/domain/usecases/provider_use_cases/load_video_server_usecase.dart';
import 'package:meiyou/presentation/pages/info_watch/state/source_dropdown_bloc/bloc/source_drop_down_bloc.dart';
import 'package:meiyou/presentation/player/video_controls/cubits/current_episode_cubit.dart';
// import 'package:meiyou/presentation/widgets/add_space.dart';
import 'package:meiyou/presentation/widgets/episode_holder.dart';
import 'package:meiyou/presentation/widgets/episode_view/state/episode_selector/episode_selector_bloc.dart';
import 'package:meiyou/presentation/widgets/episode_view/state/fetch_episodes/fetch_episodes_bloc.dart';
import 'package:meiyou/presentation/widgets/layout_builder.dart';
import 'package:meiyou/presentation/widgets/not_found.dart';
import 'package:meiyou/presentation/widgets/video_server/state/bloc/load_video_server_and_video_container_bloc_bloc.dart';
// import 'package:meiyou/presentation/widgets/season_selector/fetch_seasons_bloc/fetch_seasons_bloc_bloc.dart';
// import 'package:meiyou/presentation/widgets/season_selector/season_selector.dart';
// import 'package:meiyou/presentation/widgets/season_selector/seasons_selector_bloc/seasons_selector_bloc.dart';
// import 'package:meiyou/presentation/widgets/source_dropdown.dart';
import 'package:meiyou/presentation/widgets/video_server/state/fetch_server_bloc/fetch_video_servers_bloc.dart';
import 'package:meiyou/presentation/widgets/video_server_view.dart';
import 'package:meiyou/presentation/widgets/watch/state/fetch_seasons_episodes/fetch_seasons_episodes_bloc.dart';

class AnimeView extends StatelessWidget {
  final void Function(SelectedServer server)? onServerSelected;
  const AnimeView({super.key, this.onServerSelected});

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
        print('lol');
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
        print('lol 2');
        return const Center(child: CircularProgressIndicator());
      }
    });
  }

  Widget _forSmallScreen(BuildContext context, List<EpisodeEntity> episodes) =>
      Padding(
        padding: const EdgeInsets.only(left: 5, right: 5),
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
                      print(episodes[index].url);

                      BlocProvider.of<CurrentEpisodeCubit>(context)
                          .changeEpisode(index);

                      VideoServerListView.showDialog(context, onServerSelected);
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
