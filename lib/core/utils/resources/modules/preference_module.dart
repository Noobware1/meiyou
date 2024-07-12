import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

import 'package:meiyou/core/utils/resources/get_it/get_it.dart';

import 'package:meiyou/core/utils/resources/modules/base_preferences.dart';
import 'package:meiyou/domain/library/library_preferences.dart';
import 'package:meiyou/domain/source/source_preferences.dart';
import 'package:meiyou/domain/ui/ui_preferences.dart';
import 'package:meiyou_extensions_lib/network.dart';
import 'package:meiyou_extensions_lib/preference.dart';

import 'package:meiyou/core/utils/resources/preference/preference_store_impl.dart';
import 'package:meiyou/core/utils/resources/storage/storage_preferences.dart';

class PreferenceModule extends GetItModule {
  @override
  void register() {
    
    
    getIt.registerLazySingleton<PreferenceStore>(() => PreferenceStoreImpl());

    getIt.registerLazySingleton(() => BasePreferences(getIt.get()));

    getIt.registerLazySingleton(
        () => NetworkPreferences(getIt.get(), !kDebugMode));

    getIt.registerLazySingleton(() => StoragePreferences(getIt.get()));

    getIt.registerLazySingleton(() => SourcePreferences(getIt.get()));

    getIt.registerLazySingleton(() => LibraryPreferences(getIt.get()));

    getIt.registerLazySingleton(() => UiPreferences(getIt.get()));
  }
}
