import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:meiyou/core/constants/assets.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';
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
      final bool isSmall;
      if (constraints.maxWidth <= 800) {
        isSmall = true;
      } else {
        isSmall = false;
      }

      return GestureDetector(
        onTap: onTap,
        child: Card(
          elevation: 4.0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(
                  color: context.theme.colorScheme.secondary.withOpacity(0.2))),
          //  decoration: BoxDecoration(
          color: context.theme.colorScheme.tertiary,
          surfaceTintColor: context.theme.colorScheme.tertiary,
          // borderRadius: const BorderRadius.all(
          //   Radius.circular(15),
          // )),

          child: SizedBox(
            width: context.screenWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Stack(
                        fit: StackFit.passthrough,
                        alignment: Alignment.center,
                        children: [
                          _imageHolder(isSmall),
                          _playButton(isSmall),
                          Positioned(
                            top: 0,
                            left: 0,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      bottomRight: Radius.circular(15)),
                                  color: context.theme.colorScheme.primary),
                              child: Text(
                                number.toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    addHorizontalSpace(10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          addVerticalSpace(15),
                          _buildTitle(context, isSmall),
                          addVerticalSpace(5),
                          _buildRated(isSmall)
                        ],
                      ),
                    )
                  ],
                ),
                if (desc != null && desc!.isNotEmpty) _buildDesc(isSmall),
                if (desc != null && desc!.isNotEmpty) addVerticalSpace(10),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildDesc(bool isSmall) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Align(
          alignment: Alignment.topLeft,
          child: ResizebleTextWidgetNoAnimation(
            text: desc!,
            maxLines: 3,
            style: TextStyle(
              fontSize: isSmall ? 12.8 : 14,
              color: const Color(0xFF5F6267),
              fontWeight: FontWeight.w500,
            ),
          ),
        ));
  }

  Widget _buildRated(bool isSmall) {
    return DefaultTextStyle(
      style: TextStyle(
          fontSize: isSmall ? 13.6 : 15,
          color: const Color(0xFF5F6267),
          fontWeight: FontWeight.w600),
      child: Text('Rated: ${rated ?? 0.0}'),
    );
  }

  Widget _buildTitle(BuildContext context, bool isSmall) {
    return Text(title ?? 'No Title',
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            fontSize: isSmall ? 15 : 18, fontWeight: FontWeight.w600));
  }

  Widget _imageHolder(bool isSmall) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: CachedNetworkImage(
          imageUrl: thumbnail ?? '',
          height: isSmall ? 100 : 120,
          width: isSmall ? 170 : 200,
          fit: BoxFit.cover,
          errorWidget: (context, url, error) => Image.asset(
            defaultbannerImage,
            height: isSmall ? 100 : 120,
            width: isSmall ? 170 : 200,
            fit: BoxFit.cover,
          ),
        ));
  }

  Widget _playButton(bool isSmall) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 2),
          color: Colors.black.withOpacity(0.7),
          shape: BoxShape.circle),
      child: Icon(
        Icons.play_arrow,
        color: Colors.white,
        size: isSmall ? 25 : 35,
      ),
    );
  }
}
