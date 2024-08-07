import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/constants/default_sized_box.dart';
import 'package:meiyou/core/utils/extensions/target_platform.dart';
import 'package:meiyou/shared/presentation/widgets/platform_builder.dart';
import 'package:meiyou/features/player/presentation/widgets/player_theme/player_theme.dart';

part 'show_media_content_list_button_mobile.dart';

class ShowMediaContentListButton extends StatelessWidget {
  final VoidCallback onPressed;
  const ShowMediaContentListButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return PlatformBuilder(builder: (context, platform) {
      return platform.when(
        mobile: () => _ShowMediaContentListButtonMobile(onPressed: onPressed),
        desktop: () => defaultSizedBox,
      );
    });
  }
}
