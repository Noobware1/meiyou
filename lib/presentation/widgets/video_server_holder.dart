import 'package:flutter/material.dart';
import 'package:streamify/helpers/data_classes.dart';

class VideoServerHolder extends StatelessWidget {
  final String serverName;
  final void Function() onTap;
  final VideoFile video;
  final Widget? extra;
  final double width;
  const VideoServerHolder(
      {super.key,
      required this.onTap,
      required this.video,
      this.width = 80.0,
      required this.serverName,
      this.extra});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: width,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DefaultTextStyle(
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700),
                child: Text(serverName)),
            extra ?? const SizedBox.shrink(),
            const SizedBox(
              height: 8,
            ),
            DefaultTextStyle(
              style: const TextStyle(
                  color: Color.fromARGB(255, 40, 59, 75),
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
              child: Text(
                (video.data.length == 1)
                    ? '${video.data.first.quailty.quaility}p'
                    : 'Multi Quailty',
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

