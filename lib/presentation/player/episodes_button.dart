import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meiyou/core/utils/extensions/context.dart';
import 'package:meiyou/core/utils/resources/get_it/get_it.dart';

import 'package:meiyou/presentation/core/adaptive_sheet.dart';
import 'package:meiyou/presentation/core/space.dart';
import 'package:meiyou/presentation/info/content_widget/content_widget.dart';
import 'package:meiyou/presentation/info/services/info_screen_notifer.dart';
import 'package:meiyou/presentation/player/player_screen.dart';
import 'package:nice_dart/nice_dart.dart';

class ShowEpisodesButton extends StatelessWidget {
  const ShowEpisodesButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          getIt.playerRepository.pause();
          showCustomBottomSheet(
            context,
            showDragHandle: true,
            (context) => Container(
              // width: context.width / 1.6,
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: SingleChildScrollView(
                child: ContentWidget(
                  content: getIt.infoPage.content!,
                  contentProgress: getIt.infoPage.getContentProgress(),
                  onSelected: () {
                    getIt.playerRepository.playEpisode();
                    context.pop();
                  },
                ),
              ),
            ),
          );
        },
        icon: const Icon(
          Icons.video_library_rounded,
          color: Colors.white,
        ));
  }
}
