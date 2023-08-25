import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meiyou/core/resources/expections.dart';
import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/domain/entities/media_details.dart';
import 'package:meiyou/domain/entities/meta_response.dart';
import 'package:meiyou/domain/repositories/meta_provider_repository.dart';
import 'package:meiyou/domain/usecases/get_media_details_usecase.dart';

part 'info_and_watch_event.dart';
part 'info_and_watch_state.dart';

class InfoAndWatchBloc extends Bloc<InfoAndWatchEvent, InfoAndWatchState> {
  final MetaResponseEntity response;
  final MetaProviderRepository repository;

  InfoAndWatchBloc({
    required this.response,
    required this.repository,
  }) : super(const InfoAndWatchLoading()) {
    on<GetMediaDetails>(getMediaDetails);
  }

  FutureOr<void> getMediaDetails(
      GetMediaDetails event, Emitter<InfoAndWatchState> emit) async {
    emit(const InfoAndWatchLoading());
    final media = await GetMediaDetailUseCase(repository).call(response);
    if (media is ResponseFailed) {
      emit(InfoAndWatchCompletedWithError(media.error!));
    } else {
      emit(InfoAndWatchCompletedWithData(media.data!));
    }
  }
}
