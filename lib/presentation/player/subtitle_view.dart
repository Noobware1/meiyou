/// This file is a part of media_kit (https://github.com/media-kit/media-kit).
///
/// Copyright © 2021 & onwards, Hitesh Kumar Saini <saini123hitesh@gmail.com>.
/// All rights reserved.
/// Use of this source code is governed by MIT license that can be found in the LICENSE file.
// ignore_for_file: dangling_library_doc_comments, doc_directive_missing_closing_tag, deprecated_member_use

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:injecktor/injecktor.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:nice_dart/nice_dart.dart';

class CustomSubtitleView extends StatefulWidget {
  const CustomSubtitleView({
    super.key,
  });

  @override
  State<CustomSubtitleView> createState() => _CustomSubtitleViewState();
}

class _CustomSubtitleViewState extends State<CustomSubtitleView> {
  late Duration duration = const Duration(milliseconds: 100);

  late SubtitleViewConfiguration config = const SubtitleViewConfiguration(
    style: TextStyle(
      fontSize: 21.0,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
  );
  late List<String> subtitle;
  StreamSubscription<List<String>>? subscription;
  // late TextStyle style;
  // late TextAlign textAlign;
  // late EdgeInsets padding;

  static const kTextScaleFactorReferenceWidth = 1920.0;
  static const kTextScaleFactorReferenceHeight = 1080.0;

  @override
  void initState() {
    InjectKtor.get<Player>().let((it) {
      subtitle = it.state.subtitle;
      subscription = InjectKtor.get<Player>().stream.subtitle.listen((value) {
        setState(() {
          subtitle = value;
        });
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  // void setPadding(
  //   EdgeInsets padding, {
  //   Duration duration = const Duration(milliseconds: 100),
  // }) {
  //   if (this.duration != duration) {
  //     setState(() {
  //       this.duration = duration;
  //     });
  //   }
  //   setState(() {
  //     this.padding = padding;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final textScaleFactor = config.textScaleFactor ??
            MediaQuery.of(context).textScaleFactor *
                sqrt(
                  ((constraints.maxWidth * constraints.maxHeight) /
                          (kTextScaleFactorReferenceWidth *
                              kTextScaleFactorReferenceHeight))
                      .clamp(0.0, 1.0),
                );
        return Material(
          color: Colors.transparent,
          child: AnimatedContainer(
            // padding: padding,
            duration: duration,
            alignment: Alignment.bottomCenter,
            child: Text(
              [
                for (final line in subtitle)
                  if (line.trim().isNotEmpty) line.trim(),
              ].join('\n'),
              style: subtileTextStyle(),
              textAlign: config.textAlign,
              textScaleFactor: textScaleFactor,
            ),
          ),
        );
      },
    );
  }
}

TextStyle subtileTextStyle() {
  // final subSets = ref.watch(subtitleSettingsStateProvider);
  final borderColor = Color.fromARGB(255, 0, 0, 0);
  return TextStyle(
      fontSize: 21,
      // fontWeight: subSets.useBold! ? FontWeight.bold : null,
      // fontStyle: subSets.useItalic! ? FontStyle.italic : null,
      color: Color.fromARGB(255, 255, 255, 255),
      shadows: [
        Shadow(
            offset: const Offset(-1.5, -1.5),
            color: borderColor,
            blurRadius: 1.4),
        Shadow(
            offset: const Offset(1.5, -1.5),
            color: borderColor,
            blurRadius: 1.4),
        Shadow(
            offset: const Offset(1.5, 1.5),
            color: borderColor,
            blurRadius: 1.4),
        Shadow(
            offset: const Offset(-1.5, 1.5),
            color: borderColor,
            blurRadius: 1.4)
      ],
      backgroundColor: const Color.fromARGB(
        0,
        0,
        0,
        0,
      ));
}
