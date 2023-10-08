import 'package:flutter/material.dart';
import 'package:meiyou/core/constants/plaform_check.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';
import 'package:meiyou/presentation/widgets/add_space.dart';

class TextInsideText extends StatelessWidget {
  final String outerText;
  final String innerText;
  const TextInsideText({
    super.key,
    required this.outerText,
    required this.innerText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        addHorizontalSpace(context.screenWidth),
        addVerticalSpace(5),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Text(outerText,
              style: TextStyle(
                  fontSize: isMobile ? 15 : 18,
                  color: context.theme.colorScheme.onSurface)),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Text(innerText,
              style:
                  TextStyle(fontSize: isMobile ? 13 : 15, color: Colors.grey)),
        ),
        addVerticalSpace(5),
      ],
    );
  }
}
