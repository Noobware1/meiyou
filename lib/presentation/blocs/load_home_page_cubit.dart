import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meiyou/core/resources/expections.dart';
import 'package:meiyou/domain/usecases/plugin_repository_usecases/load_full_home_page_usecase.dart';
import 'package:meiyou_extenstions/models.dart';


class LoadHomePageCubit extends Cubit<LoadHomePageState> {
  LoadHomePageCubit() : super(const LoadHomePageLoading());

  Future<void> loadFullHomePage(
      LoadFullHomePageUseCase loadFullHomePageUseCase) async {
    emit(const LoadHomePageLoading());
    final res = await loadFullHomePageUseCase.call(null);

    // if (res is ResponseSuccess) {
    //   emit(LoadHomePageSucess(res.data!));
    // } else {
    //   emit(LoadHomePageFailed(res.error!));
    // }
  }

  void resetState() {
    emit(const LoadHomePageLoading());
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
