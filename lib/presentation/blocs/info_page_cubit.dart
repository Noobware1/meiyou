import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/presentation/blocs/async_cubit/async_cubit.dart';
import 'package:meiyou/presentation/blocs/pluign_manager_usecase_provider_cubit.dart';
import 'package:meiyou_extenstions/models.dart';

class MediaDetailsCubit extends AsyncCubit<MediaDetails> {
  MediaDetailsCubit(this._searchResponse);

  final SearchResponse _searchResponse;

  Future<void> loadMediaDetails(
      PluginRepositoryUseCaseProviderCubit provider) async {
    emit(const AsyncStateLoading());
    // emit(AsyncStateSuccess(mediaDetails));

    final res =
        await provider.state.provider!.loadMediaDetailsUseCase(_searchResponse);
    emit(res is ResponseSuccess
        ? AsyncStateSuccess(res.data!)
        : AsyncStateFailed(res.error!));
  }
}
