// class PlayerTheme {
//   // BEHAVIOR

//   /// Whether to display seek bar.
//   final bool displaySeekBar;

//   /// Whether a skip next button should be displayed if there are more than one videos in the playlist.
//   final bool automaticallyImplySkipNextButton;

//   /// Whether a skip previous button should be displayed if there are more than one videos in the playlist.
//   final bool automaticallyImplySkipPreviousButton;

//   /// Modify volume on mouse scroll.
//   final bool modifyVolumeOnScroll;

//   /// Whether to toggle fullscreen on double press.
//   final bool toggleFullscreenOnDoublePress;

//   /// Keyboards shortcuts.
//   final Map<ShortcutActivator, VoidCallback>? keyboardShortcuts;

//   /// Whether the controls are initially visible.
//   final bool visibleOnMount;

//   // GENERIC

//   /// Padding around the controls.
//   ///
//   /// * Default: `EdgeInsets.zero`
//   /// * Fullscreen: `MediaQuery.of(context).padding`
//   final EdgeInsets? padding;

//   /// [Duration] after which the controls will be hidden when there is no mouse movement.
//   final Duration controlsHoverDuration;

//   /// [Duration] for which the controls will be animated when shown or hidden.
//   final Duration controlsTransitionDuration;

//   /// Builder for the buffering indicator.
//   final Widget Function(BuildContext)? bufferingIndicatorBuilder;

//   // BUTTON BAR

//   /// Buttons to be displayed in the primary button bar.
//   final List<Widget> primaryButtonBar;

//   /// Buttons to be displayed in the top button bar.
//   final List<Widget> topButtonBar;

//   /// Margin around the top button bar.
//   final EdgeInsets topButtonBarMargin;

//   /// Buttons to be displayed in the bottom button bar.
//   final List<Widget> bottomButtonBar;

//   /// Margin around the bottom button bar.
//   final EdgeInsets bottomButtonBarMargin;

//   /// Height of the button bar.
//   final double buttonBarHeight;

//   /// Size of the button bar buttons.
//   final double buttonBarButtonSize;

//   /// Color of the button bar buttons.
//   final Color buttonBarButtonColor;

//   // SEEK BAR

//   /// [Duration] for which the seek bar will be animated when the user seeks.
//   final Duration seekBarTransitionDuration;

//   /// [Duration] for which the seek bar thumb will be animated when the user seeks.
//   final Duration seekBarThumbTransitionDuration;

//   /// Margin around the seek bar.
//   final EdgeInsets seekBarMargin;

//   /// Height of the seek bar.
//   final double seekBarHeight;

//   /// Height of the seek bar when hovered.
//   final double seekBarHoverHeight;

//   /// Height of the seek bar [Container].
//   final double seekBarContainerHeight;

//   /// [Color] of the seek bar.
//   final Color seekBarColor;

//   /// [Color] of the hovered section in the seek bar.
//   final Color seekBarHoverColor;

//   /// [Color] of the playback position section in the seek bar.
//   final Color seekBarPositionColor;

//   /// [Color] of the playback buffer section in the seek bar.
//   final Color seekBarBufferColor;

//   /// Size of the seek bar thumb.
//   final double seekBarThumbSize;

//   /// [Color] of the seek bar thumb.
//   final Color seekBarThumbColor;

//   // VOLUME BAR

//   /// [Color] of the volume bar.
//   final Color volumeBarColor;

//   /// [Color] of the active region in the volume bar.
//   final Color volumeBarActiveColor;

//   /// Size of the volume bar thumb.
//   final double volumeBarThumbSize;

//   /// [Color] of the volume bar thumb.
//   final Color volumeBarThumbColor;

//   /// [Duration] for which the volume bar will be animated when the user hovers.
//   final Duration volumeBarTransitionDuration;

//   // SUBTITLE

//   /// Whether to shift the subtitles upwards when the controls are visible.
//   final bool shiftSubtitlesOnControlsVisibilityChange;



//    const PlayerTheme({
//     this.displaySeekBar = true,
//     this.automaticallyImplySkipNextButton = true,
//     this.automaticallyImplySkipPreviousButton = true,
//     this.toggleFullscreenOnDoublePress = true,
//     this.modifyVolumeOnScroll = true,
//     this.keyboardShortcuts,
//     this.visibleOnMount = false,
//     this.padding,
//     this.controlsHoverDuration = const Duration(seconds: 3),
//     this.controlsTransitionDuration = const Duration(milliseconds: 150),
//     this.bufferingIndicatorBuilder,
//     this.primaryButtonBar = const [],
//     this.topButtonBar = const [],
//     this.topButtonBarMargin = const EdgeInsets.symmetric(horizontal: 16.0),
//     this.bottomButtonBar = const [
//       // MaterialDesktopSkipPreviousButton(),
//       // MaterialDesktopPlayOrPauseButton(),
//       // MaterialDesktopSkipNextButton(),
//       // MaterialDesktopVolumeButton(),
//       // MaterialDesktopPositionIndicator(),
//       // Spacer(),
//       // MaterialDesktopFullscreenButton(),
//     ],
//     this.bottomButtonBarMargin = const EdgeInsets.symmetric(horizontal: 16.0),
//     this.buttonBarHeight = 56.0,
//     this.buttonBarButtonSize = 28.0,
//     this.buttonBarButtonColor = const Color(0xFFFFFFFF),
//     this.seekBarTransitionDuration = const Duration(milliseconds: 300),
//     this.seekBarThumbTransitionDuration = const Duration(milliseconds: 150),
//     this.seekBarMargin = const EdgeInsets.symmetric(horizontal: 16.0),
//     this.seekBarHeight = 3.2,
//     this.seekBarHoverHeight = 5.6,
//     this.seekBarContainerHeight = 36.0,
//     this.seekBarColor = const Color(0x3DFFFFFF),
//     this.seekBarHoverColor = const Color(0x3DFFFFFF),
//     this.seekBarPositionColor = const Color(0xFFFF0000),
//     this.seekBarBufferColor = const Color(0x3DFFFFFF),
//     this.seekBarThumbSize = 12.0,
//     this.seekBarThumbColor = const Color(0xFFFF0000),
//     this.volumeBarColor = const Color(0x3DFFFFFF),
//     this.volumeBarActiveColor = const Color(0xFFFFFFFF),
//     this.volumeBarThumbSize = 12.0,
//     this.volumeBarThumbColor = const Color(0xFFFFFFFF),
//     this.volumeBarTransitionDuration = const Duration(milliseconds: 150),
//     this.shiftSubtitlesOnControlsVisibilityChange = true,
//   });
// }
