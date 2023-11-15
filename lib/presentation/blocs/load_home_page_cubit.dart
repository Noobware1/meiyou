import 'dart:async';

import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/domain/entities/homepage.dart';
import 'package:meiyou/domain/usecases/plugin_manager_usecases/load_full_home_page_usecase.dart';
import 'package:meiyou/presentation/blocs/async_cubit/async_cubit.dart';
import 'package:meiyou/presentation/blocs/selected_plugin_api/plugin_manager_bloc.dart';

class LoadHomePageCubit extends AsyncCubit<List<HomePageEntity>> {
  late final StreamSubscription _subscription;
  LoadHomePageCubit(Stream<PluginManagerState> stream) {
    _subscription = stream.listen((state) {
      if (state is PluginManagerIntialised) {
        loadFullHomePage(LoadFullHomePageUseCase(state.pluginManager!));
      }
    });
  }

  Future<void> loadFullHomePage(
      LoadFullHomePageUseCase loadFullHomePageUseCase) async {
    emit(const AsyncStateLoading());
    final res = await loadFullHomePageUseCase.call(null);
    emit(res is ResponseSuccess
        ? AsyncStateSuccess(res.data!)
        : AsyncStateFailed(res.error!));
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
