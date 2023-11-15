import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meiyou/core/resources/media_type.dart';
import 'package:meiyou/core/resources/providers/base_provider.dart';
import 'package:meiyou/core/usecases_container/watch_provider_repository_container.dart';
import 'package:meiyou/data/repositories/watch_provider_repository_impl.dart';
import 'package:meiyou/domain/entities/episode.dart';
import 'package:meiyou/domain/usecases/get_mapped_episodes_usecase.dart';
import 'package:meiyou/domain/usecases/get_mapped_movie.dart';
import 'package:meiyou/domain/usecases/provider_use_cases/find_best_search_response.dart';
import 'package:meiyou/domain/usecases/provider_use_cases/get_episode_chunks_usecase.dart';
import 'package:meiyou/domain/usecases/provider_use_cases/load_movie_usecase.dart';
import 'package:meiyou/domain/usecases/provider_use_cases/load_saved_search_response.dart';
import 'package:meiyou/domain/usecases/provider_use_cases/load_seasons_episodes.dart';
import 'package:meiyou/domain/usecases/provider_use_cases/load_server_and_video_usecase.dart';
import 'package:meiyou/domain/usecases/provider_use_cases/save_search_response.dart';
import 'package:meiyou/domain/usecases/provider_use_cases/search_use_case.dart';
import 'package:meiyou/presentation/pages/info_watch/state/search_response_bloc/bloc/search_response_bloc.dart';
import 'package:meiyou/presentation/pages/info_watch/state/selected_searchResponse_bloc/selected_search_response_bloc.dart';
import 'package:meiyou/presentation/pages/info_watch/state/source_dropdown_bloc/bloc/source_drop_down_bloc.dart';
import 'package:meiyou/presentation/player/video_controls/cubits/current_episode_cubit.dart';
import 'package:meiyou/presentation/widgets/episode_selector/episode_selector.dart';
import 'package:meiyou/presentation/widgets/episode_selector/episode_selector/episode_selector_bloc.dart';
import 'package:meiyou/presentation/widgets/season_selector/bloc/seasons_selector_bloc.dart';
import 'package:meiyou/presentation/widgets/season_selector/season_selector.dart';
import 'package:meiyou/presentation/widgets/video_server/state/load_server_video_bloc/load_video_server_and_video_container_bloc_bloc.dart';
import 'package:meiyou/presentation/widgets/watch/search_response_bottom_sheet.dart';
import 'package:meiyou/presentation/widgets/watch/selected_search_response_widget.dart';
import 'package:meiyou/presentation/widgets/watch/state/fetch_movie_bloc/fetch_movie_bloc.dart';
import 'package:meiyou/presentation/widgets/watch/state/fetch_seasons_episodes/fetch_seasons_episodes_bloc.dart';
import 'package:meiyou/presentation/widgets/watch/watch_view.dart';
import 'initialise_view.dart';

class InitiliseWatchView extends InitialiseView {
  late final WatchProviderRepositoryContainer watchProviderRepositoryContainer =
      WatchProviderRepositoryContainer(WatchProviderRepositoryImpl(media));

  late final SeasonsSelectorBloc seasonsSelectorBloc = SeasonsSelectorBloc(
      watchProviderRepositoryContainer.get<GetEpisodeChunksUseCase>(),
      episodeSelectorBloc);

  late final FetchSeasonsEpisodesBloc fetchSeasonsEpisodesBloc =
      FetchSeasonsEpisodesBloc(
          loadSeasonsEpisodesUseCase: watchProviderRepositoryContainer
              .get<LoadSeasonsEpisodesUseCase>(),
          cacheRespository: cacheRespository,
          seasonsSelectorBloc: seasonsSelectorBloc,
          getMappedEpisodesUseCase:
              metaProviderRepositoryContainer.get<GetMappedEpisodesUseCase>());

  late final FetchMovieBloc fetchMovieBloc = FetchMovieBloc(
    loadMovieUseCase: watchProviderRepositoryContainer.get<LoadMovieUseCase>(),
    getMappedMovieUseCase:
        metaProviderRepositoryContainer.get<GetMappedMovie>(),
  );

  late final SelectedSearchResponseBloc selectedSearchResponseBloc =
      SelectedSearchResponseBloc(
          loadSavedSearchResponseUseCase: watchProviderRepositoryContainer
              .get<LoadSavedSearchResponseUseCase>(),
          savePath: appDirectories.savedSelectedResponseDirectory.path,
          findBestSearchResponseUseCase: watchProviderRepositoryContainer
              .get<FindBestSearchResponseUseCase>(),
          mediaTitle: media.mediaTitle,
          cacheRespository: cacheRespository,
          saveSearchResponseUseCase: watchProviderRepositoryContainer
              .get<SaveSearchResponseUseCase>());

