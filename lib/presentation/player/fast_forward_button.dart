import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meiyou/core/constants/font_size.dart';
import 'package:meiyou/core/utils/extensions/context.dart';

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
  final VoidCallback onTap;
  final void Function(int) onFinished;

  const _Button({
    super.key,
    required bool left,
    required this.onFinished,
    required this.onTap,
  }) : _left = left;
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
    final icon = widget._left
        ? const RotatedBox(
            quarterTurns: 2,
            child: Icon(
              Icons.play_arrow_rounded,
              color: Colors.white,
              size: 70,
            ))
        : const Icon(
            Icons.play_arrow_rounded,
            color: Colors.white,
            size: 70,
          );

    final containerWidth = context.width / 3;

    final EdgeInsets padding = widget._left
        ? const EdgeInsets.only(right: 20)
        : const EdgeInsets.only(left: 20);

    final height = context.height;
    final radius = height / 2;
    final borderRadius = widget._left
        ? BorderRadius.only(
            topRight: Radius.circular(radius),
            bottomRight: Radius.circular(radius),
          )
        : BorderRadius.only(
            topLeft: Radius.circular(radius),
            bottomLeft: Radius.circular(radius),
          );

    return GestureDetector(
      onDoubleTap: () {
        widget.onTap();
        _startAnimation();
      },
      child: AnimatedOpacity(
        onEnd: () {
          arrow2Controller.reset();
          if (hide) {
            widget.onFinished(seconds);
            seconds = 0;
          }
        },
        duration: const Duration(milliseconds: 200),
        opacity: hide ? 0.0 : 1.0,
        // opacity: 1.0,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: borderRadius,
              gradient: LinearGradient(
                colors: [
                  context.theme.colorScheme.primary.withOpacity(0.6),
                  context.theme.colorScheme.primary.withOpacity(0.2),
                ],
                begin:
                    widget._left ? Alignment.centerLeft : Alignment.centerRight,
                end:
                    widget._left ? Alignment.centerRight : Alignment.centerLeft,
              )),
          height: height,
          width: containerWidth,
          child: Stack(
            alignment: Alignment.center,
            children: [
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
                  child: Center(
                    child: SlideTransition(
                      position: animation2,
                      child: icon,
                    ),
                  ),
                ),
              ),
              FadeTransition(
                  opacity: animation3,
                  child: Padding(
                    padding: padding,
                    child: Center(
                      child: SlideTransition(
                        position: animation4,
                        child: icon,
                      ),
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.only(top: 80),
                child: Center(
                  child: Text((widget._left ? '-' : '+') + seconds.toString(),
                      style: const TextStyle(
                        fontSize: MobileFontSize.semiLarge,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
