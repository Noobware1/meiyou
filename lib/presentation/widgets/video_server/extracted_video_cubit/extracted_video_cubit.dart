import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meiyou/core/resources/expections.dart';
import 'package:meiyou/core/resources/providers/base_provider.dart';
import 'package:meiyou/domain/entities/video_container.dart';
import 'package:meiyou/domain/entities/video_server.dart';
import 'package:meiyou/domain/usecases/provider_use_cases/load_video_extractor_usecase.dart';

sealed class ExtractedVideoServerEvent extends Equatable {
  final List<VideoSeverEntity> servers;
  final BaseProvider provider;
  const ExtractedVideoServerEvent(
      {required this.provider, required this.servers});

  @override
  List<Object?> get props => [servers, provider];
}

final class ExtractVideo extends ExtractedVideoServerEvent {
  const ExtractVideo({required super.servers, required super.provider});
}

sealed class ExtractedVideoServerState extends Equatable {
  final Map<VideoSeverEntity, VideoContainerEntity>? data;
  final MeiyouException? error;
  const ExtractedVideoServerState({this.data, this.error});

  @override
  List<Object?> get props => [data!, error!];
}

class ExtractedVideoServerExtracting extends ExtractedVideoServerState {
  const ExtractedVideoServerExtracting();
}

class ExtractedVideoServerExtractionSucess extends ExtractedVideoServerState {
  const ExtractedVideoServerExtractionSucess(
      Map<VideoSeverEntity, VideoContainerEntity> data)
      : super(data: data);
}

class ExtractedVideoServerExtractionFailed extends ExtractedVideoServerState {
  const ExtractedVideoServerExtractionFailed(
      {super.data, required MeiyouException error})
      : super(error: error);
}

class ExtractedVideoServers
    extends Bloc<ExtractedVideoServerEvent, ExtractedVideoServerState> {
  final LoadVideoExtractorUseCase loadVideoExtractorUseCase;
  // final LoadVideoServersUseCase loadVideoServersUseCase;

  ExtractedVideoServers({
    required this.loadVideoExtractorUseCase,
    // required this.loadVideoServersUseCase,
  }) : super(const ExtractedVideoServerExtracting()) {
    on<ExtractVideo>(onExtractVideo);
  }

  FutureOr<void> onExtractVideo(
      ExtractVideo event, Emitter<ExtractedVideoServerState> emit) async {
    emit(const ExtractedVideoServerExtracting());
    final Map<VideoSeverEntity, VideoContainerEntity> data = {};

    for (final server in event.servers) {
      try {
        final container = await loadVideoExtractorUseCase
            .call(LoadVideoExtractorParams(
                server: server, provider: event.provider))
            ?.extract();
        if (container != null) {
          data[server] = container;
          emit(ExtractedVideoServerExtractionSucess(data));
        }
      } catch (error, stack) {
        emit(ExtractedVideoServerExtractionFailed(
            error: MeiyouException(error.toString(), stackTrace: stack),
            data: data));
      }
    }
  }
}
