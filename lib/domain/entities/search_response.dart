import 'package:equatable/equatable.dart';
import 'package:meiyou/core/resources/media_type.dart';

class SearchResponseEntity extends Equatable {
  final String title;
  final String url;
  final String cover;
  final String type;

  const SearchResponseEntity(
      {required this.title,
      required this.url,
      required this.cover,
      required this.type});

  @override
  List<Object?> get props => [title, url, cover, type];
}
