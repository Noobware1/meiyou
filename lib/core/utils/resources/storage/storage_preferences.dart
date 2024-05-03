import 'package:injecktor/injecktor.dart';
import 'package:meiyou_extensions_lib/preference.dart';

class StoragePreferences {
  static const NOTSET = '_NotSet_';

  final PreferenceStore _store;

  StoragePreferences(PreferenceStore? store)
      : _store = store ?? InjectKtor.get<PreferenceStore>();

  Preference<String> baseStorageDirectory() =>
      _store.getString(Preference.appStateKey('storage_dir'), NOTSET);
}
