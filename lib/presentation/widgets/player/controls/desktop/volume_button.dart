import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:meiyou/presentation/providers/player_provider.dart';

// BUTTON: VOLUME

/// MaterialDesktop design volume button & slider.
class MaterialDesktopVolumeButton extends StatefulWidget {
  /// Icon size for the volume button.
  final double? iconSize;

  /// Icon color for the volume button.
  final Color? iconColor;

  /// Mute icon.
  final Widget? volumeMuteIcon;

  /// Low volume icon.
  final Widget? volumeLowIcon;

  /// High volume icon.
  final Widget? volumeHighIcon;

  /// Width for the volume slider.
  final double? sliderWidth;

  const MaterialDesktopVolumeButton({
    super.key,
    this.iconSize,
    this.iconColor,
    this.volumeMuteIcon,
    this.volumeLowIcon,
    this.volumeHighIcon,
    this.sliderWidth,
  });

  @override
  MaterialDesktopVolumeButtonState createState() =>
      MaterialDesktopVolumeButtonState();
}

class MaterialDesktopVolumeButtonState
    extends State<MaterialDesktopVolumeButton>
    with SingleTickerProviderStateMixin {
  static const volumeBarTransitionDuration = Duration(milliseconds: 150);

  static const volumeBarColor = Color(0x3DFFFFFF);
  static const volumeBarActiveColor = Color(0xFFFFFFFF);
  static const volumeBarThumbSize = 12.0;
  static const volumeBarThumbColor = Color(0xFFFFFFFF);

  late double volume = playerProvider(context).player.state.volume;

  StreamSubscription<double>? subscription;

  bool hover = false;

  bool mute = false;
  double _volume = 0.0;

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    subscription ??=
        playerProvider(context).player.stream.volume.listen((event) {
      setState(() {
        volume = event;
      });
    });
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (e) {
        setState(() {
          hover = true;
        });
      },
      onExit: (e) {
        setState(() {
          hover = false;
        });
      },
      child: Listener(
        onPointerSignal: (event) {
          if (event is PointerScrollEvent) {
            if (event.scrollDelta.dy < 0) {
              playerProvider(context).player.setVolume(
                    (volume + 5.0).clamp(0.0, 100.0),
                  );
            }
            if (event.scrollDelta.dy > 0) {
              playerProvider(context).player.setVolume(
                    (volume - 5.0).clamp(0.0, 100.0),
                  );
            }
          }
        },
        child: Row(
          children: [
            const SizedBox(width: 4.0),
            IconButton(
              onPressed: () async {
                if (mute) {
                  await playerProvider(context).player.setVolume(_volume);
                  mute = !mute;
                }
                // https://github.com/media-kit/media-kit/pull/250#issuecomment-1605588306
                else if (volume == 0.0) {
                  _volume = 100.0;
                  await playerProvider(context).player.setVolume(100.0);
                  mute = false;
                } else {
                  _volume = volume;
                  await playerProvider(context).player.setVolume(0.0);
                  mute = !mute;
                }

                setState(() {});
              },
              iconSize: widget.iconSize ?? (28.0 * 0.8),
              icon: AnimatedSwitcher(
                duration: volumeBarTransitionDuration,
                child: volume == 0.0
                    ? (widget.volumeMuteIcon ??
                        const Icon(
                          Icons.volume_off,
                          key: ValueKey(Icons.volume_off),
                        ))
                    : volume < 50.0
                        ? (widget.volumeLowIcon ??
                            const Icon(
                              Icons.volume_down,
                              key: ValueKey(Icons.volume_down),
                            ))
                        : (widget.volumeHighIcon ??
                            const Icon(
                              Icons.volume_up,
                              key: ValueKey(Icons.volume_up),
                            )),
              ),
            ),
            AnimatedOpacity(
              opacity: hover ? 1.0 : 0.0,
              duration: volumeBarTransitionDuration,
              child: AnimatedContainer(
                width:
                    hover ? (12.0 + (widget.sliderWidth ?? 52.0) + 18.0) : 12.0,
                duration: volumeBarTransitionDuration,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      const SizedBox(width: 12.0),
                      SizedBox(
                        width: widget.sliderWidth ?? 52.0,
                        child: SliderTheme(
                          data: SliderThemeData(
                            trackHeight: 1.2,
                            inactiveTrackColor: volumeBarColor,
                            activeTrackColor: volumeBarActiveColor,
                            thumbColor: volumeBarThumbColor,
                            thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: volumeBarThumbSize / 2,
                              elevation: 0.0,
                              pressedElevation: 0.0,
                            ),
                            trackShape: _CustomTrackShape(),
                            overlayColor: const Color(0x00000000),
                          ),
                          child: Slider(
                            value: volume.clamp(0.0, 100.0),
                            min: 0.0,
                            max: 100.0,
                            onChanged: (value) async {
                              await playerProvider(context)
                                  .player
                                  .setVolume(value);
                              mute = false;
                              setState(() {});
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 18.0),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final height = sliderTheme.trackHeight;
    final left = offset.dx;
    final top = offset.dy + (parentBox.size.height - height!) / 2;
    final width = parentBox.size.width;
    return Rect.fromLTWH(
      left,
      top,
      width,
      height,
    );
  }
}
