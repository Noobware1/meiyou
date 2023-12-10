import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';
import 'package:meiyou/presentation/widgets/add_space.dart';
import 'package:meiyou/presentation/widgets/player/controls/mobile/bottom_row_buttons.dart';
import 'package:meiyou/presentation/widgets/player/controls/mobile/center_row_buttons.dart';
import 'package:meiyou/presentation/widgets/player/controls/mobile/progress_bar_mobile.dart';
import 'package:meiyou/presentation/widgets/player/controls/mobile/top_row.dart';

class MobileControls extends StatelessWidget {
  const MobileControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      // alignment: Alignment.center,
      children: [
        const Center(
          child: VideoPlayerMainRowButtonsMobile(),
        ),
        Positioned(
          bottom: 20,
          right: 0,
          left: 0,
          child: SafeArea(
            minimum: const EdgeInsets.only(left: 30, right: 30),
            top: false,
            child: SizedBox(
              width: context.screenWidth,
              child: Column(
                children: [
                  const VideoProgressbarMobile(),
                  addVerticalSpace(2),
                  const VideoPlayerBottomRowButtonsMobile(),
                ],
              ),
            ),
          ),
        ),
        Positioned(
            top: 0,
            left: 0,
            child: SizedBox(
              width: context.screenWidth,
              child: const SafeArea(
                  minimum: EdgeInsets.only(left: 30, right: 30, top: 30),
                  bottom: false,
                  child: VideoPlayerTopRowMobile()),
            )),
      ],
    );
  }
}
