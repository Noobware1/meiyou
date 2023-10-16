import 'package:equatable/equatable.dart';

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

  static const empty =
      SearchResponseEntity(title: '', url: '', cover: '', type: '');

  bool get isEmpty =>
      title.isEmpty && url.isEmpty && cover.isEmpty && type.isEmpty;

}
