import 'dart:async';

import 'package:meiyou/core/utils/resources/get_it/get_it.dart';
import 'package:meiyou/notifers/state_notifer.dart';
import 'package:meiyou/presentation/player/player_screen.dart';

class BufferingNotifer extends StateNotifer<bool> {
  BufferingNotifer(Stream<bool> stream) : super(true) {
    _streamSubscription = stream.listen((event) {
      if (!_forceEnabled) {
        setState(event);
      }
    });
  }

  late final StreamSubscription<bool> _streamSubscription;

  bool _forceEnabled = false;
  bool _wasPlaying = false;

  void forceBuffering() {
    if (_forceEnabled) return;
    final repo = getIt.playerRepository;
    _wasPlaying = repo.isPlaying();
    repo.pause();
    _forceEnabled = true;
    setState(true);
  }

  void resetBuffering() {
    _forceEnabled = false;
    setState(false);
    if (_wasPlaying) {
      getIt.playerRepository.play();
    }
  }

  @override
  void dispose() {
    _streamSubscription.cancel().then((value) {
      super.dispose();
    });
  }
}
