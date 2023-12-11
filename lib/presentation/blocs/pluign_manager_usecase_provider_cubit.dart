import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:meiyou/core/resources/expections.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';
import 'package:meiyou/data/repositories/plugin_repository_impl.dart';
import 'package:meiyou/domain/entities/installed_plugin.dart';
import 'package:meiyou/domain/usecases/plugin_manager_repository_usecases/load_plugin_usecase.dart';
import 'package:meiyou/presentation/blocs/load_home_page_cubit.dart';
import 'package:meiyou/presentation/blocs/plugin_selector_cubit.dart';
import 'package:meiyou/presentation/providers/plugin_repository_usecase_provider.dart';

class PluginManagerUseCaseProviderState {
  final PluginRepositoryUseCases? provider;
  final MeiyouException? error;

  const PluginManagerUseCaseProviderState({this.provider, this.error});

  bool get isLoading => this is _Loading;

  bool get isCompleted => this is _Success;

  bool get isCompletedWithError => this is _Error;

  bool get isNoPlugin => this is _NoPluginState;

  Widget when(
      {required Widget Function(MeiyouException error) error,
      required Widget Function(PluginRepositoryUseCases provider) done,
      required Widget Function() loading,
      required Widget Function() noPlugin}) {
    if (isLoading) return loading();
    if (isCompleted) return done(provider!);
    if (isNoPlugin) return noPlugin();
    return error(this.error!);
  }
}

class _Success extends PluginManagerUseCaseProviderState {
  const _Success(PluginRepositoryUseCases provider)
      : super(provider: provider);
}

class _Error extends PluginManagerUseCaseProviderState {
  const _Error(MeiyouException error) : super(error: error);
}

class _Loading extends PluginManagerUseCaseProviderState {
  const _Loading();
}

class _NoPluginState extends PluginManagerUseCaseProviderState {
  const _NoPluginState();
}

class PluginRepositoryUseCaseProviderCubit
    extends Cubit<PluginManagerUseCaseProviderState> {
  final LoadPluginUseCase _loadPluginUseCase;
  final LoadHomePageCubit _loadHomePageCubit;

  PluginRepositoryUseCaseProviderCubit(
      this._loadPluginUseCase, this._loadHomePageCubit)
      : super(const _NoPluginState());

  void initPluginMangerUseCaseProvider(InstalledPluginEntity plugin) async {
    if (plugin == InstalledPluginEntity.none) {
      emit(const _NoPluginState());
      return;
    }
    emit(const _Loading());
    try {
      final provider = PluginRepositoryUseCases(PluginRepositoryImpl(
          api: await _loadPluginUseCase.call(plugin)));

      emit(_Success(provider));

      _loadHomePageCubit.loadFullHomePage(provider.loadFullHomePageUseCase);
    } catch (e, s) {
      emit(_Error(MeiyouException(e.toString(), stackTrace: s)));
    }
  }

  void initFromContext(BuildContext context) {
    initPluginMangerUseCaseProvider(context.bloc<PluginSelectorCubit>().state);
  }
}
