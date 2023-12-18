import 'package:async/async.dart';
import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/domain/usecases/plugin_repository_usecases/search_usecase.dart';
import 'package:meiyou/presentation/blocs/async_cubit/async_cubit.dart';
import 'package:meiyou_extensions_lib/models.dart';

class SearchPageCubit extends AsyncCubit<List<SearchResponse>> {
  final LoadSearchUseCase loadSearchUseCase;
  SearchPageCubit(this.loadSearchUseCase) : super(const SearchPageInital());

  String _query = '';

  CancelableOperation<ResponseState<List<SearchResponse>>>? _future;

  void search(String query) async {
    _future?.cancel();

    _query = query;
    if (_query.isEmpty) {
      emit(const SearchPageInital());
      return;
    }

    emit(const AsyncStateLoading());
    _future = CancelableOperation.fromFuture(loadSearchUseCase.call(_query));
    final res = await _future!.value;
    emit(res is ResponseSuccess
        ? AsyncStateSuccess(res.data!)
        : AsyncStateFailed(res.error!));
  }

  void retryLastSearch() async {
    _future?.cancel();
    emit(const AsyncStateLoading());
    _future = CancelableOperation.fromFuture(loadSearchUseCase.call(_query));

    final res = await _future!.value;

    emit(res is ResponseSuccess
        ? AsyncStateSuccess(res.data!)
        : AsyncStateFailed(res.error!));
  }
}

class SearchPageInital extends AsyncState<List<SearchResponse>> {
  const SearchPageInital();
}
