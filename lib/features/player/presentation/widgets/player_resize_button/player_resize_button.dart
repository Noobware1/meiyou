import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/extensions/target_platform.dart';
import 'package:meiyou/shared/presentation/notifers/state_notifer.dart';
import 'package:meiyou/shared/presentation/widgets/platform_builder.dart';
import 'package:meiyou/shared/presentation/widgets/state_listenable_builder.dart';

part 'player_resize_button_mobile.dart';

class PlayerResizeButton extends StatelessWidget {
  const PlayerResizeButton({
    super.key,
    required this.stateListenable,
    required this.onPressed,
  });

  final StateNotifier<BoxFit> stateListenable;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return PlatformBuilder(builder: (context, platform) {
      return platform.when(
        mobile: () => _PlayerResizeButtonMobile(
            stateListenable: stateListenable, onPressed: onPressed),
        desktop: () => const SizedBox(),
      );
    });
  }
}
