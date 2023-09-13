part of 'extract_video_bloc.dart';

sealed class ExtractVideoState extends Equatable {
  final VideoContainerEntity? videoContainer;
  final MeiyouException? error;
  const ExtractVideoState({this.error, this.videoContainer});

  @override
  List<Object> get props => [videoContainer!, error!];
}

final class ExtractVideoExtracting extends ExtractVideoState {
  const ExtractVideoExtracting();
}

final class ExtractVideoExtractionFailed extends ExtractVideoState {
  const ExtractVideoExtractionFailed(MeiyouException error)
      : super(error: error);
}

final class ExtractVideoExtractionSuccess extends ExtractVideoState {
  const ExtractVideoExtractionSuccess(VideoContainerEntity videoContainer)
      : super(videoContainer: videoContainer);
}