  late final SearchResponseBloc searchResponseBloc = SearchResponseBloc(
    providerSearchUseCase:
        watchProviderRepositoryContainer.get<LoadSearchUseCase>(),
    bloc: selectedSearchResponseBloc,
    mediaTitle: media.mediaTitle,
    cacheRespository: cacheRespository,
    // loadS/get<LoadSavedSearchResponseUseCase>()
  );

  late final videoServerBloc = LoadVideoServerAndVideoContainerBloc(
      watchProviderRepositoryContainer.get<LoadServerAndVideoUseCase>(),
      cacheRespository);

  final EpisodeSelectorBloc episodeSelectorBloc =
      EpisodeSelectorBloc(const MapEntry('', <EpisodeEntity>[]));

  InitiliseWatchView(
      {required super.media,
      required super.cacheRespository,
      required super.appDirectories,
      required super.metaProviderRepositoryContainer,
      required super.sourceDropDownBloc});

  StreamSubscription<SourceDropDownState>? _sourceDropDownSubscription;
  StreamSubscription<SelectedSearchResponseState>?
      _seletedSearchResponseSubscription;
  // StreamSubscription<FetchEpisodesState>? _fetchEpisodesSubscription;

  @override
  List<Widget> get selectors => const [
        SeasonSelector(),
        SizedBox(
          height: 10,
        ),
        EpisodeSelector()
      ];

  BaseProvider? _provider;

  @override
  Widget get search => SearchResponseBottomSheet(
        bloc: searchResponseBloc,
        sourceDropDownBloc: sourceDropDownBloc,
        selectedSearchResponseBloc: selectedSearchResponseBloc,
      );

  @override
  void initalise() {
    _sourceDropDownSubscription =
        sourceDropDownBloc.stream.listen((sourceDropDownState) {
      _provider = sourceDropDownState.provider;
      searchResponseBloc.add(SearchResponseSearch(provider: _provider!));
    });
    _seletedSearchResponseSubscription =
        selectedSearchResponseBloc.stream.listen((selectedSearchResponseState) {
      final searchResponse = selectedSearchResponseState.searchResponse;
      if ((selectedSearchResponseState is SelectedSearchResponseFound ||
              selectedSearchResponseState is SelectedSearchResponseSelected) &&
          !searchResponse.isEmpty) {
        switch (searchResponse.type) {
          case MediaType.tvShow:
          case MediaType.anime:
            fetchSeasonsEpisodesBloc.add(FetchSeasonsEpisodes(
              _provider!,
              searchResponse,
            ));
            fetchMovieBloc.add(const ClearFetchMovieState());
            break;
          case MediaType.movie:
            fetchMovieBloc.add(FetchMovie(
                mediaDetails: media,
                loadMovieParams: LoadMovieParams(
                    provider: _provider!,
                    url: searchResponse.url,
                    cacheRepository: cacheRespository)));
            fetchSeasonsEpisodesBloc
                .add(const ClearFetchSeasonsEpisodesState());
            break;
          default:
            break;
        }
      }
    });
  }

  final CurrentEpisodeCubit currentEpisodeCubit = CurrentEpisodeCubit();

  @override
  Widget get selectedSearchResponseWidget =>
      SelectedSearchResponseWidgetForWatchView(
          selectedSearchResponseBloc: selectedSearchResponseBloc);

  @override
  Widget get view => const WatchView();

  @override
  Widget createBlocProvider({required Widget child}) {
    return RepositoryProvider(
      create: (context) => watchProviderRepositoryContainer,
      child: MultiBlocProvider(providers: [
        BlocProvider.value(value: sourceDropDownBloc),
        BlocProvider.value(value: selectedSearchResponseBloc),
        BlocProvider.value(value: fetchMovieBloc),
        BlocProvider.value(value: fetchSeasonsEpisodesBloc),
        BlocProvider.value(value: videoServerBloc),
        BlocProvider.value(value: seasonsSelectorBloc),
        BlocProvider.value(value: episodeSelectorBloc),
        BlocProvider.value(value: currentEpisodeCubit),
      ], child: child),
    );
  }

  @override
  void inject(List list) {
    for (var it in [
      BlocProvider.value(value: selectedSearchResponseBloc),
      BlocProvider.value(value: fetchMovieBloc),
      BlocProvider.value(value: seasonsSelectorBloc),
    ]) {
      list.add(it);
    }
  }

  @override
  void dispose() {
    _seletedSearchResponseSubscription?.cancel();
    _sourceDropDownSubscription?.cancel();
    selectedSearchResponseBloc.close();
    fetchMovieBloc.close();
    fetchSeasonsEpisodesBloc.close();
    seasonsSelectorBloc.close();
    sourceDropDownBloc.close();
    currentEpisodeCubit.close();
    videoServerBloc.close();
    _provider = null;
  }
}
