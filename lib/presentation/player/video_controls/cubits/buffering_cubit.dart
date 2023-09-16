import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

class BufferingCubit extends Cubit<bool> {
  late final StreamSubscription _subscription;
  BufferingCubit(Stream<bool> stream) : super(true) {
    _subscription = stream.listen((event) {
      emit(event);
    });
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
