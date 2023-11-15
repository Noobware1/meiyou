import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CurrentEpisodeCubit extends Cubit<int> {
  CurrentEpisodeCubit([int? index]) : super(index ?? 0);

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

class CurrentEpisodeState extends Equatable {
  final int index;
  final bool hasNext;
  final bool hasPrevious;

  const CurrentEpisodeState(
      {required this.index, required this.hasNext, required this.hasPrevious});

  @override
  List<Object?> get props => [index, hasNext, hasPrevious];

  static const noIndex =
      CurrentEpisodeState(index: -1, hasNext: false, hasPrevious: false);
}
