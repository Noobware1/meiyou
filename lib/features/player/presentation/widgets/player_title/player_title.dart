import 'package:flutter/material.dart';
import 'package:meiyou/core/helper/media_content_helper.dart';
import 'package:meiyou/core/utils/constants/default_sized_box.dart';
import 'package:meiyou/core/utils/extensions/context.dart';
import 'package:meiyou/core/utils/extensions/target_platform.dart';
import 'package:meiyou/features/player/presentation/widgets/player_theme/player_theme.dart';
import 'package:meiyou/shared/domain/models/media.dart';
import 'package:meiyou/shared/domain/models/media_content.dart';
import 'package:meiyou/shared/presentation/widgets/platform_builder.dart';
import 'package:meiyou_extensions_lib/models.dart';

part 'player_title_mobile.dart';

class PlayerTitle extends StatelessWidget {
  final Media media;
  final MediaContent content;
  const PlayerTitle({super.key, required this.media, required this.content});

  @override
  Widget build(BuildContext context) {
    return PlatformBuilder(builder: (context, platform) {
      return platform.when(
        mobile: () => _PlayerTitleMobile(media: media, content: content),
        desktop: () => defaultSizedBox,
      );
    });
  }
}
