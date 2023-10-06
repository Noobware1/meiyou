part of 'load_video_server_and_video_container_bloc_bloc.dart';

sealed class LoadVideoServerAndVideoContainerState extends Equatable {
  final Map<String, VideoContainerEntity>? data;
  final MeiyouException? error;
  const LoadVideoServerAndVideoContainerState({this.data, this.error});

  @override
  List<Object> get props => [data ?? {}, error ?? MeiyouException.empty];
}

final class LoadVideoServerAndVideoContainerLoading
    extends LoadVideoServerAndVideoContainerState {
  const LoadVideoServerAndVideoContainerLoading();
}

final class LoadVideoServerAndVideoContainerSuccess
    extends LoadVideoServerAndVideoContainerState {
  const LoadVideoServerAndVideoContainerSuccess(
      Map<String, VideoContainerEntity> data)
      : super(data: data);
}

final class LoadVideoServerAndVideoContainerFailed
    extends LoadVideoServerAndVideoContainerState {
  const LoadVideoServerAndVideoContainerFailed(
      MeiyouException error, Map<String, VideoContainerEntity>? data)
      : super(error: error, data: data);
}

final class LoadVideoServerAndVideoContainerCompletedSucess
    extends LoadVideoServerAndVideoContainerState {
  const LoadVideoServerAndVideoContainerCompletedSucess(
      Map<String, VideoContainerEntity>? data)
      : super(data: data);
}

final class LoadVideoServerAndVideoContainerCompletedError
    extends LoadVideoServerAndVideoContainerState {
  const LoadVideoServerAndVideoContainerCompletedError(MeiyouException error)
      : super(error: error);
}
