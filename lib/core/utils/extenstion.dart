import 'dart:convert';

import 'package:meiyou/data/models/episode.dart';
import 'package:meiyou/data/models/media_details.dart';

extension ListUtils<T> on List<T> {
  List<T> whereSafe(bool Function(T) fun) {
    try {
      return where(fun).toList();
    } catch (_) {
      return const [];
    }
  }
}

extension MapUtils on Map<String, String> {
  toJson() => json.encode(this);
}

extension StringUtils on String {
  String decodeBase64() => utf8.decode(base64.decode(this));

  num toNum() => num.parse(this);

  num? toNumOrNull() => num.tryParse(this);

  int toInt() => int.parse(this);

  int? toIntOrNull() => int.tryParse(this);

  double toDouble() => double.parse(this);

  double? toDoubleOrNull() => double.tryParse(this);

  String trimNewLines() {
    return replaceAll('\n', '').trim();
  }

  List<int> decodeHex() {
    assert(length % 2 == 0, "Must have an even length");
    return RegExp('.{1,2}').allMatches(this).map((match) {
      return int.parse(match.group(0)!, radix: 16);
    }).toList();
  }

  String substringBefore(String pattern) {
    int i;
    i = indexOf(pattern);
    if (i == -1) {
      return '';
    } else {
      return substring(0, i);
    }
  }

  String substringAfter(String pattern) {
    int i;
    i = indexOf(pattern);
    final len = i + pattern.length;
    if (i == -1) {
      return '';
    } else {
      return substring(len, length).trim();
    }
  }

  String substringBeforeLast(String pattern) {
    int i;
    i = lastIndexOf(pattern);
    if (i == -1) {
      return '';
    } else {
      return substring(0, i);
    }
  }

  String substringAfterLast(String pattern) {
    int i;
    i = lastIndexOf(pattern);
    final len = i + pattern.length;
    if (i == -1) {
      return '';
    } else {
      return substring(len, length).trim();
    }
  }

  String toUpperCaseFirst() {
    try {
      final upper = split('')[0].toUpperCase();
      return upper + substring(1, length);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

extension EpisodeUtils on List<Episode> {
  void fill(int len, MediaDetails media) {
    if (isEmpty) {
      add(Episode(
          number: 1,
          thumbnail: media.bannerImage ?? media.poster,
          title: 'Episode 1'));
    }
    var lastEpisodeNumber = last.number.toInt();
    while (length < len) {
      lastEpisodeNumber++;
      add(Episode(
          number: lastEpisodeNumber,
          title: 'Episode $lastEpisodeNumber',
          thumbnail: media.bannerImage ?? media.poster));
      if (length == len) break;
      continue;
    }
  }

  List<Episode> fillMissingEpisode(MediaDetails media) {
    sort((a, b) => a.number.compareTo(b.number));
    final len = length;

    final newData = <Episode>[first]; //stores new data

    for (var i = 1; i < len; i++) {
      var diff = this[i].number.toInt() - this[i - 1].number.toInt();

      if (diff > 1) {
        //there is gap here
        var val = 0;
        diff--;

        for (var j = 0; j < diff; j++) {
          val = this[i - 1].number.toInt() + j + 1;

          newData.add(Episode(
              number: val,
              title: 'Episode $val',
              thumbnail: media.bannerImage ?? media.poster));
          // new_data.push('y')
        }
      }

      //put current info after missing data was inserted
      // new_number.push(numbers[i])
      newData.add(this[i]);
    }

    return newData;
  }
}
