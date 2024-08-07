import 'dart:async';

extension StreamSubscriptionTryCancel<E> on StreamSubscription<E> {
  Future<void> tryCancel() async {
    try {
      await cancel();
    } catch (_) {}
  }
}
