import 'package:flutter/foundation.dart';
import 'package:injecktor/injecktor.dart';

import 'package:meiyou/core/utils/resources/modules/base_preferences.dart';
import 'package:meiyou/domain/source/source_preferences.dart';
import 'package:meiyou_extensions_lib/network.dart';
import 'package:meiyou_extensions_lib/preference.dart';
import 'package:meiyou/core/utils/resources/modules/injecktor_module.dart';
import 'package:meiyou/core/utils/resources/preference/preference_store_impl.dart';
import 'package:meiyou/core/utils/resources/storage/storage_preferences.dart';

class PreferenceModule extends InjecktorModule {
  @override
  void inject() {
    InjectKtor.addLazySingleton<PreferenceStore>(() => PreferenceStoreImpl());

    InjectKtor.addLazySingleton(
        () => BasePreferences(InjectKtor.get<PreferenceStore>()));

    InjectKtor.addLazySingleton(() =>
        NetworkPreferences(InjectKtor.get<PreferenceStore>(), !kDebugMode));

    InjectKtor.addLazySingleton(
        () => StoragePreferences(InjectKtor.get<PreferenceStore>()));

    InjectKtor.addLazySingleton(
        () => SourcePreferences(InjectKtor.get<PreferenceStore>()));
  }
}
