import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injecktor/injecktor.dart';
import 'package:meiyou/presentation/core/adaptive_sheet.dart';
import 'package:meiyou/presentation/info/content_widget/content_widget.dart';
import 'package:meiyou/presentation/player/player_screen.dart';

class ShowEpisodesButton extends StatelessWidget {
  const ShowEpisodesButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          InjectKtor.playerRepository.pause();
          showCustomBottomSheet(
            context,
            (context) => SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(10),
                child: ContentWidget(
                  content: InjectKtor.infoPage.content!,
                  onSelected: () {
                    InjectKtor.playerRepository.playEpisode();
                    context.pop();
                  },
                ),
              ),
            ),
          );
        },
        icon: const Icon(Icons.video_library_rounded));
  }
}
