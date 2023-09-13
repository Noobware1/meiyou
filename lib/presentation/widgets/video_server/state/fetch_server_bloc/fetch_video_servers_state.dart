part of 'fetch_video_servers_bloc.dart';

sealed class FetchVideoServersState extends Equatable {
  final List<VideoSeverEntity>? servers;
  final MeiyouException? error;
  const FetchVideoServersState({this.servers, this.error});

  @override
  List<Object> get props => [servers!, error!];
}

final class FetchVideoServersLoading extends FetchVideoServersState {
  const FetchVideoServersLoading();
}

final class FetchVideoServersFailed extends FetchVideoServersState {
  const FetchVideoServersFailed(MeiyouException error) : super(error: error);
}

final class FetchVideoServersSuccess extends FetchVideoServersState {
  const FetchVideoServersSuccess(
      List<VideoSeverEntity> servers)
      : super(servers: servers);
}
