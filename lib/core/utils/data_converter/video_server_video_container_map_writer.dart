import 'package:meiyou/core/utils/data_converter/data_convert.dart';
import 'package:meiyou/data/models/video_container.dart';

class VideoServerVideoContainerMapWriter
    extends CacheWriter<Map<String, VideoContainer>> {
  @override
  Map<String, VideoContainer> readFromJson(json) {
    final Map<String, VideoContainer> map = {};
    for (var entry in (json as Map).entries) {
      map[entry.key.toString()] = VideoContainer.fromJson(entry.value);
    }

    return map;
  }

  @override
  String writeToJson(Map<String, VideoContainer> data) {
    final Map<String, dynamic> map = {};

    for (var entry in data.entries) {
      map[entry.key] = entry.value.toJson();
    }

    return jsonEncoder.encode(map);
  }
}
