import 'package:flutter/material.dart';

extension ListenableExtension on ChangeNotifier {
  Listenable listenWhen(bool Function(ChangeNotifier) test) {
    return _Listener(this, test: test);
  }
}


class _Listener implements ChangeNotifier {
  final ChangeNotifier _notifier;
  late final void Function() listener;
//  ListenableBuilder b
  _Listener(this._notifier, {required bool Function(ChangeNotifier) test}) {
    listener = () {
      if (test(_notifier)) {
        notifyListeners();
      }
    };
    _notifier.addListener(listener);
  }

  @override
  void addListener(VoidCallback listener) {}

  @override
  void removeListener(VoidCallback listener) {}

  void dispose() {
    _notifier.removeListener(listener);
    _notifier.dispose();
  }

  @override
  bool get hasListeners => _notifier.hasListeners;

  @override
  void notifyListeners() {
    // throw UnimplementedError();
    _notifier.notifyListeners();
  }
}
