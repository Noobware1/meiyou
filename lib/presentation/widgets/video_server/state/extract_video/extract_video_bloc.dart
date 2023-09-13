import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meiyou/core/resources/expections.dart';
import 'package:meiyou/domain/entities/video_container.dart';
import 'package:meiyou/domain/usecases/provider_use_cases/load_video_extractor_usecase.dart';

part 'extract_video_event.dart';
part 'extract_video_state.dart';

class ExtractVideoBloc extends Bloc<ExtractVideoEvent, ExtractVideoState> {
  final LoadVideoExtractorUseCase _usecase;
  ExtractVideoBloc(this._usecase) : super(const ExtractVideoExtracting()) {
    on<Extract>(onExtract);
  }

  FutureOr<void> onExtract(
      Extract event, Emitter<ExtractVideoState> emit) async {
    emit(const ExtractVideoExtracting());
    try {
      final res = await _usecase.call(event.params)!.extract();

      emit(ExtractVideoExtractionSuccess(res));
    } catch (e, stack) {
      emit(ExtractVideoExtractionFailed(MeiyouException(e.toString(),
          stackTrace: stack, type: MeiyouExceptionType.providerException)));
    }
  }
}
