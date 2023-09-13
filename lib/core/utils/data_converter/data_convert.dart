import 'dart:convert' show json, JsonCodec;

abstract class CacheWriter<T> {
  T readFromJson(dynamic json);

  String writeToJson(T data);

  final JsonCodec jsonEncoder = json;
}
