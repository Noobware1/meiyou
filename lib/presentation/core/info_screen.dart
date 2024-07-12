import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:meiyou/core/constants/font_size.dart';
import 'package:meiyou/core/utils/extensions/context.dart';
import 'package:meiyou/presentation/core/button.dart';
import 'package:meiyou/presentation/core/space.dart';
import 'package:nice_dart/nice_dart.dart';

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

    // final topPadding = context.mediaPadding.top;
    // final columnHeight =
    //     context.height - (topPadding + appBar.preferredSize.height);

    return Scaffold(
      body: Column(
        children: [
          AppBar().preferredSize.let((it) => SizedBox(
                height: it.height,
                width: context.width,
              )),
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 900),
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
                          style: const TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          subtitleText,
                          style: const TextStyle(
                            fontSize: MobileFontSize.normal,
                            fontWeight: FontWeight.w500,
                            // color: ,
                          ),
                        ),
                        const VerticalSpace(18),
                        Container(
                          width: context.width,
                          padding: const EdgeInsets.fromLTRB(10, 18, 10, 18),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceVariant,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: DefaultTextStyle.merge(
                            style: const TextStyle(
                              fontSize: 12.5,
                            ),
                            child: child,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8.0, 20, 8.0),
            child: Button(
              text: acceptText,
              onPressed: onAccept,
              enabled: canAccept,
            ),
          )
        ],
      ),
    );
  }
}
