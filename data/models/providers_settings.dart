import 'dart:convert';

import 'package:meiyou/core/utils/extenstions/iterable.dart';
import 'package:meiyou/data/repositories/providers_repository_impl.dart';
import 'package:meiyou/domain/entities/providers_settings.dart';

class ProvidersSettings extends ProvidersSettingsEntity {
  const ProvidersSettings(
      {required super.deaultMovieProvider,
      required super.defaultAnimeProvider});

  Map<String, dynamic> toJson() {
    return {
      'def_providers': Map.fromEntries([
        deaultMovieProvider.toJson().entries.first,
        defaultAnimeProvider.toJson().entries.first,
      ])
    };
  }

  
  String get encode => json.encode(toJson());

  factory ProvidersSettings.decode(String encoded) =>
      ProvidersSettings.fromJson(json.decode(encoded));


  factory ProvidersSettings.fromJson(Map json) {
    final defProviders = (json['def_providers'] as Map)
        .entries
        .mapAsList((it) => DefaultProvider.fromJson(it));
    return ProvidersSettings(
        deaultMovieProvider: defProviders[0],
        defaultAnimeProvider: defProviders[1]);
  }
}
