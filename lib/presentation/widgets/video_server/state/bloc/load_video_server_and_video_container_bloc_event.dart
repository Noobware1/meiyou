part of 'load_video_server_and_video_container_bloc_bloc.dart';

sealed class LoadVideoServerAndVideoContainerEvent extends Equatable {
  final BaseProvider provider;
  final String url;
  const LoadVideoServerAndVideoContainerEvent(this.provider, this.url);

  @override
  List<Object> get props => [provider, url];
}


final class LoadVideoServerAndVideoContainer extends  LoadVideoServerAndVideoContainerEvent {
  const LoadVideoServerAndVideoContainer(super.provider, super.url);

}