import 'package:meiyou/shared/domain/models/extension_category.dart';
import 'package:meiyou/shared/utils/stream_utils/state_stream.dart';
import 'package:meiyou_extensions_lib/models.dart';

abstract class SourceManager {
  Source? getSource(int id, ExtensionCategory category);

  StateStream<List<CatalogueSource>> getCatalogueSources(
      ExtensionCategory category);
}
