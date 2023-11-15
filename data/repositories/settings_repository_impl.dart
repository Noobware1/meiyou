import 'package:meiyou/core/resources/prefrences.dart';
import 'package:meiyou/data/models/apperance_settings.dart';
import 'package:meiyou/data/models/general_settings.dart';
import 'package:meiyou/data/models/providers_settings.dart';
import 'package:meiyou/presentation/widgets/theme/bloc/theme_bloc.dart';

class SettingsRepositoryImpl {
  final String settingsPath;

  SettingsRepositoryImpl(this.settingsPath);






  Future<void> updateGeneralSettings(GeneralSettings settings) async {
    await saveData(
        savePath: '$settingsPath/providers.json', data: settings.encode);
  }

  Future<void> updateProvidersSettings(ProvidersSettings settings) async {
    await saveData(
        savePath: '$settingsPath/providers.json', data: settings.encode);
  }

  Future<void> updateApperanceSettings(ApperanceSettings settings) async {
    await saveData(
        savePath: '$settingsPath/apperance.json', data: settings.encode);
  }
}
