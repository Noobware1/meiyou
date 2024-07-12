import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/extensions/context.dart';

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
    final colors = context.theme.colorScheme;
    final textTheme = context.theme.textTheme;

    return ListTile(
      title: Text(
        name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: subtitle,
      leading: SizedBox(
        height: 48,
        width: 48,
        child: icon,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: actions,
      ),
      onTap: onPressed,
      onLongPress: onLongPress,
    );
  }
}
