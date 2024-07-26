import 'package:meiyou/core/injection/injection.dart';
import 'package:meiyou/shared/domain/extension_manager/extension_manger.dart';

bool ifSourcesLoaded() {
  return getIt.get<ExtensionManager>().isInitialized;
}
