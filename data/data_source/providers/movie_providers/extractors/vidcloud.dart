import 'package:meiyou/core/utils/extenstions/string.dart';
import 'package:meiyou/data/data_source/providers/anime_providers/extractors/rapid_cloud.dart';

class VidCloud extends RapidCloud {
  VidCloud(super.videoServer);

  @override
  String getUrl() {
    final serverUrl = videoServer.url;
    final embed = RegExp(r'embed-\d').firstMatch(serverUrl)?.group(0);
    final id = serverUrl.substringAfterLast("/").substringBefore("?");
    return '$hostUrl/ajax/$embed/getSources?id=$id';
  }

  @override
  String get keyUrl =>
      'https://raw.githubusercontent.com/enimax-anime/key/e4/key.txt';
}
