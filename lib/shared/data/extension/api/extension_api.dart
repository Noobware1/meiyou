// ignore_for_file: unused_import, constant_identifier_names

import 'package:logging/logging.dart';
import 'package:meiyou/core/utils/exceptions/no_extension_found.dart';
import 'dart:convert';

import 'package:meiyou/shared/data/data_sources/preferences/source_preferences.dart';
import 'package:meiyou/shared/domain/models/extension_category.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:meiyou_extensions_lib/network.dart';
import 'package:meiyou_extensions_lib/okhttp_extensions.dart';
import 'package:nice_dart/nice_dart.dart';

class ExtensionApi {
  ExtensionApi({
    required SourcePreferences sourcePreferences,
    required Logger logger,
    required NetworkHelper network,
  })  : _sourcePreferences = sourcePreferences,
        _network = network,
        _logger = logger;

  final SourcePreferences _sourcePreferences;
  final NetworkHelper _network;
  final Logger _logger;

  static const OFFICAL_REPO =
      "https://raw.githubusercontent.com/Noobware1/meiyou-extensions/repo";

  Future<Result<List<AvailableExtension>>> findExtensions(
      ExtensionCategory extensionCategory) async {
    final extensions = <AvailableExtension>[];
    extensions.addAll(await getExtensions(OFFICAL_REPO, extensionCategory));

    final repos = _sourcePreferences.extensionsRepos().get();

    for (var repo in repos) {
      extensions.addAll(await getExtensions(repo, extensionCategory));
    }
    return extensions.isEmpty
        ? Result.failure(NoExtensionFoundException(extensionCategory))
        : Result.success(extensions);
  }

  Future<List<AvailableExtension>> getExtensions(
      String repoBaseUrl, ExtensionCategory extensionCategory) async {
    try {
      return await _network.client
          .newCall(GET("$repoBaseUrl/${extensionCategory.name}/index.min.json"))
          .execute()
          .then((response) {
        return response.body.json((json) => (json as List).mapList((json) =>
            AvailableExtension.fromJson(json,
                repoUrl: '$repoBaseUrl/${extensionCategory.name}')));
      });
    } catch (e, s) {
      _logger.severe("Failed to get extensions", e, s);
      return [];
    }
  }

  String getPluginUrl(AvailableExtension extension) {
    return "${extension.repoUrl}/plugin/${extension.pluginName}";
  }
}
