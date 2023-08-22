import 'dart:convert';

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
    final upper = split('')[0].toUpperCase();
    return upper + substring(1, length);
  }
}
