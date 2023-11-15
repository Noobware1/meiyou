part of 'plugin_manager_bloc.dart';

sealed class PluginManagerState extends Equatable {
  final MeiyouException? error;
  final PluginManagerRepository? pluginManager;
  const PluginManagerState({this.error, this.pluginManager});

  @override
  List<Object> get props => [error!, pluginManager!];
}

final class PluginManagerIntialising extends PluginManagerState {
  const PluginManagerIntialising();
}

final class PluginManagerIntialised extends PluginManagerState {
  const PluginManagerIntialised(PluginManagerRepository pluginManager)
      : super(pluginManager: pluginManager);
}

final class PluginManagerNotIntialised extends PluginManagerState {
  const PluginManagerNotIntialised(MeiyouException error) : super(error: error);
}



final class PluginMangerNone extends PluginManagerState {
  const PluginMangerNone();
}
