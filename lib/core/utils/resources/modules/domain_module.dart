import 'package:get_it/get_it.dart';

import 'package:meiyou/core/utils/resources/get_it/get_it.dart';
import 'package:meiyou/data/repositories/source_repository_impl.dart';
import 'package:meiyou/domain/category/repositories/category_repository.dart';
import 'package:meiyou/domain/repositories/history_repository.dart';
import 'package:meiyou/domain/library/library_repository.dart';
import 'package:meiyou/domain/repositories/player_repository.dart';
import 'package:meiyou/domain/repositories/source_repository.dart';

class DomainModule extends GetItModule {
  @override
  void register() {
    getIt.registerFactory<SourceRepository>(() => SourceRepositoryImpl());

    getIt.registerLazySingleton(() => PlayerRepository());

    getIt.registerFactory(() => LibraryRepository(getIt.get(), getIt.get()));

    getIt.registerFactory(() => HistoryRepository(getIt.get()));

    getIt.registerFactory(() => CategoryRepository(getIt.get(), getIt.get()));
  }
}
