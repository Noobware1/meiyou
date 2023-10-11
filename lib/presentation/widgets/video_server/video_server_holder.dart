import 'package:flutter/material.dart';
import 'package:meiyou/core/resources/copy_to_clipboard.dart';
import 'package:meiyou/core/resources/video_format.dart';
import 'package:meiyou/core/resources/watch_qualites.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';
import 'package:meiyou/domain/entities/video.dart';

class VideoServerHolder extends StatelessWidget {
  final void Function(VideoEntity video) onTap;
  final VideoEntity video;
  final bool? isPlaying;
  // final double width;
  const VideoServerHolder(
      {super.key, required this.onTap, required this.video, this.isPlaying});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Material(
        elevation: 5.0,
        surfaceTintColor: context.theme.colorScheme.tertiary,
        type: MaterialType.button,
        borderRadius: BorderRadius.circular(15),
        child: InkWell(
          onTap: () => onTap(video),
          borderRadius: BorderRadius.circular(15),
          splashColor: context.theme.colorScheme.primary,
          onLongPress: () {
            copyToClipBoard(context, video.url);
          },
          child: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: context.theme.colorScheme.tertiary,
                borderRadius: BorderRadius.circular(15)),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                  (video.fromat == VideoFormat.hls &&
                          video.quality == Qualites.master)
                      ? 'Multi Quailty'
                      : video.quality.toString(true),
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: context.theme.colorScheme.primary,
                      //Color.fromARGB(255, 40, 59, 75),
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              if (video.backup == true)
                Text(
                  'Backup',
                  style: TextStyle(
                      color: context.theme.colorScheme.primary,
                      //  Color.fromARGB(255, 40, 59, 75),
                      fontSize: 14),
                )
            ]),
          ),
        ),
      ),
    );
  }
}
