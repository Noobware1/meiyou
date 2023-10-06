import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';
import 'package:meiyou/presentation/widgets/add_space.dart';

class EpisodeNumberAndButtons extends StatelessWidget {
  final TextStyle? textStyle;
  final int? watched;
  final int? total;
  const EpisodeNumberAndButtons(
      {super.key, this.textStyle, required this.total, required this.watched});

  @override
  Widget build(BuildContext context) {
    final defaultTextStyle = textStyle ??
        const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Color(0xFF5F6267));
    final primaryColor = context.theme.colorScheme.primary;
    return Row(
      children: [
        Expanded(
          child: DefaultTextStyle(
              style: defaultTextStyle,
              child: RichText(
                text: TextSpan(children: [
                  TextSpan(text: 'Watched ', style: defaultTextStyle),
                  TextSpan(
                      text: (watched ?? 0).toString(),
                      style: defaultTextStyle.copyWith(color: primaryColor)),
                  TextSpan(text: ' of ', style: defaultTextStyle),
                  TextSpan(
                      text: total?.toString() ?? "~",
                      style: defaultTextStyle.copyWith(color: primaryColor))
                ]),
              )),
        ),
        addHorizontalSpace(10),
        const Expanded(
            child: Align(
                alignment: Alignment.centerRight, child: Icon(Icons.share)))
      ],
    );
  }
}
