// ignore_for_file: unused_import, constant_identifier_names

import 'package:meiyou/core/utils/resources/get_it/get_it.dart';
import 'package:meiyou/core/utils/resources/logger.dart';
import 'dart:convert';

import 'package:meiyou/core/utils/resources/network.dart';
import 'package:meiyou/domain/source/source_preferences.dart';
import 'package:meiyou/extension/models/entension_type.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:meiyou_extensions_lib/network.dart';
import 'package:meiyou_extensions_lib/okhttp_extensions.dart';
import 'package:nice_dart/nice_dart.dart';

class ExtensionApi {
  final SourcePreferences _sourcePreferences = getIt.get();

  static const OFFICAL_REPO =
      "https://raw.githubusercontent.com/Noobware1/meiyou-extensions/repo";

  final NetworkHelper networkSevice = getIt.get();

  Future<List<AvailableExtension>> findExtensions(ExtensionType extensionType) {
    return getExtensions(OFFICAL_REPO, extensionType).then((value) async {
      final extensions = <AvailableExtension>[];
      extensions.addAll(value);

      final repos = _sourcePreferences.extensionsRepos().get();

      for (var repo in repos) {
        extensions.addAll(await getExtensions(repo, extensionType));
      }

      return extensions;
    });
  }

  Future<List<AvailableExtension>> getExtensions(
      String repoBaseUrl, ExtensionType extensionType) async {
    try {
      if (extensionType == ExtensionType.Video) {
        return run(() {
          final json = jsonDecode('''
            [{"name":"GogoAnime","pkg":"gogoanime","plugin":"gogoanime-v1.0.0.plugin","version":"1.0.0","lang":"en","nsfw":0,"sources":[{"id":7055547649318749672,"name":"GogoAnime","lang":"en","baseUrl":"https://anitaku.to"}]},{"name":"HiAnime","pkg":"hianime","plugin":"hianime-v1.0.0.plugin","version":"1.0.0","lang":"en","nsfw":0,"sources":[{"id":8875918538894472758,"name":"HiAnime","lang":"en","baseUrl":"https://hianime.to"}]},{"name":"KickAssAnime","pkg":"kickassanime","plugin":"kickassanime-v1.0.0.plugin","version":"1.0.0","lang":"en","nsfw":0,"sources":[{"id":2081771513481539599,"name":"KickAssAnime","lang":"en","baseUrl":"https://kickassanimes.io"}]}]
            ''');
          return (json as List).mapList(
              (json) => extensionFromJson(json, '$repoBaseUrl/$extensionType'));
        });
      } else {
        return [];
      }
      // return await networkSevice.client
      //     .newCall(GET("$repoBaseUrl/$extensionType/index.min.json"))
      //     .execute()
      //     .then((response) {
      //   print(response.body.string);
      //   return response.body.json((json) => (json as List).mapList(
      //       (json) => extensionFromJson(json, '$repoBaseUrl/$extensionType')));
      // });
    } catch (e, s) {
      logRat.logcatch(LogPriority.error, e, s);
      return [];
    }
  }

  AvailableExtension extensionFromJson(dynamic json, String repoUrl) {
    return AvailableExtension(
      name: json['name'],
      pkgName: json['pkg'],
      versionName: json['version'],
      lang: json['lang'] ?? '',
      isNsfw: json['nsfw'] == 1,
      sources: ((json['sources'] as List?)
          ?.mapList((e) => AvailableSource.fromJson(e))).orEmpty(),
      pluginName: json['plugin'],
      iconUrl: '$repoUrl/icon/${json['pkg']}.png',
      repoUrl: repoUrl,
    );
  }

  String getPluginUrl(AvailableExtension extension) {
    return "${extension.repoUrl}/plugin/${extension.pluginName}";
  }
}
