import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meiyou/core/resources/expections.dart';
import 'package:meiyou_extenstions/models.dart';

class ExtractedVideoData {
  final ExtractorLink link;
  final Video video;

  ExtractedVideoData({required this.link, required this.video});

  @override
  String toString() {
    return 'ExtractedVideoData(link: $link, video: $video)';
  }
}

class ExtractedVideoDataCubit extends Cubit<ExtractedVideoDataState> {
  StreamSubscription? _subscription;

  ExtractedVideoDataCubit(Stream<(ExtractorLink, Media)> stream)
      : super(const ExtractedVideoDataState()) {
    initStream(stream);
  }

  void _onError(dynamic error, StackTrace stackTrace) {
    emit(ExtractedVideoDataState(
        data: state.data,
        error: error is MeiyouException
            ? error
            : MeiyouException(error.toString(), stackTrace: stackTrace)));
  }

  void initStream(Stream<(ExtractorLink, Media)> stream) {
    emit(const ExtractedVideoDataState());
    _subscription?.cancel();
    _subscription = null;

    _subscription = stream.listen(
        (data) {
          if (data.$2 is Video) {
            emit(ExtractedVideoDataState(data: [
              ...state.data,
              ExtractedVideoData(link: data.$1, video: data.$2 as Video)
            ]));
          }
        },
        cancelOnError: false,
        onDone: () {
          _subscription?.cancel();
          _subscription = null;
          print(state.data.toString());
        },
        onError: _onError);
  }
}

class ExtractedVideoDataState extends Equatable {
  final List<ExtractedVideoData> data;
  final MeiyouException? error;

  const ExtractedVideoDataState({this.data = const [], this.error});

  @override
  List<Object?> get props => [data, error];
}
