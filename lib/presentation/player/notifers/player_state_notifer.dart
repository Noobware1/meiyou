import 'package:meiyou/core/utils/resources/get_it/get_it.dart';
import 'package:meiyou/notifers/state_notifer.dart';

import 'package:meiyou/presentation/player/player_screen.dart';

class PlayerStateNotifer extends StateNotifer<PlayerState> {
  PlayerStateNotifer({
    required void Function() onLoaded,
    required void Function(Exception) onError,
  })  : _onLoaded = onLoaded,
        _onError = onError,
        super(PlayerState.loading);

  final void Function() _onLoaded;
  final void Function(Exception) _onError;

  @override
  void setState(PlayerState state) {
    if (isDisposed) return;
    super.setState(state);
  }

  void loaded() {
    setState(PlayerState.loaded);
  }

  void loading() {
    setState(PlayerState.loading);
  }

  Future<void> load() {
    loading();
    return getIt.playerRepository.loadPlayer(
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
