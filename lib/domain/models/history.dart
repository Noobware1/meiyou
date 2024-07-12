import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:meiyou/domain/models/progress_type.dart';
import 'package:meiyou/extension/models/entension_type.dart';
import 'package:meiyou_extensions_lib/models.dart';
part 'history.g.dart';

@collection
class History {
  const History({
    this.id = Isar.autoIncrement,
    required this.title,
    required this.poster,
    required this.url,
    required this.sourceId,
    required this.type,
    required this.lastSeen,
    required this.progressString,
  });

  final Id id;

  final String title;

  final String? poster;

  final String url;

  final int sourceId;

  @enumerated
  final ExtensionType type;

  final DateTime lastSeen;

  final String progressString;

  History copyWith({
    String? title,
    String? poster,
    String? url,
    int? sourceId,
    ExtensionType? type,
    DateTime? lastSeen,
    String? progressString,
    // int? contentProgressId,

    // ProgressKey? progressKey,

    // ContentProgress? contentProgress,
  }) {
    return History(
      progressString: progressString ?? this.progressString,
      id: id,
      title: title ?? this.title,
      poster: poster ?? this.poster,
      url: url ?? this.url,
      sourceId: sourceId ?? this.sourceId,
      type: type ?? this.type,
      lastSeen: lastSeen ?? this.lastSeen,
    );
  }

  ContentItem toContentItem({bool basedOnProgress = false}) {
    return ContentItem(
      title: progressString + title,
      poster: poster ?? '',
      url: url,
    );
  }

  static createProgressString() {}
}

extension on DateTime {
  String toReadableString() {
    // Create a DateFormat object for the desired format
    DateFormat dateFormat = DateFormat('h:mm a');

    // Format the DateTime object to a string
    return dateFormat.format(this);
  }
}
