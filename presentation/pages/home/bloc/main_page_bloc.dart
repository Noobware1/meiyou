import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meiyou/core/resources/expections.dart';
import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/core/usecases/no_params.dart';
import 'package:meiyou/domain/entities/main_page.dart';
import 'package:meiyou/domain/usecases/get_main_page_usecase.dart';

part 'main_page_event.dart';
part 'main_page_state.dart';

class MainPageBloc extends Bloc<MainPageEvent, MainPageState> {
  final GetMainPageUseCase getMainPageUseCase;
  MainPageBloc(this.getMainPageUseCase) : super(const MainPageLoading()) {
    on<GetMainPage>(getMainPage);
  }

  FutureOr<void> getMainPage(
      GetMainPage event, Emitter<MainPageState> emit) async {
    emit(const MainPageLoading());
    final mainPageResponse = await getMainPageUseCase.call(noParams);
    if (mainPageResponse is ResponseSuccess) {
      emit(MainPageWithData(mainPageResponse.data!));
    } else {
      emit(MainPageWithError(mainPageResponse.error!));
    }
  }
}
