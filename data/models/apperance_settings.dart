import 'dart:convert';

import 'package:meiyou/domain/entities/apperance_settings.dart';

class ApperanceSettings extends ApperanceSettingsEntity {
  const ApperanceSettings(
      {required super.theme,
      required super.themeMode,
      required super.isAmoledEnabled});

  Map<String, dynamic> toJson() {
    return {
      'theme': theme,
      'mode': themeMode,
      'isAmoled': isAmoledEnabled,
    };
  }

  String get encode => json.encode(toJson());

  factory ApperanceSettings.decode(String encoded) =>
      ApperanceSettings.fromJson(json.decode(encoded));

  factory ApperanceSettings.fromJson(Map json) {
    return ApperanceSettings(
        theme: json['theme'],
        themeMode: json['mode'],
        isAmoledEnabled: json['isAmoled']);
  }
}
