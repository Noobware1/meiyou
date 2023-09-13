import 'package:equatable/equatable.dart';

class MovieEntity extends Equatable {
  final String url;
  final String? description;
  final String? cover;
  final String? title;
  final double? rated;

  const MovieEntity(
      {required this.url, this.description, this.cover, this.title, this.rated});

  @override
  List<Object?> get props => [
        url,
        description,
        cover,
        title,
        rated,
      ];
}
