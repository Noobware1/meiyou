import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meiyou/core/resources/expections.dart';
import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/domain/usecases/plugin_repository_usecases/load_full_home_page_usecase.dart';
import 'package:meiyou_extensions_lib/models.dart';

class LoadHomePageCubit extends Cubit<LoadHomePageState> {
  LoadHomePageCubit() : super(const LoadHomePageLoading());

  CancelableOperation<ResponseState<List<HomePage>>>? _future;

  Future<void> loadFullHomePage(
      LoadFullHomePageUseCase loadFullHomePageUseCase) async {
    _future?.cancel();

    emit(const LoadHomePageLoading());

    _future =
        CancelableOperation.fromFuture(loadFullHomePageUseCase.call(null));

    final res = await _future!.value;

    if (res is ResponseSuccess) {
      emit(LoadHomePageSucess(res.data!));
    } else {
      emit(LoadHomePageFailed(res.error!));
    }
    _future = null;
  }

  void resetState() {
    emit(const LoadHomePageLoading());
  }

  @override
  Future<void> close() {
    _future = null;
    return super.close();
  }
}

sealed class LoadHomePageState {
  final List<HomePage>? homePage;
  final MeiyouException? error;

  const LoadHomePageState({this.homePage, this.error});

  Widget when(
      {required Widget Function(List<HomePage> data) success,
      required Widget Function(MeiyouException error) failed,
      required Widget Function() loading}) {
    if (this is LoadHomePageSucess) {
      return success(homePage!);
    } else if (this is LoadHomePageFailed) {
      return failed(error!);
    } else {
      return loading();
    }
  }
}

final class LoadHomePageLoading extends LoadHomePageState {
  const LoadHomePageLoading();
}

final class LoadHomePageSucess extends LoadHomePageState {
  @override
  List<HomePage> get homePage => super.homePage as List<HomePage>;

  const LoadHomePageSucess(List<HomePage> homePage) : super(homePage: homePage);
}

final class LoadHomePageFailed extends LoadHomePageState {
  @override
  MeiyouException get error => super.error as MeiyouException;

  const LoadHomePageFailed(MeiyouException error) : super(error: error);
}
