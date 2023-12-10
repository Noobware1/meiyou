import 'package:meiyou/domain/repositories/plugin_manager_repository.dart';
import 'package:meiyou/domain/usecases/plugin_manager_repository_usecases/check_for_plugin_update_usecase.dart';
import 'package:meiyou/domain/usecases/plugin_manager_repository_usecases/delete_plugin_lists_cache.dart';
import 'package:meiyou/domain/usecases/plugin_manager_repository_usecases/get_all_plugins_usecase.dart';
import 'package:meiyou/domain/usecases/plugin_manager_repository_usecases/get_installed_plugins_usecase.dart';
import 'package:meiyou/domain/usecases/plugin_manager_repository_usecases/get_lasted_used_plugin_usecase.dart';
import 'package:meiyou/domain/usecases/plugin_manager_repository_usecases/get_outdated_plugins_usecase.dart';
import 'package:meiyou/domain/usecases/plugin_manager_repository_usecases/install_plugin_usecase.dart';
import 'package:meiyou/domain/usecases/plugin_manager_repository_usecases/load_plugin_usecase.dart';
import 'package:meiyou/domain/usecases/plugin_manager_repository_usecases/uninstall_plugin_usecase.dart';
import 'package:meiyou/domain/usecases/plugin_manager_repository_usecases/update_lasted_used_plugin_usecase.dart';
import 'package:meiyou/domain/usecases/plugin_manager_repository_usecases/update_plugin_usecase.dart';

class PluginManagerRepositoryUseCases {
  final GetAllPluginsUseCase getAllPluginsUseCase;

  final GetInstalledPluginsUseCase getInstalledPluginsUseCase;

  final InstallPluginUseCase installPluginUseCase;

  final UninstallPluginUseCase uninstallPluginUseCase;

  final CheckForPluginUpdateUseCase checkForPluginUpdateUseCase;

  final UpdatePluginUseCase updatePluginUseCase;

  final GetOutDatedPluginsUseCase getOutDatedPluginsUseCase;

  final LoadPluginUseCase loadPluginUseCase;

  final UpdateLastedUsedPluginUseCase updateLastUsedPluginUseCase;

  final GetLastedUsedPluginUseCase getLastedUsedPluginUseCase;

  final DeletePluginListsCache deletePluginListsCache;

  PluginManagerRepositoryUseCases(PluginManagerRepository repository)
      : getAllPluginsUseCase = GetAllPluginsUseCase(repository),
        getInstalledPluginsUseCase = GetInstalledPluginsUseCase(repository),
        installPluginUseCase = InstallPluginUseCase(repository),
        uninstallPluginUseCase = UninstallPluginUseCase(repository),
        checkForPluginUpdateUseCase = CheckForPluginUpdateUseCase(repository),
        updatePluginUseCase = UpdatePluginUseCase(repository),
        getOutDatedPluginsUseCase = GetOutDatedPluginsUseCase(repository),
        loadPluginUseCase = LoadPluginUseCase(repository),
        updateLastUsedPluginUseCase = UpdateLastedUsedPluginUseCase(repository),
        getLastedUsedPluginUseCase = GetLastedUsedPluginUseCase(repository),
        deletePluginListsCache = DeletePluginListsCache(repository);
}
