import 'package:meiyou/domain/entities/cast.dart';

class Cast extends CastEnitity {
  const Cast(
      {required super.image,
      required super.characterName,
      required super.name,
      super.link});

  factory Cast.fromTMDB(dynamic json) {
    return Cast(
        // id: json['id'].toString().toInt(),
        image: json["profile_path"] != null
            ? 'https://image.tmdb.org/t/p/original${json["profile_path"]}'
            : '',
        name: (json['name'] ?? json['original_name']) as String,
        characterName: json['character']);
  }

  factory Cast.fromAnilist(dynamic json) {
    final node = json['node'];
    return Cast(
      // id: node['id'],
      characterName: json['role'],
      image: node['image']?['large'] ?? node['image']?['medium'] ?? '',
      name: node['name']?['userPreferred'] ?? node['name']?['full'] ?? '',
    );
    // : ?.toString())
  }
}
