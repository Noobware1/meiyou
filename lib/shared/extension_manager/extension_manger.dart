// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'dart:async';
import 'package:meiyou/shared/domain/models/extension_category.dart';
import 'package:meiyou/shared/domain/models/extension_list.dart';
import 'package:meiyou/shared/domain/models/install_step.dart';
import 'package:meiyou/core/utils/stream_utils/state_stream.dart';
import 'package:meiyou_extensions_lib/models.dart';

abstract class ExtensionManager {
  bool get isInitialized;

  StateStream<ExtensionList> getExtensionList(ExtensionCategory category);

  StateStream<List<AvailableExtension>> getAvailableExtensionsStream(
      ExtensionCategory category);

  StateStream<List<InstalledExtension>> getInstalledExtensionsStream(
      ExtensionCategory category);

  Stream<InstallStep> installExtension(
      ExtensionCategory category, AvailableExtension extension);

  Stream<InstallStep> updateExtension(
      ExtensionCategory category, InstalledExtension extension);

  void cancelDownload(ExtensionCategory category, Extension extension);

  Future<bool> uninstallExtension(
      ExtensionCategory category, InstalledExtension extension);

  InstalledExtension? getInstalledExtension(int id, ExtensionCategory category);

  AvailableExtension? getAvailableExtensionForSource(
      int id, ExtensionCategory category);

  Future<void> findAvailableExtensions(ExtensionCategory extensionCategory);
}
