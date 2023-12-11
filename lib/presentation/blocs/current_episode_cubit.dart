import 'package:flutter_bloc/flutter_bloc.dart';

class CurrentEpisodeCubit extends Cubit<int> {
  CurrentEpisodeCubit(super.index);

  void changeEpisode(int index) {
    emit(index);
  }

  void next() {
    emit(state + 1);
  }

  void previous() {
    emit(state - 1);
  }
}

final class CurrentEpisodeState {
  final int index;
  final int? seasonIndex;

  const CurrentEpisodeState({required this.index, this.seasonIndex});
}
