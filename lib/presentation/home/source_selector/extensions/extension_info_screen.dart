import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:meiyou/core/constants/font_size.dart';
import 'package:meiyou/core/utils/extensions/context.dart';
import 'package:meiyou/core/utils/resources/get_it/get_it.dart';
import 'package:meiyou/core/utils/resources/locale_helper.dart';
import 'package:meiyou/core/utils/resources/toast.dart';
import 'package:meiyou/domain/source/source_preferences.dart';
import 'package:meiyou/extension/extension_manager.dart';
import 'package:meiyou/extension/models/entension_type.dart';
import 'package:meiyou/extension/utils/extension_folder_provider.dart';
import 'package:meiyou/presentation/core/dilog_box/alert_dialog_box.dart';
import 'package:meiyou/presentation/core/image_holder.dart';
import 'package:meiyou/presentation/core/space.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:nice_dart/nice_dart.dart';
import 'package:path/path.dart';

class ExtensionInfoScreen extends StatefulWidget {
  final InstalledExtension extension;
  final ExtensionType type;
  const ExtensionInfoScreen(
      {super.key, required this.extension, required this.type});

  @override
  State<ExtensionInfoScreen> createState() => _ExtensionInfoScreenState();
}

class _ExtensionInfoScreenState extends State<ExtensionInfoScreen> {
  late final SourcePreferences preferences;
  late final ExtensionManager extensionManager;

  @override
  void initState() {
    super.initState();
    preferences = getIt.get<SourcePreferences>();
    extensionManager = getIt.get<ExtensionManager>();
  }

  @override
  Widget build(BuildContext context) {
    final (vernLangTitleStyle, vernLangSubtitleStyle) = context.theme.let(
      (theme) => (
        const TextStyle(
            fontWeight: FontWeight.w500, fontSize: MobileFontSize.semiLarge),
        TextStyle(
          color: context.theme.colorScheme.onSurface.withOpacity(0.5),
          fontSize: MobileFontSize.semiMedium,
          fontWeight: FontWeight.w400,
        )
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Extension Info'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const VerticalSpace(20),
          Align(
            alignment: Alignment.center,
            child: ImageHolderMemory(
              height: 120,
              width: 120,
              bytes: widget.extension.icon,
            ),
          ),
          const VerticalSpace(10),
          Text(
            widget.extension.name,
            style: context.theme.textTheme.titleLarge,
          ),
          const VerticalSpace(5),
          Text(
            'pkg:${widget.extension.pkgName}',
            style: const TextStyle(
              fontSize: MobileFontSize.small,
              fontWeight: FontWeight.w400,
            ),
          ),
          const VerticalSpace(20),
          versionAndLanguage(
              titleTextStyle: vernLangTitleStyle,
              subtitleTextStyle: vernLangSubtitleStyle),
          const VerticalSpace(20),
          uninstallAndInfo(
            context,
            onPressedUnistall: () {
              uninstallExtension(context);
            },
            onPressedInfo: () {
              showInfo(context);
            },
          ),
          const VerticalSpace(10),
          Divider(
            color: context.theme.colorScheme.onSurface.withOpacity(0.5),
          ),
          Expanded(child: buildSources(context))
        ],
      ),
    );
  }

  void toggleDisableSource(String sourceId, {bool? isEnabled}) {
    final disabled = preferences.disabledSourcesForType(widget.type).get();
    void set(bool isEnabled) {
      if (isEnabled) {
        disabled.add(sourceId);
      } else {
        disabled.remove(sourceId);
      }
      preferences.disabledSourcesForType(widget.type).set(disabled);
    }

    set(isEnabled ?? !disabled.contains(sourceId));
  }

  void uninstallExtension(BuildContext context) {
    final isUninstalled =
        extensionManager.uninstallExtension(widget.type, widget.extension);
    if (isUninstalled) {
      context.pop();
      makeToast('Uninstalled ${widget.extension.name}');
    }
  }

  void showInfo(BuildContext context) {
    final pair = ExtensionsFolderProvider()
        .getFolderFromType(
          ExtensionType.Video,
        )
        .listSync()
        .firstWhereOrNull(
          (file) => basename(file.path) == widget.extension.pkgName,
        )
        ?.let((it) => Pair(it, it.statSync()));

    showAdaptiveDialog(
      context: context,
      builder: (context) {
        return CustomAlertDialog(
          title: widget.extension.name,
          content: pair == null
              ? const Text('Failed to load extension information')
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Version: ${widget.extension.versionName}'),
                    const VerticalSpace(10),
                    Text('Package name: ${widget.extension.pkgName}'),
                    const VerticalSpace(10),
                    Text('Path: ${pair.first.path}'),
                    const VerticalSpace(10),
                    Text('Size: ${pair.second.size}kb'),
                    const VerticalSpace(10),
                    Text('Accessed at: ${formatDate(pair.second.accessed)}'),
                  ],
                ),
        );
      },
    );
  }

  Widget buildSources(BuildContext context) {
    final sourceIds = widget.extension.sources.map((e) => '${e.id}').toList();
    return StreamBuilder(
        initialData: preferences
            .disabledSourcesForType(widget.type)
            .get()
            .where((element) => sourceIds.contains(element)),
        stream: preferences
            .disabledSourcesForType(widget.type)
            .changes()
            .asyncMap((event) =>
                event.where((element) => sourceIds.contains(element))),
        builder: (context, snapshot) {
          return ListView(
            children: widget.extension.sources.mapListIndexed((index, e) {
              final isEnabled =
                  !(snapshot.data ?? []).contains(sourceIds[index]);
              print(isEnabled);
              return ListTile(
                onTap: () {
                  toggleDisableSource(sourceIds[index], isEnabled: isEnabled);
                },
                title: Text(
                  LocaleHelper.getLocalizedDisplayName(e.lang),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      color: context.theme.colorScheme.onSurface,
                      onPressed: () {},
                      icon: const Icon(Icons.settings_outlined),
                    ),
                    Switch.adaptive(
                        value: isEnabled,
                        onChanged: (val) {
                          toggleDisableSource(sourceIds[index]);
                        })
                  ],
                ),
              );
            }),
          );
        });
  }

  Widget uninstallAndInfo(
    BuildContext context, {
    required VoidCallback onPressedUnistall,
    required VoidCallback onPressedInfo,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
                onPressed: onPressedUnistall, child: const Text('Uninstall')),
          ),
          const HorizontalSpace(15),
          Expanded(
            child: FilledButton(
              onPressed: onPressedInfo,
              child: const Text(
                'Extension Info',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget versionAndLanguage(
      {required TextStyle titleTextStyle,
      required TextStyle subtitleTextStyle}) {
    Widget makeTile(String title, String subtitle) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: titleTextStyle,
          ),
          const VerticalSpace(2),
          Text(
            subtitle,
            style: subtitleTextStyle,
          ),
        ],
      );
    }

    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Padding(
          padding: const EdgeInsets.only(left: 20),
          child: makeTile(widget.extension.versionName, 'Version')),
      Container(
        height: 20,
        width: 1,
        color: subtitleTextStyle.color,
      ),
      Padding(
          padding: const EdgeInsets.only(right: 20),
          child: makeTile(
              LocaleHelper.getLocalizedDisplayName(widget.extension.lang),
              'Language')),
    ]);
  }

  String formatDate(DateTime date) {
    return DateFormat('d MMM yyyy').format(date);
  }
}
