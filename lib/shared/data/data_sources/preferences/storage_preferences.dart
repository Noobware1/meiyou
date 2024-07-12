import 'package:meiyou/core/injection/injection.dart';
import 'package:meiyou_extensions_lib/preference.dart';

class StoragePreferences {
  final PreferenceStore _store;

  StoragePreferences(PreferenceStore? store)
      : _store = store ?? getIt.get<PreferenceStore>();

  Preference<String> baseStorageDirectory() =>
      _store.getString(Preference.appStateKey('storage_dir'), "");
}
