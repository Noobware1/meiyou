part of 'subtitle_worker_bloc.dart';

sealed class SubtitleWorkerState extends Equatable {
  final SubtitleEntity subtitle;
  const SubtitleWorkerState(this.subtitle);

  @override
  List<Object> get props => [subtitle];
}

final class SubtitleDecoding extends SubtitleWorkerState {
  const SubtitleDecoding(super.subtitle);
}

final class SubtitleDecodingFailed extends SubtitleWorkerState {
  final MeiyouException error;
  const SubtitleDecodingFailed(this.error, super.subtitle);
}

final class SubtitleDecoded extends SubtitleWorkerState {
  final List<SubtitleCue> subtitleCues;
  const SubtitleDecoded(this.subtitleCues, super.subtitle);
}

final class NoSubtitle extends SubtitleWorkerState {
  const NoSubtitle(super.subtitle);
}
