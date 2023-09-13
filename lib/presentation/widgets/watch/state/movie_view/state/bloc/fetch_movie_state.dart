part of 'fetch_movie_bloc.dart';

sealed class FetchMovieState extends Equatable {
  final MovieEntity? movie;
  final MeiyouException? error;
  const FetchMovieState({this.movie, this.error});

  @override
  List<Object> get props => [movie!, error!];
}

final class FetchMovieLoading extends FetchMovieState {
  const FetchMovieLoading();
}

final class FetchMovieSuccess extends FetchMovieState {
  const FetchMovieSuccess(MovieEntity movie) : super(movie: movie);
}

final class FetchMovieFailed extends FetchMovieState {
  const FetchMovieFailed(MeiyouException error) : super(error: error);
}
