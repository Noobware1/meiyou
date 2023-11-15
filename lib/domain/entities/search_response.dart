import 'show_type.dart';

class SearchResponseEntity {
  final String title;
  final String url;
  final String poster;
  final ShowType type;
  final String? description;
  final List<String>? generes;
  final double? rating;
  final int? current;
  final int? total;

  const SearchResponseEntity({
    required this.title,
    required this.url,
    required this.poster,
    required this.type,
    this.description,
    this.generes,
    this.rating,
    this.current,
    this.total,
  });
}
