import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_kit/media_kit.dart';
import 'package:meiyou/core/constants/plaform_check.dart';
import 'package:meiyou/core/utils/player_utils.dart';
import 'package:meiyou/domain/entities/subtitle.dart';
import 'package:meiyou/presentation/player/video_controls/arrow_selector.dart';
import 'package:meiyou/presentation/player/video_controls/cubits/selected_server_cubit.dart';
import 'package:meiyou/presentation/widgets/apply_cancel.dart';
import 'package:meiyou/presentation/widgets/selector_dilaog_box.dart';
import 'package:meiyou/presentation/widgets/video_server_view.dart';

class ChangeSubtitle extends StatefulWidget {
  final List<SubtitleEntity>? subtitles;
  final VoidCallback onCancel;
  final void Function(SubtitleTrack subtitleTrack) onApply;
  const ChangeSubtitle(
      {super.key,
      required this.subtitles,
      required this.onCancel,
      required this.onApply});

  @override
  State<ChangeSubtitle> createState() => _ChangeSubtitleState();

  static Future showSubtitlesDialog(BuildContext context, Player player,
      SelectedServerCubit selectedServerCubit) {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            elevation: 10,
            backgroundColor: Colors.black,
            child: RepositoryProvider.value(
              value: player,
              child: BlocBuilder<SelectedServerCubit, SelectedServer>(
                bloc: selectedServerCubit,
                builder: (context, state) {
                  return ChangeSubtitle(
                    subtitles: state.videoContainerEntity.subtitles,
                    onApply: (track) {
                      Navigator.pop(context);
                      if (track != player.state.track.subtitle) {
                        Future.microtask(() async {
                          await Future.delayed(
                            const Duration(seconds: 1),
                          );
                          await player.setSubtitleTrack(track);
                        });
                      }
                    },
                    onCancel: () {
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          );
        });
  }
}

class _ChangeSubtitleState extends State<ChangeSubtitle> {
  late final ScrollController _controller;
  late SubtitleTrack selected;

  @override
  void initState() {
    _controller = ScrollController();

    selected = player(context).state.track.subtitle;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: isMobile
          ? const BoxConstraints(maxWidth: 300, maxHeight: 300, minHeight: 20)
          : const BoxConstraints(maxWidth: 350, maxHeight: 350, minHeight: 20),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              'Change Subtitle',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ScrollbarTheme(
              data: const ScrollbarThemeData(
                  thickness: MaterialStatePropertyAll(5.0),
                  thumbColor: MaterialStatePropertyAll(Colors.grey)),
              child: Scrollbar(
                // thumbVisibility: true,
                controller: _controller,
                child: ListView(
                  controller: _controller,
                  shrinkWrap: true,
                  children: [
                    ArrowButton(
                        isSelected: selected == SubtitleTrack.no(),
                        text: 'No Subtitle',
                        onTap: () {
                          setState(() {
                            selected = SubtitleTrack.no();
                          });
                        }),
                    if (widget.subtitles != null)
                      ...widget.subtitles!.map((it) {
                        final track =
                            SubtitleTrack.uri(it.url, language: it.lang);
                        final isSame = selected == track;
                        return ArrowButton(
                            isSelected: isSame,
                            text: it.lang,
                            onTap: () {
                              setState(() {
                                selected = track;
                              });
                            });
                      })
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Align(
              alignment: Alignment.bottomRight,
              child: Container(
                width: 200,
                height: 50,
                alignment: Alignment.bottomRight,
                child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: AppyCancel(
                      onApply: () => widget.onApply.call(selected),
                      onCancel: widget.onCancel,
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
