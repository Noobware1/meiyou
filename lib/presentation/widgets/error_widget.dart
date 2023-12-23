import 'package:flutter/material.dart';
import 'package:meiyou/core/constants/screen_size.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';
import 'package:meiyou/presentation/widgets/emoticons_widget.dart';
import 'package:meiyou/presentation/widgets/add_space.dart';

class CustomErrorWidget extends StatelessWidget {
  final String error;
  final VoidCallback? onRetry;
  final VoidCallback? onOpenInBrowser;
  const CustomErrorWidget(
      {super.key, required this.error, this.onRetry, this.onOpenInBrowser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: EmoticonsWidget(
      text: error,
      emoticon: 'ಥ_ಥ',
      children: (context, constraints) {
        final bool isMobile = constraints.maxWidth <= mobileScreenSize;
        final maxWidth = isMobile ? context.screenWidth / 1.2 : 400.0;
        final buttonStyle = ButtonStyle(
            fixedSize:
                MaterialStatePropertyAll(Size(maxWidth, isMobile ? 40 : 50)));
        return [
          ElevatedButton.icon(
              onPressed: () {
                if (onRetry != null) {
                  onRetry!.call();
                }
              },
              style: buttonStyle,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry Connection...')),
          addVerticalSpace(isMobile ? 2 : 5),
          ElevatedButton.icon(
              onPressed: () {
                if (onOpenInBrowser != null) {
                  onOpenInBrowser!.call();
                }
              },
              style: buttonStyle,
              icon: const Icon(Icons.public),
              label: const Text('Open in browser')),
        ];
      },
    ));
  }
}
