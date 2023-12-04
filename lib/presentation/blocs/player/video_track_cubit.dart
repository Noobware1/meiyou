import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_kit/media_kit.dart';
import 'package:meiyou/presentation/providers/player_provider.dart';

class VideoTrackCubit extends Cubit<VideoTrack> {
  VideoTrackCubit() : super(VideoTrack.auto());

  void changeVideoTrack(BuildContext context, VideoTrack track) {
    playerProvider(context).player.setVideoTrack(track);
    emit(track);
  }
}
