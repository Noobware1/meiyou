import 'package:meiyou/domain/entities/external_id.dart';

class ExternalId extends ExternalIdEntity {
  ExternalId({required super.name, required super.id});

  @override
  String toString() {
    return '''ExternalId(name: $name, id: $id)''';
  }
}
