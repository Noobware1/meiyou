import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meiyou/core/resources/expections.dart';
import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/domain/entities/media_details.dart';
import 'package:meiyou/domain/entities/movie.dart';
import 'package:meiyou/domain/usecases/get_mapped_movie.dart';
import 'package:meiyou/domain/usecases/provider_use_cases/load_movie_usecase.dart';

part 'fetch_movie_event.dart';
part 'fetch_movie_state.dart';

class FetchMovieBloc extends Bloc<FetchMovieEvent, FetchMovieState> {
  final LoadMovieUseCase loadMovieUseCase;
  final GetMappedMovie getMappedMovieUseCase;

  FetchMovieBloc(
      {required this.loadMovieUseCase, required this.getMappedMovieUseCase})
      : super(const FetchMovieLoading()) {
    on<FetchMovie>(onFetchMovie);
    on<ClearFetchMovieState>(
      (event, emit) => emit(const FetchMovieLoading()),
    );
  }

  FutureOr<void> onFetchMovie(
      FetchMovie event, Emitter<FetchMovieState> emit) async {
    emit(const FetchMovieLoading());

    final response = await loadMovieUseCase.call(event.loadMovieParams);
    if (response is ResponseSuccess) {
      final movie = getMappedMovieUseCase.call(GetMappedMovieParams(
          mediaDetails: event.mediaDetails, movie: response.data!));
      emit(FetchMovieSuccess(movie));
    } else {
      emit(FetchMovieFailed(response.error!));
    }
  }
}
