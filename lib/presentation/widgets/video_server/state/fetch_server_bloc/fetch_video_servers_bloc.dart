import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meiyou/core/resources/expections.dart';
import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/domain/entities/video_server.dart';
import 'package:meiyou/domain/usecases/provider_use_cases/load_video_server_usecase.dart';
import 'package:meiyou/presentation/widgets/video_server/extracted_video_cubit/extracted_video_cubit.dart';

part 'fetch_video_servers_event.dart';
part 'fetch_video_servers_state.dart';

class FetchVideoServersBloc
    extends Bloc<FetchVideoServersEvent, FetchVideoServersState> {
  final LoadVideoServersUseCase _loadVideoServersUseCase;
  final ExtractedVideoServers _extractedVideoServersBloc;
  FetchVideoServersBloc(
      this._loadVideoServersUseCase, this._extractedVideoServersBloc)
      : super(const FetchVideoServersLoading()) {
    on<FetchVideoServers>(onFetchVideoServers);
  }

  FutureOr<void> onFetchVideoServers(
      FetchVideoServers event, Emitter<FetchVideoServersState> emit) async {
    emit(const FetchVideoServersLoading());
    final videoServers = await _loadVideoServersUseCase.call(event.params);
    if (videoServers is ResponseFailed) {
      emit(FetchVideoServersFailed(videoServers.error!));
    } else {
      emit(FetchVideoServersSuccess(videoServers.data!));
      _extractedVideoServersBloc.add(ExtractVideo(
          servers: videoServers.data!, provider: event.params.provider));
    }
  }
}
