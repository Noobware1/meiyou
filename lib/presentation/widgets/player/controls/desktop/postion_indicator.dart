import 'dart:async';

import 'package:flutter/material.dart';
import 'package:media_kit_video/media_kit_video_controls/src/controls/extensions/duration.dart';
import 'package:meiyou/presentation/providers/player_provider.dart';

// POSITION INDICATOR

/// MaterialDesktop design position indicator.
class MaterialDesktopPositionIndicator extends StatefulWidget {
  /// Overriden [TextStyle] for the [MaterialDesktopPositionIndicator].
  final TextStyle? style;
  const MaterialDesktopPositionIndicator({super.key, this.style});

  @override
  MaterialDesktopPositionIndicatorState createState() =>
      MaterialDesktopPositionIndicatorState();
}

class MaterialDesktopPositionIndicatorState
    extends State<MaterialDesktopPositionIndicator> {
  late Duration position = playerProvider(context).player.state.position;
  late Duration duration = playerProvider(context).player.state.duration;

  final List<StreamSubscription> subscriptions = [];

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (subscriptions.isEmpty) {
      subscriptions.addAll(
        [
          playerProvider(context).player.stream.position.listen((event) {
            setState(() {
              position = event;
            });
          }),
          playerProvider(context).player.stream.duration.listen((event) {
            setState(() {
              duration = event;
            });
          }),
        ],
      );
    }
  }

  @override
  void dispose() {
    for (final subscription in subscriptions) {
      subscription.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '${position.label(reference: duration)} / ${duration.label(reference: duration)}',
      style: widget.style ??
          const TextStyle(
            height: 1.0,
            fontSize: 12.0,
          ),
    );
  }
}
