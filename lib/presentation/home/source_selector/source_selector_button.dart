import 'package:flutter/material.dart';

import 'package:meiyou/core/utils/extensions/context.dart';
import 'package:meiyou/core/utils/resources/get_it/get_it.dart';
import 'package:meiyou/domain/source/source_manager.dart';
import 'package:meiyou/extension/models/entension_type.dart';
import 'package:meiyou/presentation/core/floating_action_button.dart';
import 'package:meiyou/presentation/home/source_selector/source_selector.dart';
import 'package:meiyou_extensions_lib/models.dart';

class SourceSelectorButton extends StatelessWidget {
  final Source? source;
  final void Function(ExtensionType type, Source?) onSourceSelected;

  const SourceSelectorButton({
    super.key,
    this.source,
    required this.onSourceSelected,
  });

  static const _noSourceSelected = "None";
  @override
  Widget build(BuildContext context) {
    final sourceName = source?.name ?? _noSourceSelected;
    return OkFloatActionButton(
      heroTag: 'sourceSelectorbtn',
      title: sourceName,
      onTap: () {
        SourceSelector.showBottomSheet(context, (type, installedSource) {
          final source =
              getIt.get<SourceManager>().getSource(type, installedSource.id);
          onSourceSelected(type, source);
        });
      },
    );
    // return FloatingActionButton.extended(
    //   elevation: _buttonElevation,
    //   icon: _buttonIcon,
    //   extendedPadding: _buttonExtendedPadding,
    //   label: Text(sourceName),
    //   backgroundColor: context.theme.scaffoldBackgroundColor,
    //   shape: _buttonShape,
    //   onPressed: () {
    //   },
    // );
  }
}
