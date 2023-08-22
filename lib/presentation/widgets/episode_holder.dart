import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:streamify/widgets/add_space.dart';
import 'package:streamify/widgets/resizeable_text.dart';

class EpisodeHolder extends StatelessWidget {
  final VoidCallback onTap;
  final String number;
  final String? thumbnail;
  final String? desc;
  final String? rated;
  final String title;
  const EpisodeHolder({
    super.key,
    required this.onTap,
    required this.number,
    required this.title,
    this.thumbnail,
    this.desc,
    this.rated,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: GestureDetector(
        onTap: onTap,
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      addVerticalSpace(15),
                      _buildTitle(context),
                      addVerticalSpace(5),
                      _buildRated()
                    ],
                  )
                ],
              ),
              if (desc != null) _buildDesc(),
              if (desc != null) addVerticalSpace(10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDesc() {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Align(
          alignment: Alignment.topLeft,
          child: ResizeableTextWidget(
            text: desc!,
            animate: false,
            maxlines: 3,
            paddText: false,
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
        height: 13.6,
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
            '$number. $title',
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
