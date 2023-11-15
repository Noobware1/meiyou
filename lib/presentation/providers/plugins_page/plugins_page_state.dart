part of 'plugins_page_bloc.dart';

sealed class PluginsPageState extends Equatable {
  final List<PluginListEntity>? plugins;

  const PluginsPageState(this.plugins);

  @override
  List<Object> get props => [];
}

final class PluginsPageInitial extends PluginsPageState {}
