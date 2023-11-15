import 'dart:convert';

import 'package:meiyou/data/models/document.dart';
import 'package:meiyou/data/models/meiyou_utils.dart';

class OkHttpResponseObject {
  final String text;
  final int statusCode;
  final bool hasError;
  final Map<String, String> headers;
  final bool isRedirect;

  DocumentObject get document => MeiyouUtils.parseHtml(text);

  OkHttpResponseObject({
    required this.text,
    required this.statusCode,
    required this.headers,
    required this.hasError,
    required this.isRedirect,
  });

  E json<E>(E Function(dynamic json) fromJson) {
    return fromJson(jsonDecode(text));
  }
}
