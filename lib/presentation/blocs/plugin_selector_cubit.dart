import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meiyou/domain/entities/installed_plugin.dart';
import 'package:meiyou/domain/usecases/plugin_manager_repository_usecases/update_lasted_used_plugin_usecase.dart';
import 'package:meiyou/presentation/blocs/pluign_manager_usecase_provider_cubit.dart';

class PluginSelectorCubit extends Cubit<InstalledPluginEntity> {
  final PluginRepositoryUseCaseProviderCubit _cubit;
  final UpdateLastedUsedPluginUseCase _updateLastedUsedPluginUseCase;

  late final StreamSubscription _subscription;

  PluginSelectorCubit(
      Stream<List<InstalledPluginEntity>> installedPluginsStream,
      InstalledPluginEntity? lastUsed,
      this._updateLastedUsedPluginUseCase,
      this._cubit)
      : super(lastUsed ?? InstalledPluginEntity.none) {
    _cubit.initPluginMangerUseCaseProvider(
        lastUsed ?? InstalledPluginEntity.none);

    _subscription = installedPluginsStream.listen((installedPlugins) {
      // if (state != InstalledPluginEntity.none) {
      //   if (installedPlugins.isEmpty || !installedPlugins.contains(state)) {
      //     emit(InstalledPluginEntity.none);
      //     _cubit.initPluginMangerUseCaseProvider(InstalledPluginEntity.none);
      //   }
      // }
    });
  }

  void selectPlugin(InstalledPluginEntity plugin) {
    _updateLastedUsedPluginUseCase(
        UpdateLastedUsedPluginUseCaseParams(previous: state, current: plugin));
    emit(plugin);
    _cubit.initPluginMangerUseCaseProvider(plugin);
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
