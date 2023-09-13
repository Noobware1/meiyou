import 'package:flutter/material.dart';
import 'package:meiyou/core/resources/video_format.dart';
import 'package:meiyou/core/resources/watch_qualites.dart';
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
    return GestureDetector(
      onTap: () => onTap(video),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(15)),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            DefaultTextStyle(
              style: const TextStyle(
                  color: Color.fromARGB(255, 40, 59, 75),
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
              child: Text(
                (video.fromat == VideoFormat.hls &&
                        video.quality == WatchQualites.master)
                    ? 'Multi Quailty'
                    : '${video.quality.quaility}p',
                textAlign: TextAlign.left,
              ),
            ),
            if (video.backup == true)
              const DefaultTextStyle(
                  style: TextStyle(
                      color: Color.fromARGB(255, 40, 59, 75), fontSize: 14),
                  child: Text('Backup'))
          ]),
        ),
      ),
    );
  }
}
