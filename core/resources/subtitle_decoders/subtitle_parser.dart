import 'dart:convert';

import 'package:meiyou/core/resources/subtitle_decoders/models/cue.dart';
// import 'package:meiyou/core/resources/subtitle_decoders/models/subtitle.dart';

abstract class SubtitleParser {
  List<SubtitleCue> parse(String subtitleData);

  List<Duration> parseTimeCodes(String time);

  String parseText(List<String> text) {
    final cleaned = [];
    for (var i = 0; i < text.length; i++) {
      cleaned.add(text[i].replaceAll(htmlRegex, ''));
    }
    return cleaned.join("\n");
   
  }

  final htmlRegex = RegExp(r'<[^>]+>');

  List<List<String>> readFile(String file) {
    final List<String> lines = LineSplitter.split(file).toList();

    final List<List<String>> captionStrings = <List<String>>[];
    List<String> currentCaption = <String>[];
    int lineIndex = 0;
    for (final String line in lines) {
      final bool isLineBlank = line.trim().isEmpty;
      if (!isLineBlank) {
        currentCaption.add(line);
      }

      if (isLineBlank || lineIndex == lines.length - 1) {
        captionStrings.add(currentCaption);
        currentCaption = <String>[];
      }

      lineIndex += 1;
    }

    return captionStrings;
  }
}
