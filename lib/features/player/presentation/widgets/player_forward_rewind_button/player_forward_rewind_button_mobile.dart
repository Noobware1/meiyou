import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/extensions/context.dart';
import 'package:meiyou/features/player/presentation/widgets/player_theme/player_theme.dart';

class FastForwardButton extends _Button {
  const FastForwardButton(
      {super.key, required super.onFinished, required super.onTap})
      : super(left: false);

  @override
  State<FastForwardButton> createState() => _ButtonState<FastForwardButton>();
}

class RewindButton extends _Button {
  const RewindButton(
      {super.key, required super.onFinished, required super.onTap})
      : super(left: true);

  @override
  State<RewindButton> createState() => _ButtonState<RewindButton>();
}

abstract class _Button extends StatefulWidget {
  final bool _left;
  final void Function(int) onTap;
  final void Function(int)? onFinished;
  // final void Function(int)? seek;

  const _Button({
    super.key,
    required bool left,
    required this.onFinished,
    required this.onTap,
    // this.seek,
  }) : _left = left;
}

class CirclePainter extends CustomPainter {
  LinearGradient gradient;

  CirclePainter(this.gradient);

  @override
  void paint(Canvas canvas, Size size) {
    // Create a paint object with the gradient
    final paint = Paint()
      ..shader = gradient.createShader(
        Rect.fromCircle(
            center: Offset(size.width / 2, size.height / 2),
            radius: size.width),
      );

    // Calculate the center and radius to make the circle overflow the screen
    final center = Offset(size.width / 2, size.height / 2);
    final radius =
        size.width; // You can adjust this to make the circle bigger or smaller

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class _ButtonState<T extends _Button> extends State<T>
    with TickerProviderStateMixin {
  late final AnimationController arrow1Controller;
  late final AnimationController arrow2Controller;
  late final Animation<double> animation0;
  late final Animation<double> animation1;
  late final Animation<Offset> animation2;
  late final Animation<double> animation3;
  late final Animation<Offset> animation4;
  bool hide = true;
  Timer? timer;
  int seconds = 0;

  @override
  void initState() {
    super.initState();

    arrow1Controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    arrow2Controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    animation0 = Tween<double>(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(parent: arrow1Controller, curve: Curves.easeInOut));

    animation1 = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: arrow1Controller, curve: Curves.easeInOut));

    animation2 = Tween<Offset>(
            begin: widget._left ? const Offset(0.8, 0) : const Offset(-0.8, 0),
            end: const Offset(0.0, 0))
        .animate(
            CurvedAnimation(parent: arrow1Controller, curve: Curves.easeInOut));

    animation3 = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: arrow2Controller, curve: Curves.easeInOut));

    animation4 = Tween<Offset>(
      begin: widget._left ? const Offset(0.8, 0) : const Offset(-0.8, 0),
      end: widget._left ? const Offset(0.4, 0) : const Offset(-0.4, 0),
    ).animate(
        CurvedAnimation(parent: arrow2Controller, curve: Curves.easeInOut));

    animation1.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        arrow2Controller.forward();
      }
    });

    animation3.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        stopAnimation();
      }
    });
  }

  void stopAnimation() {
    timer = Timer(const Duration(milliseconds: 200), () {
      setState(() {
        hide = true;
        arrow1Controller.reset();
      });
    });
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void _startAnimation() {
    arrow1Controller.reset();
    arrow2Controller.reset();

    setState(() {
      hide = false;
      timer?.cancel();
      timer = null;
      seconds += 10;
    });
    arrow1Controller.forward();
  }

  @override
  void dispose() {
    arrow1Controller.dispose();
    arrow2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = PlayerTheme.of(context);

    final icon = widget._left
        ? RotatedBox(
            quarterTurns: 2,
            child: Icon(
              Icons.play_arrow_rounded,
              color: theme.iconColor,
              size: theme.forwardRewindButtonSize,
            ))
        : Icon(
            Icons.play_arrow_rounded,
            color: theme.iconColor,
            size: theme.forwardRewindButtonSize,
          );

    final containerWidth = context.width / 3;

    final EdgeInsets padding = widget._left
        ? const EdgeInsets.only(right: 20)
        : const EdgeInsets.only(left: 20);

    final height = context.height;

    final gradient = LinearGradient(
      colors: [
        context.theme.colorScheme.primary.withOpacity(0.2),
        context.theme.colorScheme.primary.withOpacity(0.6),
      ],
      begin: widget._left ? Alignment.centerLeft : Alignment.centerRight,
      end: widget._left ? Alignment.centerRight : Alignment.centerLeft,
    );

    final size = Size(containerWidth * 0.8, height);
    return GestureDetector(
      onDoubleTap: () {
        widget.onTap(10);
        _startAnimation();
      },
      child: AnimatedOpacity(
        onEnd: () {
          arrow2Controller.reset();
          if (hide) {
            widget.onFinished?.call(seconds);
            seconds = 0;
          }
        },
        duration: const Duration(milliseconds: 200),
        opacity: hide ? 0.0 : 1.0,
        child: CustomPaint(
          size: size,
          painter: CirclePainter(gradient),
          child: Stack(
            alignment:
                widget._left ? Alignment.centerRight : Alignment.centerLeft,
            children: [
              SizedBox.fromSize(
                size: size,
              ),
              SizeTransition(
                sizeFactor: animation0,
                child: Padding(
                  padding: padding,
                  child: Center(
                    child: icon,
                  ),
                ),
              ),
              FadeTransition(
                opacity: animation1,
                child: Padding(
                  padding: padding,
                  child: SlideTransition(
                    position: animation2,
                    child: icon,
                  ),
                ),
              ),
              FadeTransition(
                  opacity: animation3,
                  child: Padding(
                    padding: padding,
                    child: SlideTransition(
                      position: animation4,
                      child: icon,
                    ),
                  )),
              Padding(
                padding: padding.copyWith(top: 80),
                child: Text((widget._left ? '-' : '+') + seconds.toString(),
                    style: theme.forwardRewindButtonTextStyle),
              )
            ],
          ),
        ),
      ),
    );
  }
}
