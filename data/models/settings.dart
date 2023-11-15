import 'package:meiyou/data/models/providers_settings.dart';
import 'package:meiyou/domain/entities/settings.dart';

import 'apperance_settings.dart';
import 'general_settings.dart';

class Settings extends SettingsEntity {
  @override
  ProvidersSettings get providersSettings =>
      super.providersSettings as ProvidersSettings;

  @override
  GeneralSettings get generalSettings =>
      super.generalSettings as GeneralSettings;

  @override
  ApperanceSettings get apperanceSettings =>
      super.apperanceSettings as ApperanceSettings;

  const Settings(
      {required super.providersSettings,
      required super.generalSettings,
      required super.apperanceSettings});

  Map<String, dynamic> toJson() {
    return {
      'general': generalSettings.toJson(),
      'providers': providersSettings.toJson(),
      'apperance': apperanceSettings.toJson(),
    };
  }

  factory Settings.fromJson(Map json) {
    return Settings(
      providersSettings: ProvidersSettings.fromJson(json['providers']),
      generalSettings: GeneralSettings.fromJson(json['general']),
      apperanceSettings: ApperanceSettings.fromJson(json['apperance']),
    );
  }
}
