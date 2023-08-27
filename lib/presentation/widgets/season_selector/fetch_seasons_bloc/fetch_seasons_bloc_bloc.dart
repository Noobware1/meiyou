import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meiyou/core/resources/expections.dart';
import 'package:meiyou/core/resources/providers/base_provider.dart';
import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/domain/entities/search_response.dart';
import 'package:meiyou/domain/entities/season.dart';
import 'package:meiyou/domain/usecases/provider_use_cases/load_seasons_use_case.dart';
import 'package:meiyou/presentation/widgets/season_selector/seasons_selector_bloc/seasons_selector_bloc.dart';

part 'fetch_seasons_bloc_event.dart';
part 'fetch_seasons_bloc_state.dart';

class FetchSeasonsBloc extends Bloc<FetchSeasonsEvent, FetchSeasonsState> {
  final LoadSeasonsUseCase usecase;
  final SeasonsSelectorBloc bloc;

  FetchSeasonsBloc(this.usecase, this.bloc) : super(const FetchingSeasons()) {
    on<FetchSeasons>(onFetchSeasons);
  }

  FutureOr<void> onFetchSeasons(
      FetchSeasons event, Emitter<FetchSeasonsState> emit) async {
  
    emit(const FetchingSeasons());

    final response = await usecase.call(LoadSeasonsParams(
        provider: event.provider, url: event.searchResponse.url));

    if (response is ResponseSuccess) {
      bloc.add(SelectSeason(response.data!.first, event.provider));
      emit(FetchSeasonsSuccess(response.data!));
    } else {
      emit(FetchSeasonsFailed(response.error!));
    }
  }
}
