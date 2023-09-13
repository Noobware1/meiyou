import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meiyou/core/resources/expections.dart';
import 'package:meiyou/core/resources/providers/base_provider.dart';
import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/domain/entities/episode.dart';
import 'package:meiyou/domain/entities/search_response.dart';
import 'package:meiyou/domain/repositories/cache_repository.dart';
import 'package:meiyou/domain/usecases/get_mapped_episodes_usecase.dart';
import 'package:meiyou/domain/usecases/provider_use_cases/load_seasons_episodes.dart';
import 'package:meiyou/presentation/widgets/season_selector/seasons_selector_bloc/seasons_selector_bloc.dart';

part 'fetch_seasons_episodes_event.dart';
part 'fetch_seasons_episodes_state.dart';

class FetchSeasonsEpisodesBloc
    extends Bloc<FetchSeasonsEpisodesEvent, FetchSeasonsEpisodesState> {
  final CacheRespository cacheRespository;
  final LoadSeasonsEpisodesUseCase loadSeasonsEpisodesUseCase;
  final SeasonsSelectorBloc seasonsSelectorBloc;
  final GetMappedEpisodesUseCase getMappedEpisodesUseCase;

  FetchSeasonsEpisodesBloc(
      {required this.loadSeasonsEpisodesUseCase,
      required this.cacheRespository,
      required this.getMappedEpisodesUseCase,
      required this.seasonsSelectorBloc})
      : super(const FetchSeasonsEpisodesLoading()) {
    on<FetchSeasonsEpisodes>(onFetchSeasonsEpisodes);
    on<ClearFetchSeasonsEpisodesState>(
      (event, emit) => emit(const FetchSeasonsEpisodesLoading()),
    );
  }

  FutureOr<void> onFetchSeasonsEpisodes(FetchSeasonsEpisodes event,
      Emitter<FetchSeasonsEpisodesState> emit) async {
    emit(const FetchSeasonsEpisodesLoading());
    final response = await loadSeasonsEpisodesUseCase.call(
        LoadSeasonsEpisodesUseCaseParams(
            provider: event.provider,
            searchResponse: event.searchResponse,
            getMappedEpisodesUseCase: getMappedEpisodesUseCase,
            cacheRespository: cacheRespository));

    if (response is ResponseFailed) {
      emit(FetchSeasonsEpisodesFailed(response.error!));
    } else {
      seasonsSelectorBloc.add(
          SelectSeason(response.data!.keys.first, response.data!.values.first));

      emit(FetchSeasonsEpisodesSucess(response.data!));
    }
  }
}
