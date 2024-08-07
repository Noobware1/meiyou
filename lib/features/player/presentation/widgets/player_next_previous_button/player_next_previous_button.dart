import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/constants/default_sized_box.dart';
import 'package:meiyou/core/utils/extensions/target_platform.dart';
import 'package:meiyou/features/player/presentation/widgets/player_theme/player_theme.dart';
import 'package:meiyou/shared/presentation/widgets/platform_builder.dart';

part 'player_next_previous_button_mobile.dart';

class PlayerNextButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool hasNext;

  const PlayerNextButton({
    super.key,
    required this.onPressed,
    required this.hasNext,
  });

  @override
  Widget build(BuildContext context) {
    return PlatformBuilder(builder: (context, platform) {
      return platform.when(
        mobile: () => _PlayerNextPreviousButtonMobile.next(
          onPressed: onPressed,
          enabled: hasNext,
        ),
        desktop: () => defaultSizedBox,
      );
    });
  }
}

class PlayerPreviousButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool hasPrevious;

  const PlayerPreviousButton({
    super.key,
    required this.onPressed,
    required this.hasPrevious,
  });

  @override
  Widget build(BuildContext context) {
    return PlatformBuilder(builder: (context, platform) {
      return platform.when(
        mobile: () => _PlayerNextPreviousButtonMobile.previous(
          onPressed: onPressed,
          enabled: hasPrevious,
        ),
        desktop: () => defaultSizedBox,
      );
    });
  }
}
