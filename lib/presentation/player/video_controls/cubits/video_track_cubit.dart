import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_kit/media_kit.dart';

class TracksCubit extends Cubit<Tracks> {
  late final StreamSubscription _subscription;

  TracksCubit(Stream<Tracks> trackStream) : super(const Tracks()) {
    _subscription = trackStream.listen((tracks) => emit(tracks));
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
