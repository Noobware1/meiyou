import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';
import 'package:meiyou/presentation/widgets/add_space.dart';

class VideoPlayerBottomRowButtonsMobile extends StatelessWidget {
  const VideoPlayerBottomRowButtonsMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _IconButton(
            onTap: () {}, text: 'Resize', icon: Icons.aspect_ratio_rounded),
        _IconButton(onTap: () {

        }, text: 'Speed', icon: Icons.speed),
        _IconButton(
            onTap: () {}, text: 'Source', icon: Icons.playlist_play_rounded),
        _IconButton(onTap: () {}, text: 'Qualites', icon: Icons.hd_outlined),
        _IconButton(
            onTap: () {
              
            },
            text: 'Audio & Subtitles',
            icon: Icons.subtitles_outlined),
      ],
    );
  }
}

class _IconButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;
  const _IconButton(
      {required this.icon, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 20,
              ),
              addHorizontalSpace(10),
              DefaultTextStyle(
                style: const TextStyle(fontSize: 12, color: Colors.white),
                child: Text(text),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
