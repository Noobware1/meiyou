import 'package:meiyou/core/utils/extenstions/string.dart';

String fixFileName(String title) {
  title = title.toLowerCase();
  return title.replaceAll(' ', '_').replaceAll('/', '').trim();
}

String getFileNameFromUrl(String url) {
  return fixFileName(url.substringAfterLast('/'));
}
