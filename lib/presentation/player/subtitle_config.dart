import 'package:flutter/material.dart';
import 'package:media_kit_video/media_kit_video.dart';

const subtitleConfigforMobile = SubtitleViewConfiguration(
  visible: true,
  style: TextStyle(
      fontSize: 55.0,
      letterSpacing: 0.0,
      wordSpacing: 0.0,
      color: Color(0xffffffff),
      fontWeight: FontWeight.w600,
      shadows: [
        Shadow(
            //bottomLeft
            offset: Offset(1.5, -1.5),
            blurRadius: 1.0,
            color: Colors.black),
        Shadow(
            //bottomRight
            offset: Offset(1.5, -1.5),
            blurRadius: 1.0,
            color: Colors.black),
        Shadow(
            //topRight
            offset: Offset(1.5, 1.5),
            blurRadius: 1.0,
            color: Colors.black),
        Shadow(
            //topLeft
            offset: Offset(1.5, 1.5),
            blurRadius: 1.0,
            color: Colors.black),
      ]

      // backgroundColor: Color(0xaa000000),
      ),
  textAlign: TextAlign.center,
  padding: EdgeInsets.fromLTRB(
    16.0,
    0.0,
    16.0,
    24.0,
  ),
);

const subtitleConfigforDesktop = SubtitleViewConfiguration(
  visible: true,
  style: TextStyle(
      fontSize: 45.0,
      letterSpacing: 0.0,
      wordSpacing: 0.0,
      color: Color(0xffffffff),
      fontWeight: FontWeight.w600,
      shadows: [
        Shadow(
            //bottomLeft
            offset: Offset(1.5, -1.5),
            blurRadius: 1.0,
            color: Colors.black),
        Shadow(
            //bottomRight
            offset: Offset(1.5, -1.5),
            blurRadius: 1.0,
            color: Colors.black),
        Shadow(
            //topRight
            offset: Offset(1.5, 1.5),
            blurRadius: 1.0,
            color: Colors.black),
        Shadow(
            //topLeft
            offset: Offset(1.5, 1.5),
            blurRadius: 1.0,
            color: Colors.black),
      ]

      // backgroundColor: Color(0xaa000000),
      ),
  textAlign: TextAlign.center,
  padding: EdgeInsets.fromLTRB(
    16.0,
    0.0,
    16.0,
    24.0,
  ),
);
