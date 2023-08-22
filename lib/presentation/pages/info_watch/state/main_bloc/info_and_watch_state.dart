part of 'info_and_watch_bloc.dart';

abstract class InfoAndWatchState extends Equatable {
  final MediaDetailsEntity? media;
  final MeiyouException? error;
  const InfoAndWatchState({this.media, this.error});

  @override
  List<Object> get props => [media!, error!];
}

class InfoAndWatchLoading extends InfoAndWatchState {
  const InfoAndWatchLoading();
}

class InfoAndWatchCompletedWithData extends InfoAndWatchState {
  const InfoAndWatchCompletedWithData(MediaDetailsEntity media)
      : super(media: media);
}

class InfoAndWatchCompletedWithError extends InfoAndWatchState {
  const InfoAndWatchCompletedWithError(MeiyouException error)
      : super(error: error);
}
