import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meiyou/core/constants/screen_size.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';
import 'package:meiyou/presentation/emoticons_widget.dart';

class NoPlugin extends StatelessWidget {
  const NoPlugin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: EmoticonsWidget(
      text: 'Select or install a plugin to enjoy!',
      emoticon: 'ɷ◡ɷ',
      children: (context, constraints) {
        final bool isMobile = constraints.maxWidth <= mobileScreenSize;
        final maxWidth = isMobile ? context.screenWidth / 1.2 : 400.0;
        final buttonStyle = ButtonStyle(
            fixedSize:
                MaterialStatePropertyAll(Size(maxWidth, isMobile ? 40 : 50)));
        return [
          ElevatedButton.icon(
              onPressed: () {
                context.go('/plugins');
              },
              style: buttonStyle,
              icon: const Icon(CupertinoIcons.cube_box),
              label: const Text('Install Plugin...')),
        ];
      },
    ));
  }
}
