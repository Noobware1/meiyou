import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:meiyou/core/injection/modules/injection_module.dart';
import 'package:meiyou/shared/data/repositories/source_repository_impl.dart';
import 'package:meiyou/shared/domain/repositories/source_repository.dart';
import 'package:meiyou/shared/domain/usecases/source_repository_usecases/get_enabled_intalled_sources.dart';
import 'package:meiyou/shared/domain/usecases/source_repository_usecases/get_full_home_page_usecase.dart';
import 'package:meiyou/shared/domain/usecases/source_repository_usecases/get_home_page_usecase.dart';
import 'package:meiyou/shared/domain/usecases/source_repository_usecases/get_media_details_usecase.dart';
import 'package:meiyou/shared/domain/usecases/source_repository_usecases/get_media_links_usecase.dart';
import 'package:meiyou/shared/domain/usecases/source_repository_usecases/get_media_usecase.dart';
import 'package:meiyou/shared/domain/usecases/source_repository_usecases/get_search_page_usecase.dart';

class DomainModule extends InjectModule {
  @override
  FutureOr<void> call(GetIt getIt) {
    getIt.registerLazySingleton<SourceRepository>(() => SourceRepositoryImpl(
        preferences: getIt(), manager: getIt(), extensionManager: getIt()));

    getIt.registerFactory(() => getEnabledSourcesUseCase(getIt()));

    getIt.registerFactory(() => GetFulHomePageUseCase(getIt()));

    getIt.registerFactory(() => GetHomePageUseCase(getIt()));

    getIt.registerFactory(() => GetMediaUseCase(getIt()));

    getIt.registerFactory(() => GetMediaDetailsUseCase(getIt()));
    getIt.registerFactory(() => GetMediaLinksUseCase(getIt()));

    getIt.registerFactory(() => GetSearchPageUseCase(getIt()));
  }
}
