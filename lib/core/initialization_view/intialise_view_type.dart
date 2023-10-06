
import 'package:meiyou/core/resources/paths.dart';
import 'package:meiyou/core/resources/providers/base_provider.dart';
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
  final BaseProvider defaultProvider;
  final AppDirectories appDirectories;
  InitializationViewParams(
      {required this.type,
      required this.media,
      required this.appDirectories,
      required this.cacheRespository,
      required this.metaProviderRepositoryContainer,
      required this.defaultProvider});
}

InitialiseView getViewFromType(InitializationViewParams params) {
  switch (params.type) {
    case InitaliseViewType.watchview:
      return InitiliseWatchView(
        media: params.media,
        appDirectories: params.appDirectories,
        cacheRespository: params.cacheRespository,
        metaProviderRepositoryContainer: params.metaProviderRepositoryContainer,
        sourceDropDownBloc: SourceDropDownBloc(params.defaultProvider)
          ..add(SourceDropDownOnSelected(provider: params.defaultProvider)),
      );
    default:
      throw 'No Such View Available';
  }
}
