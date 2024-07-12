import 'package:flutter/material.dart' hide AlertDialog;
import 'package:meiyou/core/utils/constants/default_sized_box.dart';
import 'package:meiyou/features/browse/presentation/view_models/extensions_screen_view_model.dart';
import 'package:meiyou/features/browse/presentation/widgets/base_browse_item.dart';
import 'package:meiyou/features/browse/presentation/widgets/base_browse_list_view.dart';
import 'package:meiyou/shared/domain/models/install_step.dart';
import 'package:meiyou/shared/domain/models/source.dart';
import 'package:meiyou/shared/presentation/widgets/dialogs/alert_dialog.dart';
import 'package:meiyou/shared/presentation/widgets/grouped_list_view.dart';
import 'package:meiyou/shared/presentation/widgets/image_holder.dart';
import 'package:meiyou/shared/presentation/widgets/state_listenable_builder.dart';
import 'package:meiyou_extensions_lib/models.dart';

class ExtensionsScreen extends StatelessWidget {
  final ExtensionsScreenViewModel viewModel;
  const ExtensionsScreen({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return StateListenableBuilder(
        stateListenable: viewModel.stateListenable,
        builder: (context, extensions, _) {
          if (extensions.isEmpty) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          return StateListenableBuilder(
              stateListenable: viewModel.downloadsStateListenable,
              builder: (context, state, _) {
                return BaseBrowseListView(
                    group: extensions,
                    itemBuilder: (context, extension) {
                      final installStep =
                          viewModel.getDownloadStatus(extension);
                      return BaseBrowseItem(
                        actions: _actions(installStep, extension),
                        name: extension.name,
                        icon: _icon(installStep, extension),
                        onPressed: () => _onPressed(installStep, extension),
                        onLongPress: () =>
                            _onLongPressed(context, installStep, extension),
                        subtitle: Text(extension.versionName),
                      );
                    });
              });
        });
  }

  List<Widget> _actions(InstallStep installStep, Extension extension) {
    switch (installStep) {
      case InstallStep.idle:
      case InstallStep.error:
      case InstallStep.installed:
        return [
          if (extension is InstalledExtension)
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {},
            )
          else
            IconButton(
                onPressed: () {}, icon: const Icon(Icons.public_outlined)),
          if ((extension is InstalledExtension && extension.hasUpdate) ||
              extension is AvailableExtension)
            IconButton(
                onPressed: () => downloadOrUpdateExtension(extension),
                icon: const Icon(Icons.download_outlined))
        ];
      default:
        return [
          IconButton(
              onPressed: () => onPressedCancel(extension), icon: cancelIcon)
        ];
    }
  }

  void onPressedCancel(Extension extension) {
    if (extension is AvailableExtension) {
      return viewModel.cancelDownload(extension);
    }
  }

  void downloadOrUpdateExtension(Extension extension) {
    if (extension is AvailableExtension) {
      return viewModel.installExtension(extension);
    } else if (extension is InstalledExtension && extension.hasUpdate) {
      return viewModel.updateExtension(extension);
    }
  }

  Icon get downloadIcon => const Icon(Icons.download_outlined);

  Icon get cancelIcon => const Icon(Icons.cancel_outlined);

  Icon get webIcon => const Icon(Icons.public_outlined);

  Widget _icon(InstallStep installStep, Extension extension) {
    Widget icon;
    if (extension is InstalledExtension) {
      icon = ImageHolder.memory(
        height: 24,
        width: 24,
        bytes: extension.icon,
      );
    } else {
      icon = ImageHolder.network(
        height: 24,
        width: 24,
        url: (extension as AvailableExtension).iconUrl,
      );
    }

    switch (installStep) {
      case InstallStep.pending:
      case InstallStep.downloading:
      case InstallStep.installing:
        return Stack(
          children: [
            Center(
              child: SizedBox(
                height: 42,
                width: 42,
                child: icon,
              ),
            ),
            const Positioned.fill(child: CircularProgressIndicator.adaptive()),
          ],
        );
      default:
        return icon;
    }
  }

  void _onPressed(InstallStep installStep, Extension extension) {
    switch (installStep) {
      case InstallStep.pending:
      case InstallStep.downloading:
      case InstallStep.installing:
        onPressedCancel(extension);
        break;
      case InstallStep.installed:
        break;
      case InstallStep.idle:
      case InstallStep.error:
        downloadOrUpdateExtension(extension);
        break;
    }
  }

  void _onLongPressed(
      BuildContext context, InstallStep installStep, Extension extension) {
    switch (installStep) {
      case InstallStep.pending:
      case InstallStep.downloading:
      case InstallStep.installing:
        onPressedCancel(extension);
        break;
      case InstallStep.installed:
        break;
      case InstallStep.idle:
      case InstallStep.error:
        if (extension is InstalledExtension && !extension.hasUpdate) {
          showUnistallExtensionDialog(context, extension);
        }
        downloadOrUpdateExtension(extension);
        break;
    }
  }

  showUnistallExtensionDialog(
      BuildContext context, InstalledExtension extension) {
    showDialog(
        context: context,
        builder: (context) => unistallDialog(context, extension));
  }

  Widget unistallDialog(BuildContext context, InstalledExtension extension) {
    return AlertDialog(
      title: 'Uninstall extension',
      content: Text(
          'Are you sure you want to uninstall "${extension.name}" extension?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            viewModel.uninstallExtension(extension);
          },
          child: const Text('Uninstall'),
        ),
      ],
    );
  }
}
