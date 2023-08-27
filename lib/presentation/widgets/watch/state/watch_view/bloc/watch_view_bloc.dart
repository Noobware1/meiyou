import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:meiyou/core/usecases/usecase.dart';


part 'watch_view_event.dart';
part 'watch_view_state.dart';

class WatchViewBloc extends Bloc<WatchViewEvent, WatchViewState> {
  WatchViewBloc() : super(WatchViewInitial()) {
    on<WatchViewEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
