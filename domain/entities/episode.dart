import 'package:equatable/equatable.dart';

class EpisodeEntity extends Equatable {
  final num number;

  final String url;
  final String? title;

  final String? desc;

  final bool? isFiller;
  final double? rated;

  final String? thumbnail;

  const EpisodeEntity(
      {required this.number,
      this.url = '',
      this.title,
      this.desc,
      this.isFiller,
      this.rated,
      this.thumbnail});

 

  @override
  String toString() {
    return """{
    'number': $number,
    'title': $title,
    'isFiller': $isFiller,
    'url': $url,
    'thumbnail': $thumbnail,
    'desc': $desc,
    'rated': $rated,
    }""";
  }

  @override
  List<Object?> get props => [
        number,
        title,
        isFiller,
        url,
        thumbnail,
        desc,
        rated,
      ];
}
