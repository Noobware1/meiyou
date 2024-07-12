import 'package:flutter/material.dart';

import 'package:meiyou/core/utils/resources/flow.dart';
import 'package:meiyou/core/utils/resources/get_it/get_it.dart';
import 'package:meiyou/core/utils/resources/locale_helper.dart';
import 'package:meiyou/extension/models/entension_type.dart';
import 'package:meiyou/domain/models/source.dart';
import 'package:meiyou/domain/source/get_installed_sources.dart';
import 'package:meiyou/presentation/core/image_holder.dart';
import 'package:meiyou/presentation/home/source_selector/extensions/tabs/extension_tab.dart';
import 'package:meiyou/presentation/home/source_selector/extensions/widgets/extension_tile.dart';
import 'package:nice_dart/nice_dart.dart';

typedef InstalledSources = Map<String, List<InstalledSource>>;
typedef OnSourceSelected = void Function(InstalledSource);

class InstalledExtensionTab extends ExtensionTab<InstalledSource> {
  final OnSourceSelected onSourceSelected;
  final ExtensionType type;
  const InstalledExtensionTab({
    super.key,
    required this.type,
    required this.onSourceSelected,
  });

  @override
  StateFlow<Map<String, List<InstalledSource>>> getFlow() {
    return GetInstalledSources(getIt.get()).flow(type);
  }

  @override
  Widget itemBuilder(
      BuildContext context, String language, InstalledSource value) {
    return _InstalledSourceTitle(source: value, onPressed: onSourceSelected);
  }
}

class _InstalledSourceTitle extends ExtensionTile {
  final InstalledSource source;
  final OnSourceSelected _onPressed;
  const _InstalledSourceTitle({
    required this.source,
    super.key,
    required OnSourceSelected onPressed,
  }) : _onPressed = onPressed;

  @override
  Widget button() {
    return IconButton(
      onPressed: () {},
      icon: const Icon(Icons.settings_outlined),
    );
  }

  @override
  Widget icon({
    required Size size,
  }) {
    return ImageHolderMemory(height: 50, width: 50, bytes: source.icon);
  }

  @override
  void onPressed() => _onPressed(source);

  @override
  Widget subtitle({
    required TextStyle subtitleTextStyle,
  }) {
    return Text(
      LocaleHelper.getSourceDisplayName(source.lang),
      style: subtitleTextStyle,
    );
  }

  @override
  Widget title({
    required TextStyle titleTextStyle,
  }) {
    return Text(
      source.name,
      style: titleTextStyle,
    );
  }
}
