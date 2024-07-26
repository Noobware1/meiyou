import 'package:meiyou/shared/domain/models/async_value.dart';
import 'package:meiyou/shared/domain/models/media.dart';
import 'package:meiyou_extensions_lib/models.dart' hide Media;

class MediaScreenState {
  final Source source;
  final bool isFromSource;
  final Media mediaDetails;

  MediaScreenState({
    required this.source,
    required this.isFromSource,
    required this.mediaDetails,
  });
}
