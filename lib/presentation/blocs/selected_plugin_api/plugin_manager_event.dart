part of 'plugin_manager_bloc.dart';

sealed class PluginManagerEvent extends Equatable {
  const PluginManagerEvent();

  @override
  List<Object> get props => [];
}

final class LoadPlugin extends PluginManagerEvent {
  final PluginEntity plugin;
  const LoadPlugin(this.plugin);
}
