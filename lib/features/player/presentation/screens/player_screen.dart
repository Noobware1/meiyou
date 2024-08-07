import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meiyou/core/router/route_params.dart';
import 'package:meiyou/core/utils/constants/material_theme.dart';
import 'package:meiyou/core/utils/extensions/target_platform.dart';
import 'package:meiyou/features/player/presentation/widgets/player_forward_rewind_button/player_forward_rewind_button_mobile.dart';
import 'package:meiyou/features/player/presentation/widgets/player_next_previous_button/player_next_previous_button.dart';
import 'package:meiyou/features/player/presentation/widgets/player_resize_button/player_resize_button.dart';
import 'package:meiyou/features/player/presentation/widgets/player_subtitle_view/player_subtitle_view.dart';
import 'package:meiyou/features/player/presentation/widgets/shiow_video_sources_button/show_video_sources_button.dart';
import 'package:meiyou/features/player/presentation/widgets/show_media_content_list_button/show_media_content_list_button.dart';
import 'package:meiyou/features/player/presentation/widgets/video_settings_button/video_settings_button.dart';
import 'package:meiyou/shared/domain/models/async_value.dart';
import 'package:meiyou/shared/domain/models/extension_category.dart';
import 'package:meiyou/shared/presentation/widgets/platform_builder.dart';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meiyou/core/utils/constants/default_sized_box.dart';
import 'package:meiyou/core/utils/extensions/context.dart';
import 'package:meiyou/features/player/presentation/screens/player_screen_view_model.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:meiyou/features/player/presentation/widgets/player_play_pause_button/player_play_pause_button.dart';
import 'package:meiyou/features/player/presentation/widgets/player_seek_bar/player_seek_bar.dart';
import 'package:meiyou/features/player/presentation/widgets/player_skip_button/player_skip_button.dart';
import 'package:meiyou/features/player/presentation/widgets/player_theme/player_theme.dart';
import 'package:meiyou/features/player/presentation/widgets/player_theme/player_theme_data.dart';
import 'package:meiyou/features/player/presentation/widgets/player_title/player_title.dart';
import 'package:meiyou/shared/presentation/notifers/state_notifer.dart';
import 'package:meiyou/shared/presentation/widgets/spacing.dart';
import 'package:meiyou/shared/presentation/widgets/state_listenable_builder.dart';

part 'player_screen_mobile.dart';

class PlayerScreen extends StatefulWidget {
  final int mediaId;
  final ExtensionCategory category;
  final int contentId;

  const PlayerScreen({
    super.key,
    required this.mediaId,
    required this.category,
    required this.contentId,
  });

  PlayerScreen.fromRouteParams({
    super.key,
    required PlayerScreenRouteParams params,
  })  : mediaId = params.mediaId,
        category = params.category,
        contentId = params.contentId;

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late final PlayerScreenViewModel viewModel;

  bool exitCalled = false;

  @override
  void initState() {
    super.initState();
    viewModel = PlayerScreenViewModel(
      mediaId: widget.mediaId,
      category: widget.category,
      contentId: widget.contentId,
      exitCallback: () {
        if (!exitCalled) {
          exitCalled = true;
          context.pop();
        }
      },
    );
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return PlatformBuilder(builder: (context, platform) {
      return platform.when(
        mobile: () => _PlayerScreenMobile(
          viewModel: viewModel,
        ),
        desktop: () => defaultSizedBox,
      );
    });
  }
}
