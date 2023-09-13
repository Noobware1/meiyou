import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meiyou/core/resources/providers/base_provider.dart';

part 'source_drop_down_event.dart';
part 'source_drop_down_state.dart';

class SourceDropDownBloc
    extends Bloc<SourceDropDownEvent, SourceDropDownState> {
  SourceDropDownBloc(BaseProvider provider)
      : super(SourceDropDownSelected(provider)) {
    on<SourceDropDownOnSelected>(onSelected);
  }

  FutureOr<void> onSelected(
      SourceDropDownOnSelected event, Emitter<SourceDropDownState> emit) {
    emit(SourceDropDownSelected(event.provider));
  }
}
