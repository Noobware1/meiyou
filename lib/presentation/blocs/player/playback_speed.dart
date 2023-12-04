import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meiyou/presentation/providers/player_provider.dart';

class PlaybackSpeedCubit extends Cubit<double> {
  PlaybackSpeedCubit() : super(1.0);

  void setPlaybackSpeed(BuildContext context, double speed) {
    playerProvider(context).player.setRate(speed);
    emit(speed);
  }
}
