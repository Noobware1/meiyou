part of 'fetch_movie_bloc.dart';

sealed class FetchMovieEvent extends Equatable {
  const FetchMovieEvent();

  @override
  List<Object> get props => [];
}

final class FetchMovie extends FetchMovieEvent {
  final LoadMovieParams loadMovieParams;
  final MediaDetailsEntity mediaDetails;
  const FetchMovie({required this.mediaDetails, required this.loadMovieParams});
}

final class ClearFetchMovieState extends FetchMovieEvent {
  const ClearFetchMovieState();
}
