import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meiyou/core/resources/bloc_concurrency.dart/restartable.dart';
import 'package:meiyou/core/resources/expections.dart';
import 'package:meiyou/core/resources/providers/base_provider.dart';
import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/domain/entities/video_container.dart';
import 'package:meiyou/domain/repositories/cache_repository.dart';
import 'package:meiyou/domain/usecases/provider_use_cases/load_server_and_video_usecase.dart';

part 'load_video_server_and_video_container_bloc_event.dart';
part 'load_video_server_and_video_container_bloc_state.dart';

class LoadVideoServerAndVideoContainerBloc extends Bloc<
    LoadVideoServerAndVideoContainerEvent,
    LoadVideoServerAndVideoContainerState> {
  final LoadServerAndVideoUseCase loadServerAndVideoUseCase;
  final CacheRespository cacheRespository;

  LoadVideoServerAndVideoContainerBloc(
      this.loadServerAndVideoUseCase, this.cacheRespository)
      : super(const LoadVideoServerAndVideoContainerLoading()) {
    on<LoadVideoServerAndVideoContainer>(onLoadVideoServerAndVideoContainer,
        transformer: restartable());
    on<_OnData>(
      (event, emit) =>
          emit(LoadVideoServerAndVideoContainerSuccess(event.data)),
    );
    on<_OnError>((event, emit) {
      print(event.error);
      emit(LoadVideoServerAndVideoContainerFailed(event.error, event.data));
    });
  }

  FutureOr<void> onLoadVideoServerAndVideoContainer(
      LoadVideoServerAndVideoContainer event,
      Emitter<LoadVideoServerAndVideoContainerState> emit) async {
    emit(const LoadVideoServerAndVideoContainerLoading());
    final response = await loadServerAndVideoUseCase.call(
      LoadServerAndVideoUseCaseParams(
          provider: event.provider,
          url: event.url,
          cacheRespository: cacheRespository,
          onData: (data) => add(_OnData(data, event.provider, event.url)),
          onError: (error, data) =>
              add(_OnError(data, error, event.provider, event.url))),
    );

    if (response is ResponseFailed) {
      emit(LoadVideoServerAndVideoContainerCompletedError(
        response.error!,
      ));
      print(response.error);
    } else {
      emit(LoadVideoServerAndVideoContainerCompletedSucess(response.data!));
    }
  }
}

class _OnData extends LoadVideoServerAndVideoContainerEvent {
  final Map<String, VideoContainerEntity> data;
  const _OnData(
    this.data,
    super.provider,
    super.url,
  );
}

class _OnError extends LoadVideoServerAndVideoContainerEvent {
  final Map<String, VideoContainerEntity>? data;
  final MeiyouException error;
  const _OnError(
    this.data,
    this.error,
    super.provider,
    super.url,
  );
}
