
class ActorDataEntity {

  final String name;
  final String? image;
  final String? role;

  const ActorDataEntity({
    // this.id = Isar.autoIncrement,
    required this.name,
    this.image,
    this.role,
  });
}
