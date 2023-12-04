import 'package:flutter_bloc/flutter_bloc.dart';

class ShowVideoControlsCubit extends Cubit<bool> {
  ShowVideoControlsCubit() : super(true);

  void hideControls() {
    emit(false);
  }

  void showControls() {
    emit(true);
  }
}
