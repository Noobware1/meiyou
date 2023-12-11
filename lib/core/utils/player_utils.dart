// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:media_kit_video/media_kit_video.dart';
// import 'package:meiyou/core/resources/media_type.dart';
// import 'package:meiyou/core/usecases_container/watch_provider_repository_container.dart';
// import 'package:meiyou/domain/repositories/cache_repository.dart';
// import 'package:meiyou/presentation/player/video_controls/subtitle_woker_bloc/subtitle_worker_bloc.dart';

// import 'package:meiyou/presentation/pages/info_watch/state/selected_searchResponse_bloc/selected_search_response_bloc.dart';
// import 'package:meiyou/presentation/pages/info_watch/state/source_dropdown_bloc/bloc/source_drop_down_bloc.dart';
// import 'package:meiyou/presentation/player/initialise_player.dart';
// import 'package:meiyou/presentation/player/video_controls/cubits/current_episode_cubit.dart';
// import 'package:meiyou/presentation/player/video_controls/cubits/is_ready.dart';
// import 'package:meiyou/presentation/player/video_controls/cubits/resize_mode_cubit.dart';
// import 'package:meiyou/presentation/player/video_controls/cubits/selected_server_cubit.dart';
// import 'package:meiyou/presentation/player/video_controls/video_controls_theme.dart';
// import 'package:media_kit/media_kit.dart';
// import 'package:meiyou/presentation/widgets/episode_selector/episode_selector/episode_selector_bloc.dart';
// import 'package:meiyou/presentation/widgets/season_selector/bloc/seasons_selector_bloc.dart';
// import 'package:meiyou/presentation/widgets/video_server/state/load_server_video_bloc/load_video_server_and_video_container_bloc_bloc.dart';
// import 'package:meiyou/presentation/widgets/video_server/video_server_view.dart';
// import 'package:meiyou/presentation/widgets/watch/state/fetch_movie_bloc/fetch_movie_bloc.dart';
// import 'package:meiyou/presentation/widgets/watch/state/fetch_seasons_episodes/fetch_seasons_episodes_bloc.dart';

// void startAnimation(AnimationController controller) {
//   if (controller.isAnimating) {
//     controller.reset();
//   }
//   controller.forward().then((_) => controller.reset());
// }

// VideoPlayerControlsTheme theme(BuildContext context) {
//   return RepositoryProvider.of<VideoPlayerControlsTheme>(context);
// }

// Player player(BuildContext context) {
//   return RepositoryProvider.of<Player>(context);
// }

// BoxFit resize(ResizeMode mode) {
//   switch (mode) {
//     case ResizeMode.stretch:
//       return BoxFit.fill;
//     case ResizeMode.zoom:
//       return BoxFit.cover;
//     case ResizeMode.normal:
//     default:
//       return BoxFit.contain;
//     // return BoxFit.contain;
//   }
// }

// showVideoServers(BuildContext context) {
//   final pos = player(context).state.position;

//   VideoServerListView.showDialog(
//       context,
//       BlocProvider.of<SelectedSearchResponseBloc>(context)
//                   .state
//                   .searchResponse
//                   .type ==
//               MediaType.movie
//           ? BlocProvider.of<FetchMovieBloc>(context).state.movie!.url
//           : BlocProvider.of<EpisodeSelectorBloc>(context)
//               .state
//               .episodes[BlocProvider.of<CurrentEpisodeCubit>(context).state]
//               .url, (value) {
//     if (!_isSame(BlocProvider.of<SelectedServerCubit>(context).state, value)) {
//       BlocProvider.of<SelectedServerCubit>(context).changeServer(value);

//       initialise(
//         context,
//         player(context),
//         RepositoryProvider.of<VideoController>(context),
//         BlocProvider.of<IsPlayerReady>(context),
//         BlocProvider.of<SubtitleWorkerBloc>(context),
//         pos,
//       );
//     }
//   });
// }

// Widget playerDependenciesInjector(BuildContext context,
//     {required Widget child}) {
//   return MultiRepositoryProvider(
//       providers: [
//         RepositoryProvider.value(
//           value:
//               RepositoryProvider.of<WatchProviderRepositoryContainer>(context),
//         ),
//         RepositoryProvider.value(
//             value: RepositoryProvider.of<CacheRespository>(context))
//       ],
//       child: MultiBlocProvider(
//         providers: [
//           BlocProvider.value(
//               value: BlocProvider.of<LoadVideoServerAndVideoContainerBloc>(
//                   context)),
//           BlocProvider.value(
//               value: BlocProvider.of<SelectedSearchResponseBloc>(context)),

//           BlocProvider.value(
//             value: BlocProvider.of<FetchSeasonsEpisodesBloc>(context),
//           ),
//           BlocProvider.value(
//               value: BlocProvider.of<SeasonsSelectorBloc>(context)),
//           BlocProvider.value(
//               value: BlocProvider.of<EpisodeSelectorBloc>(context)),
//           // BlocProvider.value(
//           //     value: BlocProvider.of<FetchVideoServersBloc>(context)),
//           BlocProvider.value(
//               value: BlocProvider.of<SourceDropDownBloc>(context)),
//           BlocProvider.value(value: BlocProvider.of<FetchMovieBloc>(context)),
//           BlocProvider.value(
//               value: BlocProvider.of<CurrentEpisodeCubit>(context)),
//         ],
//         child: child,
//       ));
// }

// bool _isSame(SelectedServer currentState, SelectedServer value) {
//   if (value.videoContainerEntity != currentState.videoContainerEntity ||
//       value.videoContainerEntity.videos[value.selectedVideoIndex] !=
//           currentState
//               .videoContainerEntity.videos[currentState.selectedVideoIndex]) {
//     return false;
//   }
//   return true;
// }
