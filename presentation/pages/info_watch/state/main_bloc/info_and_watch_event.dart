part of 'info_and_watch_bloc.dart';

abstract class InfoAndWatchEvent extends Equatable {
  const InfoAndWatchEvent();

  @override
  List<Object> get props => [];
}

class GetMediaDetails extends InfoAndWatchEvent {
  const GetMediaDetails();
}
