import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injecktor/injecktor.dart';

class ShowPlayerControlsCubit extends Cubit<bool> with CloseableMixin {
  ShowPlayerControlsCubit() : super(true);

  void show() => emit(true);

  void hide() => emit(false);

  void toggle() => emit(!state);
}
