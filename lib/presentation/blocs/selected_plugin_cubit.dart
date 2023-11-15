import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meiyou/domain/entities/plugin.dart';
import 'package:meiyou/presentation/blocs/selected_plugin_api/plugin_manager_bloc.dart';

class SelectedPluginCubit extends Cubit<PluginEntity> {
  SelectedPluginCubit() : super(PluginEntity.none);

  void changePlugin(PluginEntity plugin, PluginManagerBloc bloc) {
    bloc.add(LoadPlugin(plugin));
    emit(plugin);
  }
}
