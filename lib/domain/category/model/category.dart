import 'package:isar/isar.dart';
import 'package:meiyou/extension/models/entension_type.dart';
part 'category.g.dart';

@collection
class Category {
  final Id id;
  final int type;
  final String name;
  final int order;
  final bool hidden;

  Category({
    this.id = Isar.autoIncrement,
    required this.name,
    required this.order,
    required this.hidden,
    required this.type,
  });

  Category.system({
    this.id = 0,
    this.name = 'default',
    this.order = 0,
    this.hidden = false,
    required ExtensionType type,
  }) : type = type.index;

  Category.fromType({
    this.id = Isar.autoIncrement,
    required this.name,
    required this.order,
    this.hidden = false,
    required ExtensionType type,
  }) : type = type.index;

  bool get isSystem => id == 0;

  Category copyWith({
    int? id,
    String? name,
    int? order,
    bool? hidden,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      order: order ?? this.order,
      hidden: hidden ?? this.hidden,
      type: type,
    );
  }
}
