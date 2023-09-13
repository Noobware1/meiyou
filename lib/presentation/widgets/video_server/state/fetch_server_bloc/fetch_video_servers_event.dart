part of 'fetch_video_servers_bloc.dart';

sealed class FetchVideoServersEvent extends Equatable {
  final LoadVideoServersParams params;

  const FetchVideoServersEvent(
    this.params,
  );

  @override
  List<Object> get props => [params];
}

final class FetchVideoServers extends FetchVideoServersEvent {
  const FetchVideoServers(
    super.params,
  );
}
