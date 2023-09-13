import 'package:meiyou/core/usecases/usecase.dart';
import 'package:meiyou/domain/entities/media_details.dart';
import 'package:meiyou/domain/entities/movie.dart';
import 'package:meiyou/domain/repositories/meta_provider_repository.dart';

class GetMappedMovieParams {
  final MediaDetailsEntity mediaDetails;
  final MovieEntity movie;

  GetMappedMovieParams({required this.mediaDetails, required this.movie});
}

class GetMappedMovie implements UseCase<MovieEntity, GetMappedMovieParams> {
  final MetaProviderRepository _repository;

  GetMappedMovie(this._repository);

  @override
  MovieEntity call(GetMappedMovieParams params) {
    return _repository.getMappedMovie(params.movie,
        mediaDetails: params.mediaDetails);
  }
}
