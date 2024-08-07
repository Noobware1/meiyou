import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/constants/default_sized_box.dart';
import 'package:meiyou/core/utils/extensions/target_platform.dart';
import 'package:meiyou/features/player/presentation/widgets/player_theme/player_theme.dart';
import 'package:meiyou/shared/presentation/widgets/platform_builder.dart';

part 'show_video_sources_button_mobile.dart';

class ShowVideoSourcesButton extends StatelessWidget {
  final VoidCallback onPressed;
  const ShowVideoSourcesButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return PlatformBuilder(builder: (context, platform) {
      return platform.when(
        mobile: () => _ShowVideoSourcesButtonMobile(onPressed: onPressed),
        desktop: () => defaultSizedBox,
      );
    });
  }
}
