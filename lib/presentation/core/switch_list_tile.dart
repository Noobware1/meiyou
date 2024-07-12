import 'package:flutter/material.dart';

class CustomSwitchListTile extends StatelessWidget {
  final void Function(bool) onChanged;
  final bool value;
  final String title;
  final String? subtitleText;
  final Widget? leading;
  final Widget? trailing;
  final double? minLeadingWidth;
  final EdgeInsets? contentPadding;
  final TextStyle? titleTextStyle;
  final TextStyle? subtitleTextStyle;
  final bool? enabled;
  const CustomSwitchListTile({
    super.key,
    required this.onChanged,
    required this.value,
    required this.title,
    this.subtitleText,
    this.leading,
    this.trailing,
    this.minLeadingWidth,
    this.contentPadding,
    this.titleTextStyle,
    this.subtitleTextStyle,
    this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    final switchWidget = IgnorePointer(
      child: Switch.adaptive(
        value: value,
        onChanged: onChanged,
      ),
    );
    return ListTile(
      minLeadingWidth: minLeadingWidth,
      contentPadding: contentPadding,
      subtitle: subtitleText == null
          ? null
          : Text(subtitleText!, style: subtitleTextStyle),
      title: Text(title, style: titleTextStyle),
      enabled: enabled ?? true,
      onTap: () {
        onChanged(!value);
      },
      leading: leading,
      trailing: trailing == null
          ? switchWidget
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                trailing!,
                switchWidget,
              ],
            ),
    );
  }
}
