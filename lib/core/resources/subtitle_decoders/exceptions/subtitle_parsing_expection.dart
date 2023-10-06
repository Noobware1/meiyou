import 'package:meiyou/core/resources/subtitle_decoders/models/cue.dart';

class SubtitleParsingException implements Exception {
  final String message;
  final StackTrace? stackTrace;

  const SubtitleParsingException(this.message, {this.stackTrace});

  @override
  String toString() {
    return '$message\nStack Trace\n$stackTrace';
  }

  static void throwExceptionIfCuesEmpty(List<SubtitleCue> cues) {
    if (cues.isEmpty) {
      throw const SubtitleParsingException('Couldn\'t parse subtitle file');
    }
  }

  static List<SubtitleCue> tryWith(List<SubtitleCue> Function() fun) {
    try {
      final cues = fun.call();
      SubtitleParsingException.throwExceptionIfCuesEmpty(cues);
      return cues;
    } catch (e, s) {
      throw SubtitleParsingException(e.toString(), stackTrace: s);
    }
  }
}
