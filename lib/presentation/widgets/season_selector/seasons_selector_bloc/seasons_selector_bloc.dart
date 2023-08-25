import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meiyou/domain/entities/season.dart';

part 'seasons_selector_event.dart';
part 'seasons_selector_state.dart';

class SeasonsSelectorBloc
    extends Bloc<SeasonsSelectorEvent, SeasonsSelectorState> {
  SeasonsSelectorBloc() : super(const SeasonSelected()) {
    on<SelectSeason>(onSeasonSelected);
  }

  FutureOr<void> onSeasonSelected(
      SelectSeason event, Emitter<SeasonsSelectorState> emit) {
    emit(SeasonSelected(event.season));
  }
}
