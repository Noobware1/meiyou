import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:injecktor/injecktor.dart';
import 'package:meiyou/presentation/common/cubits/link_and_data_cubit.dart';
import 'package:meiyou/presentation/core/dilog_box/list_dilog_box.dart';
import 'package:meiyou/presentation/core/injectktor_widget.dart';
import 'package:meiyou/presentation/player/cubits/player_cubit.dart';
import 'package:meiyou/presentation/player/player_screen.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:nice_dart/nice_dart.dart';

class ChangeVideoSourceButton extends StatelessWidget {
  const ChangeVideoSourceButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InjecktorBlocBuilder<PlayerCubit, PlayerState>(
      builder: (context, state) {
        return IconButton(
            onPressed: state.isLoading
                ? null
                : () {
                    showDialog(context);
                  },
            icon: const Icon(Icons.source_rounded));
      },
    );
  }

  static String toDisplayString(ContentDataLink link, VideoSource source) {
    return buildString((it) {
      it.write(link.name);
      if (source.format == VideoFormat.hls) {
        it.write(' - Multi');
      } else if (source.quality != null &&
          source.quality != const Quality.auto()) {
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
          return InjecktorBlocBuilder<LinkAndVideoCubit,
              LinkAndDataState<Video>>(
            builder: (context, state) {
              return state.when(
                  data: (selected, data) {
                    return ListDialogBox(
                        items: data
                            .mapList((pair) => pair.second.sources
                                .map((e) => toDisplayString(pair.first, e)))
                            .flattened
                            .toList(),
                        onItemSelected: (_, index) {
                          InjectKtor.playerRepository.setVideoSource(index);
                        });
                  },
                  initial: () => const Dialog(
                        child: Center(child: CircularProgressIndicator()),
                      ));
            },
          );
        });
  }
}
