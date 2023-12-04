import 'package:flutter/material.dart';
import 'package:meiyou/core/constants/screen_size.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';
import 'package:meiyou/presentation/widgets/add_space.dart';

class EmoticonsWidget extends StatelessWidget {
  final String emoticon;
  final String text;
  final List<Widget> Function(BuildContext context, BoxConstraints constraints)? children;
 
  const EmoticonsWidget(
      {super.key,
      required this.text,
      required this.emoticon,
      this.children,
    });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final bool isMobile = constraints.maxWidth <= mobileScreenSize;
      final maxWidth = isMobile ? context.screenWidth / 1.2 : 400.0;
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text(
              emoticon,
              style: TextStyle(
                  fontSize: isMobile ? 60 : 80, fontWeight: FontWeight.w400),
            ),
          ),
          addVerticalSpace(isMobile ? 2 : 20),
          Center(
            child: SizedBox(
              width: maxWidth,
              child: Column(
                children: [
                  Text(
                    text,
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: isMobile ? 16 : 20,
                        fontWeight: FontWeight.w400),
                  ),
                  addVerticalSpace(10),
                  if(children != null) ...children!(context, constraints),
                ],
              ),
            ),
          )
        ],
      );
    });
  }
}
