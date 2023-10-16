import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_kit/media_kit.dart';
import 'package:meiyou/core/constants/plaform_check.dart';
import 'package:meiyou/domain/entities/subtitle.dart';
import 'package:meiyou/presentation/player/video_controls/cubits/selected_server_cubit.dart';
import 'package:meiyou/presentation/player/video_controls/subtitle_woker_bloc/subtitle_worker_bloc.dart'
    as bloc;
import 'package:meiyou/presentation/widgets/arrow_selector_list.dart';
import 'package:meiyou/presentation/widgets/video_server/video_server_view.dart';

class ChangeSubtitle extends StatelessWidget {
  final List<SubtitleEntity>? subtitles;
  final VoidCallback onCancel;
  final void Function(SubtitleEntity subtitleTrack) onApply;
  const ChangeSubtitle(
      {super.key,
      required this.subtitles,
      required this.onCancel,
      required this.onApply});

  static Future showSubtitlesDialog(
      BuildContext context,
      Player player,
      SelectedServerCubit selectedServerCubit,
      bloc.SubtitleWorkerBloc workerBloc) {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            elevation: 10,
            child: RepositoryProvider.value(
              value: player,
              child: BlocProvider.value(
                value: workerBloc,
                child: BlocBuilder<SelectedServerCubit, SelectedServer>(
                  bloc: selectedServerCubit,
                  builder: (context, state) {
                    return ChangeSubtitle(
                      subtitles: state.videoContainerEntity.subtitles,
                      onApply: (subtitle) {
                        Navigator.pop(context);
                        if (subtitle != workerBloc.state.subtitle) {
                          workerBloc.add(bloc.ChangeSubtitle(
                            subtitle: subtitle,
                            headers: selectedServerCubit.headers,
                          ));
                        }
                      },
                      onCancel: () {
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: isMobile
            ? const BoxConstraints(maxWidth: 300, maxHeight: 300, minHeight: 20)
            : const BoxConstraints(
                maxWidth: 350, maxHeight: 350, minHeight: 20),
        child: ArrowSelectorList<SubtitleEntity>(
            items: [SubtitleEntity.noSubtitle, ...(subtitles ?? [])],
            label: 'Change Subtitle',
            initalValue: BlocProvider.of<bloc.SubtitleWorkerBloc>(context)
                .state
                .subtitle,
            onApply: onApply,
            onCancel: onCancel,
            builder: (context, subtitle) {
              return subtitle.lang;
            }));
  }
}
