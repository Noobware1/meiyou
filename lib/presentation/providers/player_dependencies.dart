import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';
import 'package:meiyou/data/repositories/video_player_repository_impl.dart';
import 'package:meiyou/domain/usecases/plugin_repository_usecases/load_extracted_media_usecase.dart';
import 'package:meiyou/presentation/blocs/current_episode_cubit.dart';
import 'package:meiyou/presentation/blocs/episodes_bloc.dart';
import 'package:meiyou/presentation/blocs/episodes_selector_cubit.dart';
import 'package:meiyou/presentation/blocs/player/selected_video_data.dart';
import 'package:meiyou/presentation/blocs/player/server_and_video_cubit.dart';
import 'package:meiyou/presentation/blocs/plugin_selector_cubit.dart';
import 'package:meiyou/presentation/blocs/pluign_manager_usecase_provider_cubit.dart';
import 'package:meiyou/presentation/blocs/season_cubit.dart';
import 'package:meiyou/presentation/providers/video_player_repository_usecases.dart';
import 'package:meiyou_extensions_lib/models.dart';

class PlayerDependenciesProvider {
  final List<RepositoryProvider> repositories;
  final List<BlocProvider> blocs;

  PlayerDependenciesProvider({required this.repositories, required this.blocs});

  factory PlayerDependenciesProvider.createFromContext(
      BuildContext context, LoadExtractedMediaStreamUseCaseParams params,
      [int? episodeIndex]) {
    return PlayerDependenciesProvider(repositories: [
      RepositoryProvider<VideoPlayerRepositoryUseCases>(
        lazy: false,
        create: (context) =>
            VideoPlayerRepositoryUseCases(VideoPlayerRepositoryImpl()),
      ),
      RepositoryProvider<MediaDetails>.value(
          value: context.repository<MediaDetails>()),
    ], blocs: [
      BlocProvider<ExtractedMediaCubit<Video>>(
        lazy: false,
        create: (context) {
          return ExtractedMediaCubit<Video>(context
              .bloc<PluginRepositoryUseCaseProviderCubit>()
              .state
              .provider!
              .loadExtractedMediaStreamUseCase
              .call(params));
        },
      ),
      BlocProvider<SelectedVideoDataCubit>(
          create: (context) => SelectedVideoDataCubit()),
      BlocProvider<PluginRepositoryUseCaseProviderCubit>.value(
          value: context.bloc<PluginRepositoryUseCaseProviderCubit>()),
      BlocProvider<PluginSelectorCubit>.value(
          value: context.bloc<PluginSelectorCubit>()),
      ..._getBasedOnMediaItem(
          context, context.repository<MediaDetails>().mediaItem),
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
      RepositoryProvider<MediaDetails>.value(
          value: context.repository<MediaDetails>()),
    ], blocs: [
      BlocProvider<ExtractedMediaCubit<Video>>.value(
          value: context.bloc<ExtractedMediaCubit<Video>>()),
      BlocProvider<SelectedVideoDataCubit>.value(
          value: context.bloc<SelectedVideoDataCubit>()),
      BlocProvider<PluginRepositoryUseCaseProviderCubit>.value(
          value: context.bloc<PluginRepositoryUseCaseProviderCubit>()),
      BlocProvider<PluginSelectorCubit>.value(
          value: context.bloc<PluginSelectorCubit>()),
      ..._getBasedOnMediaItem(
          context, context.repository<MediaDetails>().mediaItem),
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
    BuildContext context, MediaItem? mediaItem) {
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
