import 'package:meiyou/core/utils/extenstions/string.dart';

enum ShowType {
  Movie,
  AnimeMovie,
  TvSeries,
  Cartoon,
  Anime,
  Ova,
  Ona,
  Documentary,
  AsainDrama,
  Live,
  Others;

  @override
  String toString() {
    return super.toString().substringAfter('.');
  }
}
