import 'package:meiyou/notifers/state_notifer.dart';

class ShowPlayerControlsNotifer extends StateNotifer<bool> {
  ShowPlayerControlsNotifer() : super(true);

  bool _forceEnabled = false;

  void forceHide() {
    if (_forceEnabled) return;
    _forceEnabled = true;
    setState(false);
  }

  void reset() {
    _forceEnabled = false;
  }

  void show() {
    if (!_forceEnabled) {
      setState(true);
    }
  }

  void hide() {
    if (!_forceEnabled) {
      setState(false);
    }
  }

  void toggle() {
    if (!_forceEnabled) {
      setState(!state);
    }
  }
}
