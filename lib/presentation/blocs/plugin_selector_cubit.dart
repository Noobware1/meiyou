import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meiyou/domain/entities/plugin.dart';
import 'package:meiyou/domain/usecases/plugin_repository/update_lasted_used_plugin_usecase.dart';
import 'package:meiyou/presentation/blocs/pluign_manager_usecase_provider_cubit.dart';

class PluginSelectorCubit extends Cubit<PluginEntity> {
  final PluginManagerUseCaseProviderCubit _cubit;
  final UpdateLastedUsedPluginUseCase _updateLastedUsedPluginUseCase;

  PluginSelectorCubit(
      PluginEntity? lastUsed, this._updateLastedUsedPluginUseCase, this._cubit)
      : super(lastUsed ?? PluginEntity.none) {
    _cubit.initPluginMangerUseCaseProvider(lastUsed ?? PluginEntity.none);
  }

  void selectPlugin(PluginEntity plugin) {
    _updateLastedUsedPluginUseCase(
        UpdateLastedUsedPluginUseCaseParams(previous: state, current: plugin));
    emit(plugin);
    _cubit.initPluginMangerUseCaseProvider(plugin);
  }
}
