import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:meiyou/core/config/routes/routes.dart';

import 'package:meiyou/core/utils/extensions/string_buffer.dart';

import 'package:meiyou/core/utils/resources/flow.dart';
import 'package:meiyou/core/utils/resources/get_it/get_it.dart';
import 'package:meiyou/core/utils/resources/locale_helper.dart';
import 'package:meiyou/extension/extension_manager.dart';
import 'package:meiyou/extension/models/entension_type.dart';
import 'package:meiyou/extension/models/install_step.dart';
import 'package:meiyou/domain/source/get_language_with_extensions.dart';
import 'package:meiyou/presentation/core/grouped_list_view.dart';
import 'package:meiyou/presentation/core/image_holder.dart';
import 'package:meiyou/presentation/home/source_selector/extensions/tabs/extension_tab.dart';
import 'package:meiyou/presentation/home/source_selector/extensions/widgets/extension_tile.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:nice_dart/nice_dart.dart';

typedef LanguageWithAvailableExtensions = Map<String, List<AvailableExtension>>;

class AvailableExtensionTab extends ExtensionTab<Extension> {
  final ExtensionType type;
  const AvailableExtensionTab({super.key, required this.type});

  Widget installedExtensionTile(BuildContext context, Extension extension) {
    return _InstalledExtensionTile(
      extension: extension as InstalledExtension,
      onPressed: () {
        context.goToExtensionInfoScreen(extension, type);
      },
    );
  }

  Widget extensionItem(Extension extension) {
    return _ExtensionItem(
      extension: extension as AvailableExtension,
      type: type,
      needUpdate: false,
    );
  }

  @override
  StateFlow<Map<String, List<Extension>>> getFlow() {
    return GetLanguageWithAvailableExtensions(getIt.get()).flow(type);
  }

  @override
  Widget itemBuilder(BuildContext context, String language, Extension value) {
    if (language == 'Installed') {
      return installedExtensionTile(context, value);
    }
    return extensionItem(value);
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
          getIt
              .get<ExtensionManager>()
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

class _InstalledExtensionTile extends ExtensionTile {
  final InstalledExtension extension;
  final VoidCallback _onPressed;

  const _InstalledExtensionTile({
    super.key,
    required this.extension,
    required VoidCallback onPressed,
  }) : _onPressed = onPressed;

  @override
  Widget button() {
    return IconButton(
      onPressed: onPressed,
      icon: const Icon(Icons.settings_outlined),
    );
  }

  @override
  Widget icon({
    required Size size,
  }) {
    return ImageHolderMemory(
      height: 50,
      width: 50,
      bytes: extension.icon,
      fit: BoxFit.fill,
    );
  }

  @override
  void onPressed() => _onPressed();

  @override
  Widget subtitle({
    required TextStyle subtitleTextStyle,
  }) {
    final subtitleText = getSubtitleText();
    return Text(
      subtitleText,
      style: subtitleTextStyle,
    );
  }

  String getSubtitleText() {
    return buildString((it) {
      if (extension.lang != null) {
        it.write(LocaleHelper.getLocalizedDisplayName(extension.lang));
      }
      it.write(' ');
      it.write(extension.versionName);
    });
  }

  @override
  Widget title({
    required TextStyle titleTextStyle,
  }) {
    return Text(
      extension.name,
      style: titleTextStyle,
    );
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
  Widget icon({
    required Size size,
  }) {
    return SizedBox.fromSize(
      size: size,
      child: Stack(
        children: [
          ImageHolder(
            height: size.height,
            width: size.width,
            imageUrl: extension.iconUrl,
            fit: BoxFit.fill,
          ),
          if (!step.isCompleted)
            SizedBox(
                height: size.height,
                width: size.width,
                child: const CircularProgressIndicator())
        ],
      ),
    );
  }

  @override
  void onPressed() => _onPressed();

  @override
  Widget subtitle({
    required TextStyle subtitleTextStyle,
  }) {
    final subtitleText = getSubtitleText();
    return Text(
      subtitleText,
      style: subtitleTextStyle,
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
  Widget title({
    required TextStyle titleTextStyle,
  }) {
    return Text(
      extension.name,
      style: titleTextStyle,
    );
  }
}
