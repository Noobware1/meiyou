import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meiyou/core/resources/media_type.dart';
import 'package:meiyou/domain/entities/media_details.dart';
import 'package:meiyou/domain/entities/search_response.dart';
import 'package:meiyou/domain/repositories/cache_repository.dart';
import 'package:meiyou/domain/repositories/meta_provider_repository.dart';
import 'package:meiyou/domain/repositories/watch_provider_repository.dart';
import 'package:meiyou/domain/usecases/provider_use_cases/load_seasons_use_case.dart';
import 'package:meiyou/presentation/widgets/episode_view/bloc/fetch_episodes/fetch_episodes_bloc.dart';
import 'package:meiyou/presentation/widgets/season_selector/fetch_seasons_bloc/fetch_seasons_bloc_bloc.dart';
import 'package:meiyou/presentation/widgets/season_selector/season_selector.dart';
import 'package:meiyou/presentation/widgets/season_selector/seasons_selector_bloc/seasons_selector_bloc.dart';

class WatchView extends StatefulWidget {
  final SearchResponseEntity searchResponse;
  const WatchView({super.key, required this.searchResponse});

  @override
  State<WatchView> createState() => _WatchViewState();
}

class _WatchViewState extends State<WatchView> {
  late final WatchProviderRepository _watchProviderRepository;
  // late final LoadSeasonsUseCase? loadSeasonsUseCase;
  late final FetchEpisodesBloc _epsiodeBloc;

  @override
  void initState() {
    _watchProviderRepository =
        RepositoryProvider.of<WatchProviderRepository>(context);
    _epsiodeBloc = FetchEpisodesBloc(
        repository: _watchProviderRepository,
        cacheRespository: RepositoryProvider.of<CacheRespository>(context),
        mediaDetails: RepositoryProvider.of<MediaDetailsEntity>(context),
        metaProviderRepository:
            RepositoryProvider.of<MetaProviderRepository>(context));

//  loadSeasonsUseCase = LoadSeasonsUseCase(watchRepository);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print('rebuild');
    final SeasonsSelectorBloc? seasonsSelectorBloc;
    final FetchSeasonsBloc? fetchSeasonsBloc;
    if (_isTv()) {
      seasonsSelectorBloc = SeasonsSelectorBloc(_epsiodeBloc);
      fetchSeasonsBloc = FetchSeasonsBloc(
          LoadSeasonsUseCase(_watchProviderRepository), seasonsSelectorBloc);
    } else {
      seasonsSelectorBloc = null;
      fetchSeasonsBloc = null;
    }

    return MultiBlocProvider(
        providers: [
          BlocProvider.value(value: _epsiodeBloc),
          if (_isTv()) ...[
            BlocProvider.value(value: seasonsSelectorBloc!),
            BlocProvider.value(value: fetchSeasonsBloc!),
          ]
        ],
        child: Column(
          children: [
            if (_isTv()) const SeasonSelector(),
          ],
        ));
  }

  bool _isTv() => widget.searchResponse.type == MediaType.tvShow;
}

//  final FetchEpisodesBloc episodesBloc;
//     final SeasonsSelectorBloc? _seasonsSelectorBloc;
//     final FetchSeasonsBloc? _fetchSeasonsBloc;
//     episodesBloc = FetchEpisodesBloc(repository: repository, cacheRespository: cacheRespository, mediaDetails: mediaDetails, metaProviderRepository: metaProviderRepository)
//     if (searchResponse.type == MediaType.tvShow) {
//       _seasonsSelectorBloc = SeasonsSelectorBloc(episodesBloc);
//       _fetchSeasonsBloc = FetchSeasonsBloc(repository, bloc);
//     }
