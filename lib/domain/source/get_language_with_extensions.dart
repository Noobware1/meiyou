
import 'package:meiyou/core/utils/resources/flow.dart';
import 'package:meiyou/extension/models/entension_type.dart';
import 'package:meiyou/domain/source/source_manager.dart';

class GetLanguageWithAvailableExtensions {
  final SourceManager _manager;
  const GetLanguageWithAvailableExtensions(
    this._manager,
  );

  StateFlow<AvailableSources> flow(ExtensionType type) {
    return _manager.getAvaiableSourcesFlow(type);
  }
}
