import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:meiyou/core/injection/modules/injection_module.dart';
import 'package:meiyou/shared/data/data_sources/preference/preference_store_impl.dart';
import 'package:meiyou/shared/data/data_sources/preferences/source_preferences.dart';
import 'package:meiyou/shared/data/data_sources/preferences/storage_preferences.dart';
import 'package:meiyou_extensions_lib/network.dart';
import 'package:meiyou_extensions_lib/preference.dart';

class PreferenceModule implements InjectModule {
  @override
  FutureOr<void> call(GetIt getIt) {
    getIt.registerLazySingleton<PreferenceStore>(
      () => PreferenceStoreImpl(),
    );

    getIt.registerLazySingleton(
      () => SourcePreferences(getIt()),
    );

    getIt.registerLazySingleton(
      () => NetworkPreferences(getIt(), kDebugMode),
    );

    getIt.registerLazySingleton(() => StoragePreferences(getIt()));
  }
}
