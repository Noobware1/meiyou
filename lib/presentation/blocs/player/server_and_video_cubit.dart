import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meiyou/core/resources/expections.dart';
import 'package:meiyou/domain/entities/extracted_media.dart';
import 'package:meiyou_extensions_lib/models.dart';

class ExtractedMediaCubit<T extends Media> extends Cubit<ExtractedMediaState> {
  StreamSubscription? _subscription;

  ExtractedMediaCubit(Stream<ExtractedMediaEntity> stream)
      : super(const ExtractedMediaState()) {
    initStream(stream);
  }

  void _onError(dynamic error, StackTrace stackTrace) {
    print('There was an error: $error');
    if (isClosed) return;

    emit(ExtractedMediaState(
        data: state.data,
        error: error is MeiyouException
            ? error
            : MeiyouException(error.toString(), stackTrace: stackTrace)));
  }

  void initStream(Stream<ExtractedMediaEntity> stream) {
    emit(const ExtractedMediaState());
    _subscription?.cancel();
    _subscription = null;
    _subscription = stream.listen(
      (data) {
        if (isClosed) {
          _subscription?.cancel();
          return;
        }

        if (data.media is T) {
          emit(ExtractedMediaState(data: [
            ...state.data,
            ExtractedMediaEntity(link: data.link, media: data.media as T)
          ]));
        }
      },
      cancelOnError: false,
      onDone: () {
        state.copyWith(isDone: true);
        _subscription?.cancel();
        _subscription = null;
      },
      onError: _onError,
    );
  }
}

class ExtractedMediaState extends Equatable {
  final List<ExtractedMediaEntity> data;
  final MeiyouException? error;
  final bool isDone;

  const ExtractedMediaState(
      {this.isDone = false, this.data = const [], this.error});

  @override
  List<Object?> get props => [data, error, isDone];

  ExtractedMediaState copyWith({
    List<ExtractedMediaEntity>? data,
    MeiyouException? error,
    bool? isDone,
  }) {
    return ExtractedMediaState(
      data: data ?? this.data,
      error: error ?? this.error,
      isDone: isDone ?? this.isDone,
    );
  }

  @override
  String toString() {
    return 'ExtractedMediaState(data: $data, error: $error, isDone: $isDone)';
  }
}
