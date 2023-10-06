import 'package:equatable/equatable.dart';

class SubtitleCue extends Equatable {
  final Duration start;
  final Duration end;
  final String text;
  final int index;

  const SubtitleCue({
    required this.start,
    required this.end,
    required this.text,
    required this.index,
  });

  SubtitleCue copyWith(
      {Duration? start, Duration? end, String? text, int? index}) {
    return SubtitleCue(
        start: start ?? this.start,
        end: end ?? this.end,
        text: text ?? this.text,
        index: index ?? this.index);
  }

  static const empty = SubtitleCue(
      start: Duration.zero, end: Duration.zero, text: '', index: -1);

  @override
  String toString() {
    return """SubtitleCue("start": $start, "end": $end, "text": $text, "index": $index)""";
  }

  @override
  List<Object?> get props => [start, end, text, index];
}
