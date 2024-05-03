import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/extensions/context.dart';
import 'package:meiyou/presentation/core/injectktor_widget.dart';
import 'package:meiyou/presentation/home/source_selector/selected_source.dart';
import 'package:meiyou/presentation/home/source_selector/source_selector.dart';
import 'package:meiyou_extensions_lib/models.dart';

class SourceSelectorButton extends StatelessWidget {
  const SourceSelectorButton({
    super.key,
  });

  static const _noSourceSelected = "None";

  static const _buttonIcon = Icon(
    Icons.view_headline_rounded,
  );

  static const _buttonShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(15)),
  );

  static const _buttonElevation = 10.0;

  static const _buttonExtendedPadding = EdgeInsets.fromLTRB(15, 50, 15, 50);

  @override
  Widget build(BuildContext context) {
    return InjecktorBlocBuilder<SelectedSource, Source?>(
      builder: (context, state) {
        return FloatingActionButton.extended(
          elevation: _buttonElevation,
          icon: _buttonIcon,
          extendedPadding: _buttonExtendedPadding,
          label: Text(state?.name ?? _noSourceSelected),
          backgroundColor: context.theme.scaffoldBackgroundColor,
          shape: _buttonShape,
          onPressed: () {
            SourceSelector.showBottomSheet(context);
          },
        );
      },
    );
  }
}
