import 'package:meiyou/domain/entities/movie.dart';

class Movie extends MovieEntity {
  const Movie(
      {required super.url,
       super.description,
       super.cover,
       super.title});
}