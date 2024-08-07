import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/constants/default_sized_box.dart';
import 'package:meiyou/core/utils/extensions/target_platform.dart';
import 'package:meiyou/features/player/presentation/screens/player_screen_view_model.dart';
import 'package:meiyou/shared/presentation/widgets/dialogs/list_dialog.dart';
import 'package:meiyou/shared/presentation/widgets/platform_builder.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:nice_dart/nice_dart.dart';

part 'video_source_selector_mobile.dart';

class VideoSourceSelector extends StatelessWidget {
  final VideoSource selectedSource;
  final Map<MediaLink, List<VideoSource>> linkAndSources;
  final void Function(VideoSource) onSourceSelected;
  const VideoSourceSelector({
    super.key,
    required this.selectedSource,
    required this.linkAndSources,
    required this.onSourceSelected,
  });

  @override
  Widget build(BuildContext context) {
    return PlatformBuilder(builder: (context, platform) {
      return platform.when(
        mobile: () => _VideoSourceSelector(
          selectedSource: selectedSource,
          linkAndSources: linkAndSources,
          onSourceSelected: onSourceSelected,
        ),
        desktop: () => defaultSizedBox,
      );
    });
  }
}
