import 'dart:convert';

import 'package:isar/isar.dart';
import 'package:meiyou/domain/models/progress.dart';
import 'package:meiyou/extension/models/entension_type.dart';
import 'package:meiyou_extensions_lib/models.dart';
part 'library_item.g.dart';

@collection
class LibraryItem {
  const LibraryItem({
    this.id = Isar.autoIncrement,
    required this.sourceId,
    required this.type,
    required this.title,
    required this.poster,
    required this.url,
  });

  final Id id;
  final int sourceId;

  @enumerated
  final ExtensionType type;

  final String title;
  final String? poster;
  final String url;

  // final int categoryId;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sourceId': sourceId,
      'type': type.toString(),
      'title': title,
      'poster': poster,
      'url': url,
    };
  }

  @override
  String toString() {
    return const JsonEncoder.withIndent('  ').convert(toJson());
  }

  LibraryItem copyWith({
    int? sourceId,
    ExtensionType? type,
    String? title,
    String? poster,
    String? url,
    int? seenCount,
    int? total,
  }) {
    return LibraryItem(
      id: id,
      sourceId: sourceId ?? this.sourceId,
      type: type ?? this.type,
      title: title ?? this.title,
      poster: poster ?? this.poster,
      url: url ?? this.url,
    );
  }

  ContentItem toContentItem() {
    return ContentItem(
      title: title,
      poster: poster ?? '',
      url: url,
    );
  }
}
