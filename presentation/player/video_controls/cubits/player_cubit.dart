import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class PlayerCubitState {
  final Player player;
  late final VideoController videoController = VideoController(player);
  PlayerCubitState(this.player);
}

class PlayerCubit extends Cubit<PlayerCubitState> {
  Player _player;

  PlayerCubit(Player player)
      : _player = player,
        super(PlayerCubitState(player));

  void createNewInstance() {
    _player.dispose();
    _player = Player();
    emit(PlayerCubitState(_player));
  }

  @override
  Future<void> close() {
    _player.dispose();
    return super.close();
  }
}
