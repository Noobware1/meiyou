import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meiyou/core/utils/player_utils.dart';
import 'package:meiyou/presentation/player/video_controls/arrow_selector.dart';
import 'package:meiyou/presentation/widgets/apply_cancel.dart';
import 'package:media_kit/media_kit.dart';

class ChangeQuality extends StatefulWidget {
  final List<VideoTrack> videoTracks;

  final void Function(VideoTrack track) onApply;
  final void Function() onCancel;

  const ChangeQuality(
      {super.key,
      required this.videoTracks,
      required this.onApply,
      required this.onCancel});

  @override
  State<ChangeQuality> createState() => _ChangeQualityState();

  static Future showQuailtiesDialog(BuildContext context, Player player) {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            elevation: 10,
            backgroundColor: Colors.black,
            child: RepositoryProvider.value(
              value: player,
              child: ChangeQuality(
                videoTracks: player.state.tracks.video,
                onApply: (track) {
                  if (track != player.state.track.video) {
                    player.setVideoTrack(track);
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

class _ChangeQualityState extends State<ChangeQuality> {
  late final ScrollController _controller;
  late VideoTrack selected;

  @override
  void initState() {
    _controller = ScrollController();
    selected = RepositoryProvider.of<Player>(context).state.track.video;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print(player(context).state.track.video);

    return Container(
      constraints:
          const BoxConstraints(maxWidth: 300, maxHeight: 300, minHeight: 20),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              'Change Quailty',
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
                        isSelected: selected == widget.videoTracks[0],
                        text: 'auto',
                        onTap: () {
                          setState(() {
                            selected = widget.videoTracks[0];
                          });
                        }),
                    ...widget.videoTracks.sublist(2).map((it) {
                      final isSame = selected == it;
                      return ArrowButton(
                          isSelected: isSame,
                          text: '${it.h}x${it.w}',
                          onTap: () {
                            setState(() {
                              selected = it;
                            });
                          });
                    })
                  ],
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
