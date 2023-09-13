import 'package:meiyou/core/usecases_container/cache_repository_usecase_container.dart';
import 'package:meiyou/core/usecases_container/meta_provider_repository_container.dart';
import 'package:meiyou/domain/entities/media_details.dart';
import 'package:meiyou/domain/repositories/cache_repository.dart';
import 'package:meiyou/presentation/pages/info_watch/state/source_dropdown_bloc/bloc/source_drop_down_bloc.dart';

import 'initialise_view.dart';
import 'initialise_watch_view.dart';

enum InitaliseViewType { watchview }

class InitializationViewParams {
  final InitaliseViewType type;
  final MediaDetailsEntity media;
  final CacheRespository cacheRespository;
  final MetaProviderRepositoryContainer metaProviderRepositoryContainer;
  final SourceDropDownBloc sourceDropDownBloc;

  InitializationViewParams(
      {required this.type,
      required this.media,
      required this.cacheRespository,
      required this.metaProviderRepositoryContainer,
      required this.sourceDropDownBloc});
}

InitialiseView getViewFromType(InitializationViewParams params) {
  switch (params.type) {
    case InitaliseViewType.watchview:
      return InitiliseWatchView(
        media: params.media,
        cacheRespository: params.cacheRespository,
        metaProviderRepositoryContainer: params.metaProviderRepositoryContainer,
        sourceDropDownBloc: params.sourceDropDownBloc,
      );
    default:
      throw 'No Such View Available';
  }
}
