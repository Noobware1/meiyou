import 'package:meiyou/core/utils/resources/flow.dart';
import 'package:meiyou/extension/models/entension_type.dart';
import 'package:meiyou/domain/models/source.dart' hide Source;
import 'package:meiyou/domain/source/source_manager.dart';

typedef InstalledSources = Map<String, List<InstalledSource>>;

class GetInstalledSources {
  final SourceManager _manager;

  const GetInstalledSources(this._manager);

  StateFlow<InstalledSources> flow(ExtensionType type) {
    return _manager.getInstalledSourcesFlow(type);
  }
}
