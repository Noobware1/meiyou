import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';
import 'package:meiyou/data/models/media_item/anime.dart';
import 'package:meiyou/data/models/media_item/tv_series.dart';
import 'package:meiyou/data/repositories/video_player_repository_impl.dart';
import 'package:meiyou/domain/entities/media_details.dart';
import 'package:meiyou/domain/entities/media_item.dart';
import 'package:meiyou/domain/usecases/plugin_manager_usecases/load_link_and_media_use_case.dart';
import 'package:meiyou/presentation/blocs/current_episode_cubit.dart';
import 'package:meiyou/presentation/blocs/episodes_bloc.dart';
import 'package:meiyou/presentation/blocs/episodes_selector_cubit.dart';
import 'package:meiyou/presentation/blocs/player/selected_video_data.dart';
import 'package:meiyou/presentation/blocs/player/server_and_video_cubit.dart';
import 'package:meiyou/presentation/blocs/plugin_selector_cubit.dart';
import 'package:meiyou/presentation/blocs/pluign_manager_usecase_provider_cubit.dart';
import 'package:meiyou/presentation/blocs/season_cubit.dart';
import 'package:meiyou/presentation/providers/video_player_repository_usecases.dart';

class PlayerDependenciesProvider {
  final List<RepositoryProvider> repositories;
  final List<BlocProvider> blocs;

  PlayerDependenciesProvider({required this.repositories, required this.blocs});

  factory PlayerDependenciesProvider.createFromContext(
      BuildContext context, LoadLinkAndMediaStreamUseCaseParams params,
      [int? episodeIndex]) {
    return PlayerDependenciesProvider(repositories: [
      RepositoryProvider<VideoPlayerRepositoryUseCases>(
        lazy: false,
        create: (context) =>
            VideoPlayerRepositoryUseCases(VideoPlayerRepositoryImpl()),
      ),
      RepositoryProvider<MediaDetailsEntity>.value(
          value: context.repository<MediaDetailsEntity>()),
    ], blocs: [
      BlocProvider<ExtractedVideoDataCubit>(
        lazy: false,
        create: (context) {
          return ExtractedVideoDataCubit(context
              .bloc<PluginManagerUseCaseProviderCubit>()
              .state
              .provider!
              .loadLinkAndMediaStreamUseCase
              .call(params));
        },
      ),
      BlocProvider<SelectedVideoDataCubit>(
          create: (context) => SelectedVideoDataCubit()),
      BlocProvider<PluginManagerUseCaseProviderCubit>.value(
          value: context.bloc<PluginManagerUseCaseProviderCubit>()),
      BlocProvider<PluginSelectorCubit>.value(
          value: context.bloc<PluginSelectorCubit>()),
      ..._getBasedOnMediaItem(
          context, context.repository<MediaDetailsEntity>().mediaItem),
      if (episodeIndex != null)
        BlocProvider<CurrentEpisodeCubit>(
          lazy: false,
          create: (context) => CurrentEpisodeCubit(episodeIndex),
        ),
    ]);
  }

  factory PlayerDependenciesProvider.getFromContext(BuildContext context) {
    return PlayerDependenciesProvider(repositories: [
      RepositoryProvider<VideoPlayerRepositoryUseCases>.value(
          value: context.repository<VideoPlayerRepositoryUseCases>()),
      RepositoryProvider<MediaDetailsEntity>.value(
          value: context.repository<MediaDetailsEntity>()),
    ], blocs: [
      BlocProvider<ExtractedVideoDataCubit>.value(
          value: context.bloc<ExtractedVideoDataCubit>()),
      BlocProvider<SelectedVideoDataCubit>.value(
          value: context.bloc<SelectedVideoDataCubit>()),
      BlocProvider<PluginManagerUseCaseProviderCubit>.value(
          value: context.bloc<PluginManagerUseCaseProviderCubit>()),
      BlocProvider<PluginSelectorCubit>.value(
          value: context.bloc<PluginSelectorCubit>()),
      ..._getBasedOnMediaItem(
          context, context.repository<MediaDetailsEntity>().mediaItem),
      if (context.tryBloc<CurrentEpisodeCubit>() != null)
        BlocProvider<CurrentEpisodeCubit>.value(
          value: context.bloc<CurrentEpisodeCubit>(),
        ),
    ]);
  }

  Widget injector(Widget child) {
    return MultiRepositoryProvider(
        providers: repositories,
        child: MultiBlocProvider(providers: blocs, child: child));
  }
}

List<BlocProvider> _getBasedOnMediaItem(
    BuildContext context, MediaItemEntity? mediaItem) {
  if (mediaItem is Anime) {
    return [
      BlocProvider<EpisodesCubit>.value(value: context.bloc<EpisodesCubit>()),
      BlocProvider<EpisodesSelectorCubit>.value(
          value: context.bloc<EpisodesSelectorCubit>())
    ];
  }
  if (mediaItem is TvSeries) {
    return [
      BlocProvider<SeasonCubit>.value(value: context.bloc<SeasonCubit>()),
      BlocProvider<EpisodesCubit>.value(value: context.bloc<EpisodesCubit>()),
      BlocProvider<EpisodesSelectorCubit>.value(
          value: context.bloc<EpisodesSelectorCubit>())
    ];
  }

  return [];
}
