import 'package:flutter_bloc/flutter_bloc.dart';

class ShowEpisodeSelectorWidgetCubit extends Cubit<bool> {
  ShowEpisodeSelectorWidgetCubit() : super(false);

  void toggleShowEpisodeSelectorWidget() {
    state == false ? emit(true) : emit(false);
  }
}
