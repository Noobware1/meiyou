import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:meiyou/core/constants/default_sized_box.dart';
import 'package:meiyou/presentation/widgets/add_space.dart';
import 'package:meiyou/presentation/widgets/resizeable_text.dart';

class EpisodeHolder extends StatelessWidget {
  final VoidCallback onTap;
  final num number;
  final String? thumbnail;
  final String? desc;
  final double? rated;
  final String? title;
  const EpisodeHolder({
    super.key,
    required this.onTap,
    required this.number,
    this.title,
    this.thumbnail,
    this.desc,
    this.rated,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 230) {
        return Row(
          children: [
            const Icon(
              Icons.play_arrow,
              color: Colors.white,
            ),
            Expanded(
                child: Text(
              '$number. ${title ?? "No Title"}',
              style: const TextStyle(color: Colors.white),
            ))
          ],
        );
      }
      return Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                )),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(15),
                  )),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Stack(
                        children: [_imageHolder(), _playButton()],
                      ),
                      addHorizontalSpace(10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            addVerticalSpace(15),
                            _buildTitle(context),
                            addVerticalSpace(5),
                            _buildRated()
                          ],
                        ),
                      )
                    ],
                  ),
                  if (desc != null && desc!.isNotEmpty) _buildDesc(),
                  if (desc != null && desc!.isNotEmpty) addVerticalSpace(10),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildDesc() {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Align(
          alignment: Alignment.topLeft,
          child: _RezisbleTextWidget(
            text: desc!,
            maxLines: 3,
            style: const TextStyle(
              fontSize: 12.8,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ));
  }

  Widget _buildRated() {
    return SizedBox(
        height: 15,
        child: DefaultTextStyle(
          style: const TextStyle(
              fontSize: 13.6, color: Colors.grey, fontWeight: FontWeight.w600),
          child: Text('Rated: ${rated ?? 0.0}'),
        ));
  }

  Widget _buildTitle(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - (170 + 50),
      child: DefaultTextStyle(
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          child: Text(
            '$number. ${title ?? 'No Title'}',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          )),
    );
  }

  Widget _imageHolder() {
    return ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: CachedNetworkImage(
          imageUrl: thumbnail ?? '',
          height: 100,
          width: 170,
          fit: BoxFit.cover,
          errorWidget: (context, url, error) => Image.asset(
            'assets/images/default_banner_image.png',
            height: 100,
            width: 170,
            fit: BoxFit.cover,
          ),
        ));
  }

  Widget _playButton() {
    return Positioned(
        top: 30,
        left: 30,
        right: 30,
        bottom: 30,
        child: Container(
          height: 55,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2),
              color: Colors.black.withOpacity(0.7),
              shape: BoxShape.circle),
          child: const Icon(
            Icons.play_arrow,
            color: Colors.white,
            size: 25,
          ),
        ));
  }
}

class _RezisbleTextWidget extends StatefulWidget {
  final String text;
  final bool showButtons;
  final int maxLines;
  final TextStyle style;
  const _RezisbleTextWidget(
      {required this.text,
      required this.maxLines,
      this.showButtons = false,
      this.style = const TextStyle(
          color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400),
      super.key});

  @override
  State<_RezisbleTextWidget> createState() => __RezisbleTextWidgetState();
}

class __RezisbleTextWidgetState extends State<_RezisbleTextWidget> {
  bool showFullText = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() {
        if (showFullText) {
          showFullText = false;
        } else {
          showFullText = true;
        }
      }),
      child: Text(
        widget.text,
        style: widget.style,
        maxLines: !showFullText ? widget.maxLines : null,
        overflow: !showFullText ? TextOverflow.ellipsis : null,
      ),
    );
  }
}
