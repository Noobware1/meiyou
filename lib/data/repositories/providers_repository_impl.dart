import 'dart:convert';

import 'package:meiyou/core/resources/media_type.dart';
import 'package:meiyou/core/resources/prefrences.dart';
import 'package:meiyou/core/resources/provider_type.dart';
import 'package:meiyou/core/resources/providers/base_provider.dart';
import 'package:meiyou/core/utils/extenstions/iterable.dart';
import 'package:meiyou/data/data_source/providers/providers.dart';
import 'package:meiyou/domain/repositories/get_providers_list.dart';

class ProvidersRepositoryImpl implements ProvidersRepository {
  @override
  Map<String, BaseProvider> getProviderList(String mediaType) {
    final ProviderType type;
    if (mediaType == MediaType.movie || mediaType == MediaType.tvShow) {
      type = ProviderType.movie;
    } else {
      type = ProviderType.anime;
    }
    return _getProviderListFromProviderType(type);
  }

  Map<String, BaseProvider> _getProviderListFromProviderType(
      ProviderType providerType) {
    switch (providerType) {
      case ProviderType.anime:
        return AnimeProviders().providers;
      case ProviderType.movie:
        return {...MovieProviders().providers, ...TMDBProviders().providers};

      default:
        return throw 'Unknown ProviderType demanded';
    }
  }

  @override
  Future<void> saveDefaultProvider(BaseProvider provider, String directeory,
      [void Function()? callback]) async {
    await saveData(
        savePath: _getDefaultProviderPath(directeory, provider.providerType),
        data: DefaultProvider(provider.providerType, provider.name).encode,
        onCompleted: () => callback?.call());

    print('saved provider ${provider.name}');
  }

  @override
  Future<BaseProvider?> getDefaultProvider(
    ProviderType type,
    String directeory,
  ) async {
    // final file = File(_getDefaultProviderPath(directeory, type));
    // final name = DefaultProvider.decode(await file.readAsString()).providerName;
    // if (file.existsSync()) {
    // }
    final name = (await loadData(
      savePath: _getDefaultProviderPath(directeory, type),
      transFormer: DefaultProvider.fromJson,
    ))
        ?.providerName;
    if (name != null) {
      return _getProviderListFromProviderType(type)
          .values
          .tryfirstWhere((e) => e.name == name);
    }
    print('file doesn\'t exist');

    return null;
  }

  String _getDefaultProviderPath(String directory, ProviderType type) =>
      '$directory\\${(type == ProviderType.tmdb ? ProviderType.movie : type).toString().toLowerCase()}_default_provider.json';
}

class DefaultProvider {
  final ProviderType providerType;
  final String providerName;

  const DefaultProvider(this.providerType, this.providerName);

  String get encode => jsonEncode(toJson());

  static DefaultProvider decode(String encoded) =>
      DefaultProvider.fromJson(jsonDecode(encoded));

  Map<int, String> toJson() {
    return {providerType.index: providerName};
  }

  factory DefaultProvider.fromMapEntry(MapEntry json) {
    return DefaultProvider(ProviderType.values[json.key], json.value);
  }

  factory DefaultProvider.fromJson(dynamic json) {
    return DefaultProvider.fromMapEntry(Map.from(json).entries.first);
  }
}
