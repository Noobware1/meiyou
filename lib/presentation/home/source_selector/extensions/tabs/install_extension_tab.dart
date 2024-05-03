import 'package:flutter/material.dart';
import 'package:injecktor/injecktor.dart';

import 'package:meiyou/core/utils/resources/flow.dart';
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

class InstalledExtensionTab extends StatelessWidget
    implements ExtensionTab<InstalledSource> {
  final OnSourceSelected onSourceSelected;
  final ExtensionType type;
  final ScrollController? scrollController;
  const InstalledExtensionTab({
    super.key,
    required this.type,
    this.scrollController,
    required this.onSourceSelected,
  });

  @override
  Widget build(BuildContext context) {
    return StateFlowBuilder(
        flow: GetInstalledSources(InjectKtor.get()).flow(type),
        builder: (context, value) {
          return ListView.builder(
              controller: scrollController,
              itemCount: value.keys.length,
              itemBuilder: (context, index) =>
                  itemBuilder(context, index, value));
        });
  }

  @override
  Widget itemBuilder(BuildContext context, int index, InstalledSources state) {
    final entry = state.entries.get(index);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children(entry),
    );
  }

  @override
  List<Widget> children(MapEntry<String, List<InstalledSource>> entry) {
    return [
      header(entry.key),
      ...entry.value.map(extensionItem),
    ];
  }

  @override
  Widget header(String language) {
    return Padding(
      padding: ExtensionTab.headerPadding,
      child: Text(language, style: ExtensionTab.titleTextStyle()),
    );
  }

  Widget extensionItem(InstalledSource source) {
    return _InstalledSourceTitle(source: source, onPressed: onSourceSelected);
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
  Widget icon() {
    return ImageHolderMemory(height: 50, width: 50, bytes: source.icon);
  }

  @override
  void onPressed() => _onPressed(source);

  @override
  Widget subtitle() {
    return Text(
      LocaleHelper.getSourceDisplayName(source.lang),
      style: subtitleTextStyle(),
    );
  }

  @override
  Widget title() {
    return Text(
      source.name,
      style: titleTextStyle(),
    );
  }
}
