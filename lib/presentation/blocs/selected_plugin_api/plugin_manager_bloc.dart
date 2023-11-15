import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meiyou/core/resources/expections.dart';
import 'package:meiyou/data/repositories/plugin_manager_repository_impl.dart';
import 'package:meiyou/domain/entities/plugin.dart';
import 'package:meiyou/domain/repositories/plugin_manager_repository.dart';
import 'package:meiyou/domain/usecases/plugin_repository/load_plugin_usecase.dart';

part 'plugin_manager_event.dart';
part 'plugin_manager_state.dart';

class PluginManagerBloc extends Bloc<PluginManagerEvent, PluginManagerState> {
  final LoadPluginUseCase _loadPluginUseCase;
  PluginManagerBloc(this._loadPluginUseCase)
      : super(const PluginManagerIntialising()) {
    on<LoadPlugin>(_loadPlugin);
  }

  FutureOr<void> _loadPlugin(
      LoadPlugin event, Emitter<PluginManagerState> emit) async {
    emit(const PluginManagerIntialising());

    if (event.plugin == PluginEntity.none) {
      emit(const PluginMangerNone());
    } else {
      try {
        final plugin = PluginManagerRepositoryImpl(
            api: await _loadPluginUseCase.call(event.plugin));

        emit(PluginManagerIntialised(plugin));
      } catch (e, s) {
        emit(PluginManagerNotIntialised(
            MeiyouException(e.toString(), stackTrace: s)));
      }
    }
  }
}
