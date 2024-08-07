import 'package:flutter/material.dart' hide AlertDialog;
import 'package:meiyou/core/utils/constants/material_theme.dart';
import 'package:meiyou/features/home/presentation/screens/extensions/extensions_screen_view_model.dart';
import 'package:meiyou/features/home/presentation/widgets/base_browse_item.dart';
import 'package:meiyou/features/home/presentation/widgets/base_browse_list_view.dart';
import 'package:meiyou/shared/domain/models/install_step.dart';
import 'package:meiyou/shared/presentation/widgets/dialogs/alert_dialog.dart';
import 'package:meiyou/shared/presentation/widgets/empty_screen.dart';
import 'package:meiyou/shared/presentation/widgets/image_holder.dart';
import 'package:meiyou/shared/presentation/widgets/state_listenable_builder.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:nice_dart/nice_dart.dart';

class ExtensionsScreen extends StatelessWidget {
  final ExtensionsScreenViewModel viewModel;
  const ExtensionsScreen({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return StateListenableBuilder(
        stateListenable: viewModel.stateListenable,
        builder: (context, extensionsState, _) {
       
          if (extensionsState is ExtensionsStateLoading) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          final extensions = extensionsState.extensions;

          if (extensionsState is ExtensionsStateEmpty) {
            return const EmptyScreen(text: 'No extensions found');
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
                        subtitle: Text(_subtitleString(installStep, extension)),
                      );
                    });
              });
        });
  }

  String _subtitleString(InstallStep installStep, Extension extension) {
    var str = extension.versionName;
    switch (installStep) {
      case InstallStep.pending:
      case InstallStep.downloading:
      case InstallStep.installing:
      case InstallStep.installed:
      case InstallStep.error:
        str += ' \u00b7 ${installStep.name.captialize()}';
        break;
      default:
        break;
    }
    return str;
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
                onPressed: () => _downloadOrUpdateExtension(extension),
                icon: const Icon(Icons.download_outlined))
        ];
      default:
        return [
          IconButton(
              onPressed: () => _onPressedCancel(extension), icon: cancelIcon)
        ];
    }
  }

  void _onPressedCancel(Extension extension) {
    if (extension is AvailableExtension) {
      return viewModel.cancelDownload(extension);
    }
  }

  void _downloadOrUpdateExtension(Extension extension) {
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
        height: MaterialTheme.iconSize,
        width: MaterialTheme.iconSize,
        bytes: extension.icon,
      );
    } else {
      icon = ImageHolder.network(
        height: MaterialTheme.iconSize,
        width: MaterialTheme.iconSize,
        url: (extension as AvailableExtension).iconUrl,
      );
    }

    switch (installStep) {
      case InstallStep.pending:
      case InstallStep.downloading:
      case InstallStep.installing:
        const shrinkedIconSize = MaterialTheme.iconButtonSize - 6;
        return Stack(
          children: [
            Center(
              child: SizedBox(
                height: shrinkedIconSize,
                width: shrinkedIconSize,
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
        _onPressedCancel(extension);
        break;
      case InstallStep.installed:
        break;
      case InstallStep.idle:
      case InstallStep.error:
        _downloadOrUpdateExtension(extension);
        break;
    }
  }

  void _onLongPressed(
      BuildContext context, InstallStep installStep, Extension extension) {
    switch (installStep) {
      case InstallStep.pending:
      case InstallStep.downloading:
      case InstallStep.installing:
        _onPressedCancel(extension);
        break;
      case InstallStep.installed:
        break;
      case InstallStep.idle:
      case InstallStep.error:
        if (extension is InstalledExtension && !extension.hasUpdate) {
          showUnistallExtensionDialog(context, extension);
        }
        _downloadOrUpdateExtension(extension);
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
