import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_kit/media_kit.dart';
import 'package:meiyou/core/utils/player_utils.dart';
import 'package:meiyou/presentation/player/video_controls/arrow_selector.dart';
import 'package:meiyou/presentation/widgets/apply_cancel.dart';

class ChangeSubtitle extends StatefulWidget {
  final List<SubtitleTrack> subtitleTracks;
  final VoidCallback onCancel;
  final void Function(SubtitleTrack subtitleTrack) onApply;
  const ChangeSubtitle(
      {super.key,
      required this.subtitleTracks,
      required this.onCancel,
      required this.onApply});

  @override
  State<ChangeSubtitle> createState() => _ChangeSubtitleState();

  static Future showSubtitlesDialog(BuildContext context, Player player) {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            elevation: 10,
            backgroundColor: Colors.black,
            child: RepositoryProvider.value(
              value: player,
              child: ChangeSubtitle(
                subtitleTracks: player.state.tracks.subtitle,
                onApply: (track) {
                  if (track != player.state.track.subtitle) {
                    player.setSubtitleTrack(track);
                  }
                  Navigator.pop(context);
                },
                onCancel: () {
                  Navigator.pop(context);
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

    selected = RepositoryProvider.of<Player>(context).state.track.subtitle;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints:
          const BoxConstraints(maxWidth: 300, maxHeight: 300, minHeight: 20),
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
                  children: widget.subtitleTracks.sublist(1).map((it) {
                    final isSame = selected == it;
                    return ArrowButton(
                        isSelected: isSame,
                        text: it.language ?? it.id,
                        onTap: () {
                          setState(() {
                            selected = it;
                          });
                        });
                  }).toList(),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
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
