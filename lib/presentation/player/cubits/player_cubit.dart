import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injecktor/injecktor.dart';
import 'package:meiyou/presentation/player/player_screen.dart';

class PlayerCubit extends Cubit<PlayerState> with CloseableMixin {
  PlayerCubit({
    required void Function() onLoaded,
    required void Function(Exception) onError,
  })  : _onLoaded = onLoaded,
        _onError = onError,
        super(PlayerState.loading);

  final void Function() _onLoaded;
  final void Function(Exception) _onError;

  @override
  void emit(PlayerState state) {
    if (isClosed) return;
    super.emit(state);
  }

  void loaded() {
    emit(PlayerState.loaded);
  }

  void loading() {
    emit(PlayerState.loading);
  }

  Future<void> load() {
    loading();
    return InjectKtor.playerRepository.loadPlayer(
      onReady: _onLoaded,
      onError: _onError,
    );
  }

  bool get isLoaded => state.isLoaded;

  bool get isLoading => state.isLoading;
}

enum PlayerState {
  loaded,
  loading;

  bool get isLoaded => this == PlayerState.loaded;
  bool get isLoading => this == PlayerState.loading;
}
