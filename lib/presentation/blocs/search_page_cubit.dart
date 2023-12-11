import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/domain/usecases/plugin_repository_usecases/search_usecase.dart';
import 'package:meiyou/presentation/blocs/async_cubit/async_cubit.dart';
import 'package:meiyou_extenstions/models.dart';

class SearchPageCubit extends AsyncCubit<List<SearchResponse>> {
  final LoadSearchUseCase loadSearchUseCase;
  SearchPageCubit(this.loadSearchUseCase) : super(const SearchPageInital());

  String _query = '';

  void search(String query) async {
    _query = query;
    if (_query.isEmpty) {
      emit(const SearchPageInital());
      return;
    }

    emit(const AsyncStateLoading());
    final res = await loadSearchUseCase.call(query);
    emit(res is ResponseSuccess
        ? AsyncStateSuccess(res.data!)
        : AsyncStateFailed(res.error!));
  }

  void retryLastSearch() async {
    emit(const AsyncStateLoading());
    final res = await loadSearchUseCase.call(_query);
    emit(res is ResponseSuccess
        ? AsyncStateSuccess(res.data!)
        : AsyncStateFailed(res.error!));
  }
}

class SearchPageInital extends AsyncState<List<SearchResponse>> {
  const SearchPageInital();
}
