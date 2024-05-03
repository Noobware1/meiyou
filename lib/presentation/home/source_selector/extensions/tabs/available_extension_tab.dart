import 'package:flutter/material.dart';
import 'package:injecktor/injecktor.dart';

import 'package:meiyou/core/utils/extensions/string_buffer.dart';

import 'package:meiyou/core/utils/resources/flow.dart';
import 'package:meiyou/extension/extension_manager.dart';
import 'package:meiyou/extension/models/entension_type.dart';
import 'package:meiyou/extension/models/install_step.dart';
import 'package:meiyou/domain/source/get_language_with_extensions.dart';
import 'package:meiyou/presentation/core/image_holder.dart';
import 'package:meiyou/presentation/home/source_selector/extensions/tabs/extension_tab.dart';
import 'package:meiyou/presentation/home/source_selector/extensions/widgets/extension_tile.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:nice_dart/nice_dart.dart';

typedef LanguageWithAvailableExtensions = Map<String, List<AvailableExtension>>;

class AvailableExtensionTab extends StatelessWidget
    implements ExtensionTab<AvailableExtension> {
  final ExtensionType type;
  final ScrollController? scrollController;
  const AvailableExtensionTab(
      {super.key, required this.type, this.scrollController});

  @override
  Widget build(BuildContext context) {
    return StateFlowBuilder(
        flow: GetLanguageWithAvailableExtensions(InjectKtor.get()).flow(type),
        builder: (context, value) {
          return ListView.builder(
              controller: scrollController,
              itemCount: value.keys.length,
              itemBuilder: (context, index) =>
                  itemBuilder(context, index, value));
        });
  }

  @override
  Widget itemBuilder(
      BuildContext context, int index, LanguageWithAvailableExtensions state) {
    final entry = state.entries.get(index);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children(entry),
    );
  }

  @override
  List<Widget> children(MapEntry<String, List<AvailableExtension>> entry) {
    return [
      header(entry.key),
      ...entry.value.map(extensionItem),
    ];
  }

  @override
  Widget header(String language) {
    return Padding(
        padding: ExtensionTab.headerPadding,
        child: Text(language, style: ExtensionTab.titleTextStyle()));
  }

  Widget extensionItem(AvailableExtension extension) {
    return _ExtensionItem(
      extension: extension,
      type: type,
      needUpdate: false,
    );
  }
}

class _ExtensionItem extends StatefulWidget {
  final ExtensionType type;
  final bool needUpdate;
  final AvailableExtension extension;

  const _ExtensionItem({
    super.key,
    required this.extension,
    required this.type,
    required this.needUpdate,
  });

  @override
  State<_ExtensionItem> createState() => _ExtensionItemState();
}

class _ExtensionItemState extends State<_ExtensionItem> {
  StateFlow<InstallStep> flow = StateFlow(InstallStep.Idle);

  @override
  Widget build(BuildContext context) {
    return StateFlowBuilder<InstallStep>(
      flow: flow,
      builder: (context, value) {
        return _AvailableExtensionTile(
          step: value,
          extension: widget.extension,
          onPressed: onPressed,
        );
      },
    );
  }

  void onPressed() {
    if (!flow.state.isCompleted) {
      flow.close();
    } else {
      setState(() {
        flow = StateFlow.stream(
          flow.state,
          InjectKtor.get<ExtensionManager>()
              .installExtension(widget.type, widget.extension),
          onDone: () {
            flow.update(InstallStep.Idle);
            flow.close();
          },
        );
      });
    }
  }
}

class _AvailableExtensionTile extends ExtensionTile {
  final InstallStep step;
  final AvailableExtension extension;
  final VoidCallback _onPressed;

  const _AvailableExtensionTile({
    super.key,
    required this.step,
    required this.extension,
    required VoidCallback onPressed,
  }) : _onPressed = onPressed;

  @override
  Widget button() {
    return IconButton(
      onPressed: onPressed,
      icon: step.isCompleted
          ? const Icon(Icons.download_outlined)
          : const Icon(Icons.close),
    );
  }

  @override
  Widget icon() {
    return SizedBox(
      height: 50,
      width: 50,
      child: Stack(
        children: [
          ImageHolder(
            height: 50,
            width: 50,
            imageUrl: extension.iconUrl,
            fit: BoxFit.fill,
          ),
          if (!step.isCompleted)
            const SizedBox(
                height: 50, width: 50, child: CircularProgressIndicator())
        ],
      ),
    );
  }

  @override
  void onPressed() => _onPressed();

  @override
  Widget subtitle() {
    final subtitleText = getSubtitleText();
    return Text(
      subtitleText,
      style: subtitleTextStyle(),
    );
  }

  String getSubtitleText() {
    return buildString((it) {
      it.write(extension.versionName);
      switch (step) {
        case InstallStep.Downloading:
          it.writeWithMiddleDot('Downloading');
          break;
        case InstallStep.Installing:
          it.writeWithMiddleDot('Installing');
          break;
        case InstallStep.Installed:
          it.writeWithMiddleDot('Installed');
          break;
        default:
          break;
      }
    });
  }

  @override
  Widget title() {
    return Text(
      extension.name,
      style: titleTextStyle(),
    );
  }
}
