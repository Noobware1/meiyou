import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/domain/entities/media_details.dart';
import 'package:meiyou/domain/entities/search_response.dart';
import 'package:meiyou/presentation/blocs/async_cubit/async_cubit.dart';
import 'package:meiyou/presentation/blocs/pluign_manager_usecase_provider_cubit.dart';

class MediaDetailsCubit extends AsyncCubit<MediaDetailsEntity> {
  MediaDetailsCubit(this._searchResponse);

  final SearchResponseEntity _searchResponse;

  Future<void> loadMediaDetails(
      PluginManagerUseCaseProviderCubit provider) async {
    emit(const AsyncStateLoading());
    // emit(AsyncStateSuccess(mediaDetails));

    final res =
        await provider.state.provider!.loadMediaDetailsUseCase(_searchResponse);
    emit(res is ResponseSuccess
        ? AsyncStateSuccess(res.data!)
        : AsyncStateFailed(res.error!));
  }
}
