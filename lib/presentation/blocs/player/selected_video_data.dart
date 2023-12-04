import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';
import 'package:meiyou/data/models/media/video/video_source.dart';
import 'package:meiyou/domain/entities/extractor_link.dart';
import 'package:meiyou/domain/usecases/video_player_repository_usecases/change_source.dart';
import 'package:meiyou/presentation/blocs/player/server_and_video_cubit.dart';
import 'package:meiyou/presentation/providers/player_provider.dart';
import 'package:meiyou/presentation/providers/video_player_repository_usecases.dart';

class SelectedVideoDataCubit extends Cubit<SelectedVideoDataState> {
  SelectedVideoDataCubit() : super(SelectedVideoDataStateInital());

  void setStateByIndexes(int serverIndex, int sourceIndex) {
    emit(SelectedVideoDataState(
        serverIndex: serverIndex, sourceIndex: sourceIndex));
  }

  void resetState() {
    emit(SelectedVideoDataStateInital());
  }

  void setStateFromData(
      BuildContext context,
      ExtractedVideoDataState extractedVideoDataState,
      (ExtractorLinkEntity, VideoSource) data) {
    final serverIndex =
        extractedVideoDataState.data.indexWhere((e) => e.link == data.$1);

    final state = SelectedVideoDataState(
        serverIndex: serverIndex,
        sourceIndex: extractedVideoDataState
            .data[serverIndex].video.videoSources
            .indexOf(data.$2));

    context.repository<VideoPlayerRepositoryUseCases>().changeSourceUseCase(
          ChangeSourceUseCaseParams(
            video: context
                .bloc<ExtractedVideoDataCubit>()
                .state
                .data[serverIndex]
                .video,
            selectedSource: state.sourceIndex,
            player: playerProvider(context).player,
            startPostion: playerProvider(context).player.state.position,
          ),
        );

    emit(state);
  }
}

class SelectedVideoDataState {
  final int serverIndex;
  final int sourceIndex;

  SelectedVideoDataState(
      {required this.serverIndex, required this.sourceIndex});
}

class SelectedVideoDataStateInital extends SelectedVideoDataState {
  SelectedVideoDataStateInital() : super(serverIndex: -1, sourceIndex: -1);
}
