import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/resources/get_it/get_it.dart';
import 'package:meiyou/notifers/state_notifer.dart';

import 'package:media_kit_video/media_kit_video.dart';
import 'package:media_kit_video/media_kit_video_controls/media_kit_video_controls.dart';
import 'package:meiyou/core/utils/extensions/context.dart';
import 'package:meiyou/core/utils/resources/platform.dart';
import 'package:meiyou/presentation/core/getIt_widget.dart';
import 'package:meiyou/presentation/player/player_screen.dart';

class ResizeNotifer extends StateNotifer<BoxFit> {
  ResizeNotifer() : super(BoxFit.contain);

  void update(BuildContext context) {
    final BoxFit fit;
    final String name;
    switch (state) {
      case BoxFit.contain:
        fit = BoxFit.cover;
        name = 'Zoom';
        break;
      case BoxFit.cover:
        fit = BoxFit.fill;
        name = 'Stretch';
        break;
      default:
        fit = BoxFit.contain;
        name = 'Fit to screen';
        break;
    }
    getIt.get<VideoStateKey>().currentState?.update(fit: fit);
    setState(fit);
    BotToast.showCustomText(
      onlyOne: true,
      align: const Alignment(0, 0.90),
      duration: const Duration(seconds: 1),
      toastBuilder: (_) => Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: context.theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(name),
      ),
      // text: fit.name.toUpperCase(),
    );
  }
}

class PlayerResizeButton extends InjecktorWidget {
  const PlayerResizeButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return isMobile ? mobile(context) : desktop(context);
  }

  Widget mobile(BuildContext context) {
    addSingleton(context, () => ResizeNotifer());
    return GetItListenableBuilder<ResizeNotifer, BoxFit>(
        builder: (context, state) {
      return IconButton(
        icon: Icon(
          state != BoxFit.contain ? Icons.fullscreen_exit : Icons.fullscreen,
        ),
        onPressed: () => getIt.get<ResizeNotifer>().update(context),
      );
    });
  }

  Widget desktop(BuildContext context) {
    return IconButton(
      icon: Icon(
        isFullscreen(context) ? Icons.fullscreen_exit : Icons.fullscreen,
        color: Colors.white,
      ),
      onPressed: () {
        isFullscreen(context)
            ? exitFullscreen(context)
            : enterFullscreen(context);
      },
    );
  }
}
