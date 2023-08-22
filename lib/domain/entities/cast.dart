import 'package:equatable/equatable.dart';

class CastEnitity extends Equatable {
  // final int id;
  final String image;
  final String characterName;
  final String name;
  final String? link;

  const CastEnitity({
    // required this.id,
    required this.image,
    required this.characterName,
    required this.name,
    this.link,
  });

  @override
  List<Object?> get props => [image, characterName, name, link];
}
