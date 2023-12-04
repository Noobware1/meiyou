import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meiyou/core/resources/expections.dart';
import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/domain/entities/homepage.dart';
import 'package:meiyou/domain/usecases/plugin_manager_usecases/load_full_home_page_usecase.dart';

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
  final List<HomePageEntity>? homePage;
  final MeiyouException? error;

  const LoadHomePageState({this.homePage, this.error});

  Widget when(
      {required Widget Function(List<HomePageEntity> data) success,
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
  List<HomePageEntity> get homePage => super.homePage as List<HomePageEntity>;

  const LoadHomePageSucess(List<HomePageEntity> homePage)
      : super(homePage: homePage);
}

final class LoadHomePageFailed extends LoadHomePageState {
  @override
  MeiyouException get error => super.error as MeiyouException;

  const LoadHomePageFailed(MeiyouException error) : super(error: error);
}