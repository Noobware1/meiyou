import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/extensions/context.dart';
import 'package:meiyou/core/utils/resources/screen_size.dart';

class ExtensionTileTheme {
  ExtensionTileTheme._(BuildContext context)
      : _theme = context.theme,
        isMobile = context.screenSize.isMobile;

  late final ThemeData _theme;
  late final bool isMobile;
  late final TextTheme _textTheme = _theme.textTheme;

  TextStyle? get titleTextStyle =>
      isMobile ? _textTheme.titleSmall : _textTheme.titleMedium;

  TextStyle? get subtitleTextStyle =>
      isMobile ? _textTheme.bodySmall : _textTheme.bodyMedium;

  Size get iconSize => const Size(50, 50);

  static of(BuildContext context) {
    return ExtensionTileTheme._(context);
  }
}

class BaseBrowseItem extends StatelessWidget {
  const BaseBrowseItem({
    super.key,
    required this.actions,
    required this.name,
    required this.icon,
    required this.onPressed,
    required this.onLongPress,
    required this.subtitle,
  });

  final String name;
  final Widget icon;
  final VoidCallback onPressed;
  final VoidCallback onLongPress;
  final List<Widget> actions;
  final Widget subtitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name),
      subtitle: subtitle,
      leading: icon,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: actions,
      ),
      onTap: onPressed,
      onLongPress: onLongPress,
    );
  }
}
