// import 'package:meiyou/core/resources/response_state.dart';
// import 'package:meiyou/domain/entities/plugin_list.dart';
// import 'package:meiyou/domain/usecases/plugin_repository/get_installed_plugins_usecase.dart';
// import 'package:meiyou/presentation/blocs/async_cubit/async_cubit.dart';
// import 'package:meiyou/presentation/blocs/selected_plugin_api/plugin_manager_bloc.dart';
// import 'package:meiyou/presentation/blocs/selected_plugin_cubit.dart';

// class GetInstalledPluginsCubit extends AsyncCubit<PluginListEntity> {
//   final GetInstalledPluginsUseCase _getInstalledPluginsUseCase;
//   final PluginManagerBloc _pluginManagerBloc;
//   final SelectedPluginCubit _selectedPluginCubit;
//   GetInstalledPluginsCubit(
//       this._getInstalledPluginsUseCase, this._selectedPluginCubit, this._pluginManagerBloc);

//   Future<void> getInstalledPlugins(String type) async {
//     emit(const AsyncStateLoading());
//     final res = await _getInstalledPluginsUseCase.call(type);
//     if (res is ResponseSuccess) {
//       emit(AsyncStateSuccess(res.data!));
//       _selectedPluginCubit.changePlugin(res.data!.plugins.first, _pluginManagerBloc);
//     } else {
//       emit(AsyncStateFailed(res.error!));
//     }
//   }
// }

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meiyou/core/utils/network.dart';
import 'package:meiyou/domain/entities/loaded_plugin.dart';
import 'package:meiyou/domain/entities/plugin.dart';
import 'package:meiyou/domain/repositories/plugin_repository.dart';
import 'package:meiyou/domain/usecases/plugin_repository/get_installed_plugins_usecase.dart';

class GetInstalledPlugins extends Cubit<List<PluginEntity>> {
  final List<PluginEntity> _loadedPlugins = [];
  late final StreamSubscription _subscription;

  GetInstalledPlugins(Stream<PluginEntity> stream) : super([]) {
    _subscription = stream.listen(
      (plugin) {
        _loadedPlugins.add(plugin);
        emit(_loadedPlugins);
      },
      onDone: () => tryWithAsync(() => _subscription.cancel()),
      cancelOnError: false,
    );
  }

  @override
  Future<void> close() {
    tryWithAsync(() => _subscription.cancel());
    _loadedPlugins.clear();
    return super.close();
  }
}
