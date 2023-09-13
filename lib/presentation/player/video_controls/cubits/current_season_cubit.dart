import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meiyou/core/utils/extenstions/list.dart';
import 'package:meiyou/domain/entities/season.dart';

class CurrentSeasonCubit extends Cubit<CurrentSeasonState> {
  CurrentSeasonCubit() : super(CurrentSeasonState.noIndex);

  changeSeason(List<SeasonEntity> season, int index) {
    if (season.containsIndex(index)) {
      emit(CurrentSeasonState(
          index: index,
          hasNext: season.containsIndex(index + 1),
          hasPrevious: season.containsIndex(index + 1)));
    } else {
      emit(CurrentSeasonState.noIndex);
    }
  }
}

class CurrentSeasonState {
  final int index;
  final bool hasNext;
  final bool hasPrevious;

  const CurrentSeasonState(
      {required this.index, required this.hasNext, required this.hasPrevious});

  static const noIndex =
      CurrentSeasonState(index: -1, hasNext: false, hasPrevious: false);
}
