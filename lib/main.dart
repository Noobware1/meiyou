import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'dart:math' show pi;
import 'package:meiyou/core/config/routes/router_provider.dart';
import 'package:meiyou/core/constants/font_size.dart';
import 'package:meiyou/core/utils/extensions/context.dart';
import 'package:meiyou/core/utils/resources/get_it/get_it.dart';
import 'package:meiyou/core/utils/resources/meiyou_core.dart';
import 'package:meiyou/notifers/state_notifer.dart';
import 'package:meiyou/presentation/common/notifers/theme_notifer.dart';
import 'package:meiyou/presentation/core/default_sized_box.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:meiyou/presentation/core/state_listenable_builder.dart';

Color getColorBasedOnElvation(double elvation, Color color) {
  return color.computeLuminance() > 0.5 ? color : color;
}

void main() async {
  await MeiyouCore.ensureInitialized();
  // NavigationBar
  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
  //     systemNavigationBarColor: getColorBasedOnElvation(
  //         3.0,
  //         ColorScheme.fromSeed(
  //           seedColor: const Color(0xFFACC7FF),
  //           brightness: Brightness.dark,
  //           onPrimary: const Color(0xFF143062),
  //           secondary: const Color(0xFF444651),
  //           onSecondary: const Color(0xFFE0E1EB),
  //         ).surface)));
  runApp(const Meiyou());
}

class Meiyou extends StatelessWidget {
  const Meiyou({super.key});

  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   builder: BotToastInit(),
    //   navigatorObservers: [BotToastNavigatorObserver()],
    //   theme: ThemeData(
    //     colorScheme: ColorScheme.fromSeed(
    //       seedColor: const Color(0xFFACC7FF),
    //       brightness: Brightness.dark,
    //       onPrimary: const Color(0xFF143062),
    //       secondary: const Color(0xFF444651),
    //       onSecondary: const Color(0xFFE0E1EB),
    //     ),
    //     useMaterial3: true,
    //   ),
    //   themeMode: ThemeMode.dark,
    //   home: LWidget(),
    // );
    return StateListenableBuilder(
        stateListenable: getIt.get<ThemeNotifer>(),
        builder: (context, state, child) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
                statusBarIconBrightness: context.brightness == Brightness.dark
                    ? Brightness.light
                    : Brightness.dark,
                statusBarColor: Colors.transparent,
                systemNavigationBarColor:
                    getColor(state.getColorScheme(context))),
            child: MaterialApp.router(
              routerConfig: getIt.get<RouterProvider>().router,
              debugShowCheckedModeBanner: false,
              themeMode: state.themeMode,
              title: 'Meiyou',
              builder: BotToastInit(),
              theme: state.lightTheme,
              darkTheme: state.darkTheme,
            ),
          );
        });
  }

  Color getColor(ColorScheme scheme) {
    return ElevationOverlay.applySurfaceTint(
        scheme.surface, scheme.surfaceTint, 3.0);
  }
}

class LWidget extends StatelessWidget {
  const LWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final height = context.height;
    final width = context.width / 2;
    final yRadius = height / 2;
    final xRadius = width / 2;
    print(yRadius);
    return Scaffold(
        body: Align(
      alignment: Alignment.centerRight,
      child: ClipPath(
        // clipper: CircleClipper(side: Side.left),
        child: Container(
            width: width / 2,
            height: height,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.only(
                topLeft: Radius.elliptical(xRadius, xRadius),
                bottomLeft: Radius.elliptical(xRadius, xRadius),
              ),
            )),
      ),
    ));
  }
}

enum Side {
  left,
  right;

  Path toPath(Size size) {
    final path = Path();
    final Offset offset;
    final bool clockwise;

    switch (this) {
      case Side.left:
        path.moveTo(size.width, 0);
        offset = Offset(size.width, size.height);
        clockwise = false;
        break;
      case Side.right:
        path.moveTo(size.width / 1.5, 0);
        offset = Offset(size.width / 1.5, size.height);
        clockwise = true;
        break;
    }
    path.arcToPoint(
      offset,
      radius: Radius.elliptical(
        size.width / 2,
        size.height / 2,
      ),
      clockwise: clockwise,
    );

    path.close();

    return path;
  }
}

class CircleClipper extends CustomClipper<Path> {
  final Side side;

  CircleClipper({super.reclip, required this.side});

  @override
  Path getClip(Size size) => side.toPath(size);

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
