part of 'extract_video_bloc.dart';

sealed class ExtractVideoEvent extends Equatable {
  final LoadVideoExtractorParams params;
  const ExtractVideoEvent(this.params);

  @override
  List<Object> get props => [params];
}

final class Extract extends ExtractVideoEvent {
  const Extract(super.params);
}
