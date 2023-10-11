import 'package:equatable/equatable.dart';
import 'package:meiyou/domain/entities/apperance_settings.dart';
import 'package:meiyou/domain/entities/general_settings.dart';
import 'package:meiyou/domain/entities/providers_settings.dart';

class SettingsEntity extends Equatable {
  final ProvidersSettingsEntity providersSettings;
  final GeneralSettingsEntity generalSettings;
  final ApperanceSettingsEntity apperanceSettings;

  const SettingsEntity(
      {required this.providersSettings,
      required this.generalSettings,
      required this.apperanceSettings});

  @override
  List<Object?> get props =>
      [providersSettings, apperanceSettings, generalSettings];
}
