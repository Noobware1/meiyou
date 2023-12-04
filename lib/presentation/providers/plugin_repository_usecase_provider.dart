import 'package:meiyou/domain/repositories/plugin_repository.dart';
import 'package:meiyou/domain/usecases/plugin_repository/check_for_plugin_update_usecase.dart';
import 'package:meiyou/domain/usecases/plugin_repository/get_all_plugins_usecase.dart';
import 'package:meiyou/domain/usecases/plugin_repository/get_installed_plugins_usecase.dart';
import 'package:meiyou/domain/usecases/plugin_repository/get_lasted_used_plugin_usecase.dart';
import 'package:meiyou/domain/usecases/plugin_repository/get_outdated_plugins_usecase.dart';
import 'package:meiyou/domain/usecases/plugin_repository/install_plugin_usecase.dart';
import 'package:meiyou/domain/usecases/plugin_repository/load_plugin_usecase.dart';
import 'package:meiyou/domain/usecases/plugin_repository/uninstall_plugin_usecase.dart';
import 'package:meiyou/domain/usecases/plugin_repository/update_lasted_used_plugin_usecase.dart';
import 'package:meiyou/domain/usecases/plugin_repository/update_plugin_usecase.dart';

class PluginRepositoryUseCaseProvider {
  
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

  PluginRepositoryUseCaseProvider(PluginRepository repository)
      : getAllPluginsUseCase = GetAllPluginsUseCase(repository),
        getInstalledPluginsUseCase = GetInstalledPluginsUseCase(repository),
        installPluginUseCase = InstallPluginUseCase(repository),
        uninstallPluginUseCase = UninstallPluginUseCase(repository),
        checkForPluginUpdateUseCase = CheckForPluginUpdateUseCase(repository),
        updatePluginUseCase = UpdatePluginUseCase(repository),
        getOutDatedPluginsUseCase = GetOutDatedPluginsUseCase(repository),
        loadPluginUseCase = LoadPluginUseCase(repository),
        updateLastUsedPluginUseCase = UpdateLastedUsedPluginUseCase(repository),
        getLastedUsedPluginUseCase = GetLastedUsedPluginUseCase(repository);
}
