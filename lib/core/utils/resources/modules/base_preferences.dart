import 'package:meiyou_extensions_lib/preference.dart';

class BasePreferences {
  final PreferenceStore _preferenceStore;

  BasePreferences(this._preferenceStore);

  Preference<bool> downloadedOnly() => _preferenceStore.getBool(
        Preference.appStateKey("pref_downloaded_only"),
        false,
      );

  Preference<bool> incognitoMode() => _preferenceStore.getBool(
        Preference.appStateKey("incognito_mode"),
        false,
      );

  Preference<bool> shownOnboardingFlow() => _preferenceStore.getBool(
        Preference.appStateKey("onboarding_complete"),
        false,
      );
}
