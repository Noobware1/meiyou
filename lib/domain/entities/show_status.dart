import 'package:meiyou/core/utils/extenstions/string.dart';

enum ShowStatus {
  Completed,
  Ongoing,
  Unknown;

  @override
  String toString() => super.toString().substringAfter('.');
}
