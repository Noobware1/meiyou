import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meiyou/presentation/blocs/episodes_bloc.dart';

class EpisodesSelectorCubit extends Cubit<String> {
  final EpisodesCubit _episodesCubit;
  EpisodesSelectorCubit(this._episodesCubit)
      : super(_episodesCubit.state.isNotEmpty
            ? _episodesCubit.state.keys.first
            : '') {
    _episodesCubit.stream.listen((event) {
      updateKey(_episodesCubit.state.keys.first);
    });
  }

  void updateKey(String key) {
    emit(key);
  }
}
