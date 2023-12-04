import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/domain/entities/plugin_list.dart';
import 'package:meiyou/domain/usecases/plugin_repository/get_all_plugins_usecase.dart';
import 'package:meiyou/presentation/blocs/async_cubit/async_cubit.dart';

class PluginPageCubit extends AsyncCubit<List<PluginListEntity>> {
  final GetAllPluginsUseCase _useCase;
  PluginPageCubit(this._useCase);

  Future<void> getAllPlugins() async {
    emit(const AsyncStateLoading());
    final res = await _useCase.call(null);

    emit(res is ResponseSuccess
        ? AsyncStateSuccess(res.data!)
        : AsyncStateFailed(res.error!));
  }
}
