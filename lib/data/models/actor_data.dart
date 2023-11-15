import 'package:meiyou/domain/entities/actor_data.dart';

class ActorData extends ActorDataEntity {
  const ActorData({
    required super.name,
    super.image,
    super.role,
  });
  @override
  String toString() {
    return '''ActorData(name: $name, image: $image, role: $role)''';
  }
}
