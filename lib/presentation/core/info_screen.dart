import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/extensions/context.dart';
import 'package:meiyou/presentation/core/button.dart';
import 'package:meiyou/presentation/core/space.dart';

class InfoScreen extends StatelessWidget {
  final IconData icon;
  final String heading;
  final String subtitleText;
  final String acceptText;
  final bool canAccept;
  final VoidCallback onAccept;
  final String? rejectText;
  final VoidCallback? onReject;
  final Widget child;

  const InfoScreen({
    super.key,
    required this.heading,
    required this.subtitleText,
    required this.acceptText,
    this.canAccept = true,
    required this.onAccept,
    this.rejectText,
    this.onReject,
    required this.child,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 900,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    size: 60,
                    color: theme.colorScheme.primary,
                  ),
                  Text(
                    heading,
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onBackground,
                    ),
                  ),
                  Text(
                    subtitleText,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.onSecondary,
                    ),
                  ),
                  const VerticalSpace(10),
                  Container(
                    padding: const EdgeInsets.all(10),
                    width: context.width,
                    decoration: BoxDecoration(
                      color: context.theme.colorScheme.secondary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DefaultTextStyle.merge(
                      style: TextStyle(
                        fontSize: 12.5,
                        color: context.theme.colorScheme.onSecondary,
                      ),
                      child: child,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          Divider(color: theme.colorScheme.secondary),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8.0, 20, 8.0),
            child: Button(
              text: acceptText,
              onPressed: onAccept,
              enabled: canAccept,
            ),
          ),
        ],
      ),
    );
  }
}
