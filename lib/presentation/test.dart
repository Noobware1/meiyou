import 'package:flutter/material.dart';
import 'dart:math';
import 'package:meiyou/core/utils/extenstions/context.dart';

class MyArc extends StatelessWidget {
  const MyArc({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: SemicirclePainter(),
      size: Size(context.screenWidth * 2.4, context.screenHeight),
      child: child,
    );
  }
}

class SemicirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.red // Set the color of the semicircle
      ..strokeWidth = 2.0
      ..style = PaintingStyle
          .fill; // Change to PaintingStyle.fill to fill the semicircle

    double radius = size.height / 2;
    Offset center = Offset(0, size.height);

    canvas.drawArc(
      Rect.fromCenter(
        center: center,
        height: size.height,
        width: size.width,
      ),
      0,
      // Start angle (0 degrees)
      pi, // Sweep angle (180 degrees)
      true, // Draw a filled semicircle
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
