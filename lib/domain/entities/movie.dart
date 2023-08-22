import 'package:equatable/equatable.dart';

class MovieEntity extends Equatable {
  final String url;
  final String? description;
  final String? cover;
  final String? title;

  const MovieEntity(
      {required this.url, this.description, this.cover, this.title});

  @override
  List<Object?> get props => [
        url,
        description,
        cover,
        title,
      ];
}
