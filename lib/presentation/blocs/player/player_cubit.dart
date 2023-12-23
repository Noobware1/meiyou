import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';

class PlayerState {
  final bool isReady;

  PlayerState({required this.isReady});
}

class PlayerCubit extends Cubit<PlayerState> {
  PlayerCubit() : super(PlayerState(isReady: false));

  play(BuildContext context) async {
    context.bloc();
  }
}
