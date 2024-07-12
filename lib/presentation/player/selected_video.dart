import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:meiyou/core/constants/font_size.dart';
import 'package:meiyou/core/utils/extensions/context.dart';
import 'package:meiyou/core/utils/resources/get_it/get_it.dart';
import 'package:meiyou/presentation/common/notifers/link_and_data_notifer.dart';
import 'package:meiyou/presentation/player/video_link.dart';
import 'package:nice_dart/nice_dart.dart';

class SelectedVideo extends StatefulWidget {
  const SelectedVideo({super.key});

  @override
  State<SelectedVideo> createState() => _SelectedVideoState();
}

class _SelectedVideoState extends State<SelectedVideo> {
  String name = '';

  String qualityString(int? h, int? w) {
    if (h == null || w == null) {
      return 'Auto';
    }
    return '$h x $w';
  }

  @override
  void initState() {
    super.initState();
    getIt.get<LinkAndVideoNotifer>().addStateListner(listener);
  }

  @override
  void dispose() {
    getIt.get<LinkAndVideoNotifer>().removeStateListner(listener);
    super.dispose();
  }

  void listener(LinkAndVideoState state) {
    setState(() {
      name = state.source == null
          ? ''
          : ChangeVideoSourceButton.toDisplayString(
              state.linkAndData[state.selectedIndex].first,
              state.source!,
            );
    });
  }

  @override
  void setState(VoidCallback fn) {
    if (!mounted) return;
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = Colors.white.withOpacity(0.8);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(name,
            style: TextStyle(
                fontSize: MobileFontSize.normal,
                fontWeight: FontWeight.w600,
                color: baseColor)),
        if (name.isNotEmpty)
          StreamBuilder<VideoTrack?>(
              stream: getIt.get<Player>().stream.tracks.asyncMap((event) =>
                  event.video.firstWhereOrNull((track) =>
                      track == getIt.get<Player>().state.track.video)),
              builder: (context, snapshot) {
                final quality =
                    qualityString(snapshot.data?.h, snapshot.data?.w);
                return Text(
                  quality,
                  style: TextStyle(
                      fontSize: MobileFontSize.small,
                      fontWeight: FontWeight.w400,
                      color: baseColor),
                );
              }),
      ],
    );
  }
}
