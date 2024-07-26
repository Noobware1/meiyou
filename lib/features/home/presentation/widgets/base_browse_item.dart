import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/constants/material_theme.dart';
import 'package:meiyou/core/utils/extensions/context.dart';
import 'package:meiyou/shared/presentation/widgets/responsive_widget.dart';

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
    // final colors = context.theme.colorScheme;
    // final textTheme = context.theme.textTheme;

    return ListTile(
      title: Text(
        name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: subtitle,
      leading: SizedBox(
        height: MaterialTheme.iconButtonSize,
        width: MaterialTheme.iconButtonSize,
        child: icon,
      ),
      trailing: ResponsiveBuilder(
        builder: (context, constraints, screenSize) {
          final actions =
              constraints.maxWidth <= 86 ? [this.actions.first] : this.actions;
          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: actions,
          );
        },
      ),
      onTap: onPressed,
      onLongPress: onLongPress,
    );
  }
}
