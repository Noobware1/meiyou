import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/extensions/target_platform.dart';
import 'package:meiyou/shared/presentation/widgets/platform_builder.dart';

part 'player_skip_button_mobile.dart';

class PlayerSkipButton extends StatelessWidget {
  final VoidCallback onPressed;
  final int seconds;
  const PlayerSkipButton({
    super.key,
    required this.onPressed,
    required this.seconds,
  });
  @override
  Widget build(BuildContext context) {
    return PlatformBuilder(builder: (context, platform) {
      return platform.when(
        mobile: () => _PlayerSkipButtonMobile(onPressed: onPressed, seconds: seconds),
        desktop: () => const SizedBox(),
      );
    });
  }
}
