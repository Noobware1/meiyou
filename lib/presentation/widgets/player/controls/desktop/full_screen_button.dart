import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';
import 'package:meiyou/presentation/blocs/player/full_screen_cubit.dart';

// BUTTON: FULL SCREEN

/// MaterialDesktop design fullscreen button.
class MaterialDesktopFullscreenButton extends StatelessWidget {
  /// Icon for [MaterialDesktopFullscreenButton].
  final Widget? icon;

  /// Overriden icon size for [MaterialDesktopFullscreenButton].
  final double? iconSize;

  /// Overriden icon color for [MaterialDesktopFullscreenButton].
  final Color? iconColor;

  const MaterialDesktopFullscreenButton({
    Key? key,
    this.icon,
    this.iconSize,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FullScreenCubit, bool>(
      builder: (context, isFullscreen) {
        return IconButton(
            onPressed: () => context.bloc<FullScreenCubit>().toggleFullScreen(),
            icon: isFullscreen
                ? const Icon(Icons.fullscreen_exit)
                : const Icon(Icons.fullscreen),
            iconSize: iconSize);
      },
    );
  }
}
