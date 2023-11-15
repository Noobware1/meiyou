import 'dart:convert';

import 'package:meiyou/domain/entities/general_settings.dart';

class GeneralSettings extends GeneralSettingsEntity {
  const GeneralSettings(
      {required super.selectedResponsesCache, required super.responesCache});

  String get encode => json.encode(toJson());

  factory GeneralSettings.decode(String encoded) =>
      GeneralSettings.fromJson(json.decode(encoded));

  Map<String, dynamic> toJson() {
    return {
      'cache': {'saved_res': selectedResponsesCache, 'res': responesCache}
    };
  }

  factory GeneralSettings.fromJson(Map<String, dynamic> json) {
    final cache = json['cache'];
    return GeneralSettings(
        selectedResponsesCache: cache['saved_res'],
        responesCache: cache['res']);
  }
}
