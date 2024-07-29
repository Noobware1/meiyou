import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:meiyou/core/injection/modules/injection_module.dart';
import 'package:meiyou/features/home/data/repositories/home_repository_impl.dart';
import 'package:meiyou/features/home/domain/repositories/home_repository.dart';
import 'package:meiyou/features/home/domain/usecases/home_repository_usecases/expand_homepage_usecase.dart';
import 'package:meiyou/shared/data/repositories/media_content_repository_impl.dart';
import 'package:meiyou/shared/data/repositories/media_repository_impl.dart';
import 'package:meiyou/shared/data/repositories/source_repository_impl.dart';
import 'package:meiyou/shared/domain/repositories/media_content_repository.dart';
import 'package:meiyou/shared/domain/repositories/media_repository.dart';
import 'package:meiyou/shared/domain/repositories/source_repository.dart';
import 'package:meiyou/shared/domain/usecases/media_content_repository_usecases/get_content_by_id_usecase.dart';
import 'package:meiyou/shared/domain/usecases/media_content_repository_usecases/get_content_list_by_media_id_as_stream_usecase.dart';
import 'package:meiyou/shared/domain/usecases/media_content_repository_usecases/get_content_list_by_media_id_usecase.dart';
import 'package:meiyou/shared/domain/usecases/media_content_repository_usecases/insert_all_content_usecase.dart';
import 'package:meiyou/shared/domain/usecases/media_content_repository_usecases/insert_content_usecase.dart';
import 'package:meiyou/shared/domain/usecases/media_content_repository_usecases/map_conent_list_usecase.dart';
import 'package:meiyou/shared/domain/usecases/media_content_repository_usecases/update_content_usecase.dart';
import 'package:meiyou/shared/domain/usecases/media_repository_usecases/get_media_by_id_as_stream_usecase.dart';
import 'package:meiyou/shared/domain/usecases/media_repository_usecases/get_media_by_id_usecase.dart';
import 'package:meiyou/shared/domain/usecases/media_repository_usecases/get_media_by_url_and_source_id_usecase.dart';
import 'package:meiyou/shared/domain/usecases/media_repository_usecases/network_media_to_local_usecase.dart';
import 'package:meiyou/shared/domain/usecases/media_repository_usecases/update_media_from_source_usecase.dart';
import 'package:meiyou/shared/domain/usecases/media_repository_usecases/update_media_usecase.dart';
import 'package:meiyou/shared/domain/usecases/source_repository_usecases/get_enabled_intalled_sources.dart';
import 'package:meiyou/shared/domain/usecases/source_repository_usecases/get_full_home_page_usecase.dart';
import 'package:meiyou/shared/domain/usecases/source_repository_usecases/get_home_page_usecase.dart';
import 'package:meiyou/shared/domain/usecases/source_repository_usecases/get_media_asset_usecase.dart';
import 'package:meiyou/shared/domain/usecases/source_repository_usecases/get_media_content_list_usecase.dart';
import 'package:meiyou/shared/domain/usecases/source_repository_usecases/get_media_details_usecase.dart';
import 'package:meiyou/shared/domain/usecases/source_repository_usecases/get_media_link_list_usecase.dart';
import 'package:meiyou/shared/domain/usecases/source_repository_usecases/get_search_page_usecase.dart';

class DomainModule extends InjectModule {
  @override
  FutureOr<void> call(GetIt getIt) {
    getIt.registerLazySingleton<SourceRepository>(() => SourceRepositoryImpl(
        preferences: getIt(), manager: getIt(), extensionManager: getIt()));

    getIt.registerFactory(() => GetEnabledSourcesUseCase(getIt()));

    getIt.registerFactory(() => GetFulHomePageUseCase(getIt()));

    getIt.registerFactory(() => GetHomePageUseCase(getIt()));

    getIt.registerFactory(() => GetSearchPageUseCase(getIt()));

    getIt.registerFactory(() => GetMediaDetailsUseCase(getIt()));

    getIt.registerFactory(() => GetMediaContentListUseCase(getIt()));

    getIt.registerFactory(() => GetMediaLinkListUsecase(getIt()));

    getIt.registerFactory(() => GetMediaAssetUseCase(getIt()));

    getIt.registerLazySingleton<MediaRepository>(
        () => MediaRepositoryImpl(getIt()));

    getIt.registerFactory(() => NetworkMediaToLocalUseCase(getIt()));

    getIt.registerFactory(() => GetMediaByIdUseCase(getIt()));

    getIt.registerFactory(() => GetMediaByIdAsStreamUseCase(getIt()));

    getIt.registerFactory(() => GetMediaByUrlAndSourceIdUseCase(getIt()));

    getIt.registerFactory(() => UpdateMediaUseCase(getIt()));

    getIt.registerFactory(() => UpdateMediaFromSourceUseCase(getIt()));

    getIt.registerLazySingleton<MediaContentRepository>(
        () => MediaContentRepositoryImpl(getIt()));

    getIt.registerFactory(() => GetContentListByMediaIdUseCase(getIt()));

    getIt
        .registerFactory(() => GetContentListByMediaIdAsStreamUseCase(getIt()));

    getIt.registerFactory(() => GetContentByIdUseCase(getIt()));

    getIt.registerFactory(() => MapContentListUseCase(getIt()));

    getIt.registerFactory(() => UpdateContentUseCase(getIt()));

    getIt.registerFactory(() => InsertAllContentUseCase(getIt()));

    getIt.registerFactory(() => InsertContentUseCase(getIt()));

    getIt.registerLazySingleton<HomeRepository>(() => HomeRepositoryImpl());

    getIt.registerFactory(() => ExpandHomepageUseCase(getIt()));
  }
}
