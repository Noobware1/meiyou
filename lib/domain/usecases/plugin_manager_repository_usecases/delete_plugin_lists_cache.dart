import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/repositories/plugin_manager_repository.dart';

class DeletePluginListsCache implements UseCase<void, void> {
  final PluginManagerRepository _repository;

  DeletePluginListsCache(this._repository);

  @override
  void call(void params) {
    return _repository.deletePluginListsCache();
  }
}
