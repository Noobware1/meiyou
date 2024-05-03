library banner_button;

import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/extensions/context.dart';
import 'package:meiyou/core/utils/resources/screen_size.dart';

part 'banner_button_mobile.dart';
part 'banner_button_desktop.dart';

abstract class BannerButton extends StatelessWidget {
  final VoidCallback onItemSelected;
  final VoidCallback onAddToList;
  const BannerButton(
      {super.key, required this.onItemSelected, required this.onAddToList});

  // Main button

  Widget buildMainButton(BuildContext context);

  Icon mainButtonIcon(Color color) {
    return Icon(Icons.play_arrow_rounded, color: color);
  }

  Widget mainButtonLabel(Color color) {
    return Text(
      'Watch Now',
      style: TextStyle(
        color: color,
      ),
    );
  }

  Color mainButtonColor(BuildContext context) {
    return context.theme.colorScheme.primary;
  }

  Color mainButtonTextIconColor(BuildContext context) {
    return context.theme.colorScheme.onPrimary;
  }

  // Add to list button

  Widget buildAddToListButton(BuildContext context);

  Icon addToListIcon(Color color) {
    return Icon(
      Icons.add,
      color: color,
    );
  }

  Widget addToListLabel(Color color) {
    return Text(
      'Libary',
      style: TextStyle(
        color: color,
      ),
    );
  }

  Color addToListTextIconColor(BuildContext context) {
    return context.theme.colorScheme.onSurface;
  }

  // Common

  Color backgroundColor(BuildContext context) {
    return context.theme.colorScheme.onSurface.withDefaultOpacity();
  }

  Color overlayColor(BuildContext context) {
    return context.theme.colorScheme.surface.withDefaultOpacity();
  }

  factory BannerButton.forScreenSize(ScreenSize screenSize,
      {required void Function() onItemSelected,
      required void Function() onAddToList}) {
    switch (screenSize) {
      case ScreenSize.Mobile:
        return BannerButton.mobile(onItemSelected: onItemSelected, onAddToList: () {});
      case ScreenSize.Desktop:
        return BannerButton.desktop(onItemSelected: onItemSelected, onAddToList: () {});
      default:
        throw Exception('Invalid screen type');
    }
  }

  factory BannerButton.mobile(
      {Key? key,
      required VoidCallback onItemSelected,
      required VoidCallback onAddToList}) {
    return _BannerButtonMobile(
        key: key, onItemSelected: onItemSelected, onAddToList: onAddToList);
  }

  factory BannerButton.desktop(
      {Key? key,
      required VoidCallback onItemSelected,
      required VoidCallback onAddToList}) {
    return _BannerButtonDesktop(
        key: key, onItemSelected: onItemSelected, onAddToList: onAddToList);
  }
}

extension on Color {
  Color withDefaultOpacity() {
    return withOpacity(0.2);
  }
}
