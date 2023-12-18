import 'package:meiyou/core/resources/subtitle_decoders/exceptions/subtitle_parsing_expection.dart';
import 'package:meiyou/core/resources/subtitle_decoders/models/cue.dart';
import 'package:meiyou/core/resources/subtitle_decoders/subtitle_parser.dart';
import 'package:meiyou_extensions_lib/extenstions.dart';

class WebVttParser extends SubtitleParser {
  @override
  List<SubtitleCue> parse(String subtitleData) {
    return SubtitleParsingException.tryWith(() {
      final file = readFile(subtitleData);
      if (!file.first.first.startsWith('WEBVTT')) {
        throw const SubtitleParsingException(
            'Invaild Webvtt format all Webbvtt files should starts with WEBVTT notation');
      }

      final List<SubtitleCue> cues = [];
      var index = 0;

      for (final List<String> lines in file.sublist(1)) {
        final startIndex = lines
            .tryIndexOf(lines.tryfirstWhere((e) => e.contains(_webvttArrow)));
        if (startIndex != null && startIndex != -1) {
          final List<Duration> timeStamps = parseTimeCodes(lines[startIndex]);
          cues.add(SubtitleCue(
              start: timeStamps[0],
              end: timeStamps[1],
              text: parseText(lines.sublist(startIndex + 1)),
              index: index));
          index++;
        }
      }

      return cues;
    });
  }

  @override
  List<Duration> parseTimeCodes(String time) {
    final timeStamps = time.replaceAll('.', ':').split(_webvttArrow);
    return [
      _parseTimeStamp(
        timeStamps[0],
      ),
      _parseTimeStamp(timeStamps[1])
    ];
  }

  Duration _parseTimeStamp(String timeStamp) {
    final numbers = timeStamp
        .split(':')
        .mapAsList((it) => RegExp('\\d+').firstMatch(it)?.group(0))
        .nonNullsList;

    final int hour;
    final int minute;
    final int second;
    final int milliseconds;
    if (numbers.length == 4) {
      hour = numbers[0].toInt();
      minute = numbers[1].toInt();
      second = numbers[2].toInt();
      milliseconds = numbers[3].toInt();
    } else {
      hour = 0;
      minute = numbers[0].toInt();

      second = numbers[1].toInt();
      milliseconds = numbers[2].toInt();
    }

    return Duration(
        hours: hour,
        minutes: minute,
        milliseconds: milliseconds,
        seconds: second);
  }

  static const _webvttArrow = ' --> ';
}
