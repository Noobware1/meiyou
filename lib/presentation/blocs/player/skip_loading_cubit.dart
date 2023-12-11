import 'package:flutter_bloc/flutter_bloc.dart';

class SkipLoadingCubit extends Cubit<bool> {
  SkipLoadingCubit() : super(false);

  void skipLoading() {
    emit(true);
  }

  void resetState() {
    emit(false);
  }

}
