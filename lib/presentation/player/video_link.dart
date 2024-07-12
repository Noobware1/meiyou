import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/resources/get_it/get_it.dart';

import 'package:meiyou/presentation/common/notifers/link_and_data_notifer.dart';
import 'package:meiyou/presentation/core/dilog_box/list_dilog_box.dart';
import 'package:meiyou/presentation/core/getIt_widget.dart';
import 'package:meiyou/presentation/player/notifers/player_state_notifer.dart';
import 'package:meiyou/presentation/player/player_screen.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:nice_dart/nice_dart.dart';

extension on Quality {
  bool get isAuto => height == 0 && width == 0;
}

class ChangeVideoSourceButton extends StatelessWidget {
  const ChangeVideoSourceButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GetItListenableBuilder<PlayerStateNotifer, PlayerState>(
      builder: (context, state) {
        return IconButton(
            onPressed: () {
              if (state.isLoaded) {
                showDialog(context);
              }
            },
            icon: const Icon(
              Icons.source_rounded,
              color: Colors.white,
            ));
      },
    );
  }

  static String toDisplayString(ContentDataLink link, VideoSource source) {
    return buildString((it) {
      it.write(link.name);
      if (source.format == VideoFormat.hls) {
        it.write(' - Multi');
      } else if (source.quality != null && !(source.quality?.isAuto ?? true)) {
        it.write(' - ${source.quality!.height}p');
      }

      if (source.isBackup) {
        it.write(' (Backup)');
      }
    });
  }

  static Future showDialog(BuildContext context) {
    return showAdaptiveDialog(
        context: context,
        builder: (_) {
          return GetItListenableBuilder<LinkAndVideoNotifer, LinkAndVideoState>(
            builder: (context, state) {
              return state.when(
                data: (selected, data) {
                  final selectedSource = state.source;
                  final items = data
                      .mapList((pair) => pair.second.sources.map((e) {
                            final name = toDisplayString(pair.first, e);
                            return Pair(e, name);
                          }))
                      .flattened
                      .toList();

                  int selectedIndex =
                      items.indexWhere((e) => e.first == selectedSource);

                  return ListDialogBox(
                    selected: selectedIndex,
                    items: items.mapList((e) => e.second),
                    onItemSelected: (_, index) {
                      getIt.playerRepository.setVideoSource(items[index].first);
                    },
                  );
                },
                initial: () => const Dialog(
                  child: Center(child: CircularProgressIndicator()),
                ),
              );
            },
          );
        });
  }
}
