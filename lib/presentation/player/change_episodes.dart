import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:meiyou/core/resources/media_type.dart';
import 'package:meiyou/core/resources/snackbar.dart';
import 'package:meiyou/core/usecases_container/video_player_usecase_container.dart';
import 'package:meiyou/core/usecases_container/watch_provider_repository_container.dart';

import 'package:meiyou/core/utils/player_utils.dart';
import 'package:meiyou/domain/repositories/video_player_repository.dart';
import 'package:meiyou/domain/usecases/provider_use_cases/get_episode_chunks_usecase.dart';
import 'package:meiyou/domain/usecases/video_player_usecase/seek_episode.dart';
import 'package:meiyou/presentation/pages/info_watch/state/selected_searchResponse_bloc/selected_search_response_bloc.dart';
import 'package:meiyou/presentation/player/initialise_player.dart';
import 'package:meiyou/presentation/player/video_controls/cubits/current_episode_cubit.dart';
import 'package:meiyou/presentation/player/video_controls/cubits/selected_server_cubit.dart';
import 'package:meiyou/presentation/widgets/episode_view/state/episode_selector/episode_selector_bloc.dart';
import 'package:meiyou/presentation/widgets/season_selector/seasons_selector_bloc/seasons_selector_bloc.dart';
import 'package:meiyou/presentation/widgets/video_server_view.dart';
import 'package:meiyou/presentation/widgets/watch/state/fetch_seasons_episodes/fetch_seasons_episodes_bloc.dart';

void changeEpisode(BuildContext context, bool forward,
    Widget Function(Widget child) injector) {
  //   void _showSnackBar() => showSnackBAr(context,
  final text =
      forward ? 'No Next Episode Avaible' : 'No Previous Episode Avaible';

  if (BlocProvider.of<SelectedSearchResponseBloc>(context)
          .state
          .searchResponse
          .type ==
      MediaType.movie) {
    showSnackBAr(context, text: text);
  }
  // Widget injector(Widget child) =>
  //     playerDependenciesInjector(context, child: child);

  // final seekStateBeforeChange = SeekEpisodeState(
  //     currentEpIndex: BlocProvider.of<CurrentEpisodeCubit>(context).state,
  //     currentSeason: BlocProvider.of<SeasonsSelectorBloc>(context).state.season,
  //     currentEpKey:
  //         BlocProvider.of<EpisodeSelectorBloc>(context).state.current,

  //         );

  final seekState = RepositoryProvider.of<VideoPlayerUseCaseContainer>(context)
      .get<SeekEpisodeUseCase>()
      .call(SeekEpisodeUseCaseParams(
          episodeSeasonsMap:
              BlocProvider.of<FetchSeasonsEpisodesBloc>(context).state.data!,
          forward: forward,
          currentSeason:
              BlocProvider.of<SeasonsSelectorBloc>(context).state.season,
          currentEpKey:
              BlocProvider.of<EpisodeSelectorBloc>(context).state.current,
          currentEpIndex: BlocProvider.of<CurrentEpisodeCubit>(context).state,
          getEpisodeChunksUseCase:
              RepositoryProvider.of<WatchProviderRepositoryContainer>(context)
                  .get<GetEpisodeChunksUseCase>()));

  if (seekState == null) {
    showSnackBAr(context, text: text);
  } else {
    VideoServerListView.showSelectServerDialog(
        context, injector, seekState.episode.url, (value) {
      _setState(context, seekState);
      BlocProvider.of<SelectedServerCubit>(context).changeServer(value);

      initialise(
        context,
        player(context),
        RepositoryProvider.of<VideoController>(context),
      );

   
    });
  }
}

void _setState(BuildContext context, SeekEpisodeState state) {
  BlocProvider.of<SeasonsSelectorBloc>(context).add(SelectSeason(
      state.currentSeason,
      BlocProvider.of<FetchSeasonsEpisodesBloc>(context)
          .state
          .data![state.currentSeason]!));

  BlocProvider.of<EpisodeSelectorBloc>(context).add(SelectEpisode(MapEntry(
      state.currentEpKey,
      BlocProvider.of<SeasonsSelectorBloc>(context)
          .state
          .episodes[state.currentEpKey]!)));

  BlocProvider.of<CurrentEpisodeCubit>(context)
      .changeEpisode(state.currentEpIndex);
}
