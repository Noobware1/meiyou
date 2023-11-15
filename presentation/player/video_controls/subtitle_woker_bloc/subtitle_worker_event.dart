part of 'subtitle_worker_bloc.dart';

sealed class SubtitleWorkerEvent extends Equatable {
  const SubtitleWorkerEvent();

  @override
  List<Object> get props => [];
}

class ChangeSubtitle extends SubtitleWorkerEvent {
  final SubtitleEntity subtitle;
  final Map<String, String>? headers;
  // final BufferingCubit bufferingCubit;

  const ChangeSubtitle(
      {
        // required this.player,
      // required this.bufferingCubit,
      required this.subtitle,
      this.headers});
}
