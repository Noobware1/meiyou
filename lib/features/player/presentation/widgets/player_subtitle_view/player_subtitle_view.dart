
import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/constants/default_sized_box.dart';
import 'package:meiyou/core/utils/extensions/target_platform.dart';
import 'package:meiyou/core/utils/stream_utils/state_stream.dart';
import 'package:meiyou/shared/presentation/notifers/state_notifer.dart';
import 'package:meiyou/shared/presentation/widgets/platform_builder.dart';
import 'package:meiyou/shared/presentation/widgets/state_listenable_builder.dart';
import 'package:nice_dart/nice_dart.dart';

part 'player_subtitle_view_mobile.dart';

class PlayerSubtitleView extends StatelessWidget {
  final StateNotifier<List<String>> stateListenable;
  const PlayerSubtitleView({super.key, required this.stateListenable});

  @override
  Widget build(BuildContext context) {
    return PlatformBuilder(builder: (context, platform) {
      return platform.when(
        mobile: () => _PlayerSubtitleViewMobile(
          stateListenable: stateListenable,
        ),
        desktop: () => defaultSizedBox,
      );
    });
  }
}
