
import 'package:meiyou/core/utils/data_converter/data_convert.dart';
import 'package:meiyou/data/models/movie.dart';

class MovieWriter extends CacheWriter<Movie> {
  @override
  Movie readFromJson(json) {
    return Movie.fromJson(json);
  }

  @override
  String writeToJson(Movie data) {
    return jsonEncoder.encode(data.toJson());
  }
}
