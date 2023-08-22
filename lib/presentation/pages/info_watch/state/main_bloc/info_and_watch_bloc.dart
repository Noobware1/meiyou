import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meiyou/core/resources/expections.dart';
import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/data/data_source/providers/meta_providers/anilist.dart';
import 'package:meiyou/data/data_source/providers/meta_providers/tmdb.dart';
import 'package:meiyou/data/repositories/media_details_repository_impl.dart';
import 'package:meiyou/domain/entities/media_details.dart';
import 'package:meiyou/domain/entities/meta_response.dart';
import 'package:meiyou/domain/repositories/media_details_repository.dart';
import 'package:meiyou/domain/usecases/get_media_details_usecase.dart';

part 'info_and_watch_event.dart';
part 'info_and_watch_state.dart';

class InfoAndWatchBloc extends Bloc<InfoAndWatchEvent, InfoAndWatchState> {
  final MetaResponseEntity response;
  final Anilist anilist;
  final TMDB tmdb;

  InfoAndWatchBloc(
      {required this.response, required this.anilist, required this.tmdb})
      : super(const InfoAndWatchLoading()) {
    on<GetMediaDetails>(getMediaDetails);
  }

  FutureOr<void> getMediaDetails(
      GetMediaDetails event, Emitter<InfoAndWatchState> emit) async {
    emit(const InfoAndWatchLoading());
    final media =
        await GetMediaDetailUseCase(MediaDetailsRepositoryImpl(anilist, tmdb))
            .call(response);
    if (media is ResponseFailed) {
      emit(InfoAndWatchCompletedWithError(media.error!));
    } else {
      emit(InfoAndWatchCompletedWithData(media.data!));
    }
  }
}
