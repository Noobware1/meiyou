import 'package:flutter/material.dart';
import 'package:meiyou/core/resources/platform_check.dart';
import 'package:meiyou/domain/entities/show_type.dart';
import 'package:meiyou/presentation/widgets/add_space.dart';

Icon _getSmilyFace(double score, [double size = 25.0]) {
  if (score <= 3.0) {
    return Icon(
      Icons.sentiment_dissatisfied_outlined,
      color: Colors.red.shade400,
      size: size,
    );
  } else if (score <= 5.0 && score > 3.0) {
    return Icon(
      Icons.sentiment_neutral_outlined,
      color: Colors.yellow.shade400,
      size: size,
    );
  } else {
    return Icon(
      Icons.sentiment_satisfied_outlined,
      color: Colors.green.shade400,
      size: size,
    );
  }
}

class _ForBiggerScreens extends StatelessWidget {
  final String title;
  final List<String>? genres;
  final ShowType showType;
  final DateTime? airDate;
  final String? description;
  final double? rating;
  final Widget buttons;
  const _ForBiggerScreens(
      {required this.title,
      required this.showType,
      this.genres,
      this.airDate,
      this.rating,
      required this.buttons,
      this.description});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
                fontSize: 28,
                overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.w700),
            textAlign: TextAlign.start,
            maxLines: 2,
          ),
          addVerticalSpace(5),
          Row(
            children: [
              if (rating != null)
                if (rating! > 0.0) ...[
                  _getSmilyFace(rating!, 20),
                  addHorizontalSpace(3),
                  Text(
                    rating.toString(),
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w500),
                  ),
                  addHorizontalSpace(10),
                ],
              const Icon(
                Icons.tv_rounded,
                size: 30,
                color: Colors.grey,
              ),
              addHorizontalSpace(5),
              Text(
                showType.toString().toUpperCase(),
                style:
                    const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
              ),
              if (airDate != null) ...[
                addHorizontalSpace(10),
                Text(
                  airDate!.year.toString(),
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.w500),
                ),
              ],
            ],
          ),
          addVerticalSpace(10),
          if (genres != null) ...[
            Flexible(
              child: Wrap(
                // alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                // runSpacing: 10,
                spacing: 10,
                children: List.generate(
                    genres!.length,
                    (index) => [
                          Text(
                            genres![index],
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          if (index != genres!.length - 1)
                            Container(
                              height: 5,
                              width: 5,
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.grey),
                            ),
                        ]).reduce((a, b) => [...a, ...b]),
              ),
            ),
            addVerticalSpace(10),
          ],
          if (description != null)
            Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 10),
              child: Text(
                description!,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          buttons
        ],
      ),
    );
  }
}

class BannerImageText extends StatelessWidget {
  final String title;
  final List<String>? genres;
  final Widget buttons;
  final ShowType showType;
  final DateTime? airDate;
  final double? rating;
  final String? description;

  const BannerImageText(
      {super.key,
      required this.title,
      required this.showType,
      required this.genres,
      this.airDate,
      required this.buttons,
      required this.rating,
      required this.description});

  @override
  Widget build(BuildContext context) {
    // return ResponsiveBuilder(
    return isMobile
        ? _ForSmallScreens(
            genres: genres,
            title: title,
            airDate: airDate,
            showType: showType,
            rating: rating,
            buttons: buttons,
            description: description,
          )
        : _ForBiggerScreens(
            genres: genres,
            title: title,
            airDate: airDate,
            showType: showType,
            rating: rating,
            buttons: buttons,
            description: description,
          );
    // forLagerScreen: _ForBiggerScreens(
    //     averageScore: averageScore,
    //     description: description,
    //     genres: genres,
    //     buttons: buttons,
    //     title: title));
  }
}

class _ForSmallScreens extends StatelessWidget {
  final String title;
  final List<String>? genres;
  final ShowType showType;
  final DateTime? airDate;
  final String? description;
  final double? rating;
  final Widget buttons;
  const _ForSmallScreens(
      {required this.title,
      required this.showType,
      this.genres,
      this.airDate,
      this.rating,
      required this.buttons,
      this.description});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
                fontSize: 20,
                overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.w700),
            textAlign: TextAlign.start,
            maxLines: 2,
          ),
          addVerticalSpace(5),
          Row(
            children: [
              if (rating != null)
                if (rating! > 0.0) ...[
                  _getSmilyFace(rating!, 20),
                  addHorizontalSpace(3),
                  Text(
                    rating.toString(),
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  addHorizontalSpace(10),
                ],
              const Icon(
                Icons.tv_rounded,
                size: 20,
                color: Colors.grey,
              ),
              addHorizontalSpace(5),
              Text(
                showType.toString().toUpperCase(),
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
              if (airDate != null) ...[
                addHorizontalSpace(10),
                Text(
                  airDate!.year.toString(),
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w500),
                ),
              ],
            ],
          ),
          addVerticalSpace(10),
          if (genres != null) ...[
            Flexible(
              child: Wrap(
                // alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                // runSpacing: 10,
                spacing: 10,
                children: List.generate(
                    genres!.length,
                    (index) => [
                          Text(
                            genres![index],
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          if (index != genres!.length - 1)
                            Container(
                              height: 5,
                              width: 5,
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.grey),
                            ),
                        ]).reduce((a, b) => [...a, ...b]),
              ),
            ),
            addVerticalSpace(5),
          ],
          if (description != null)
            Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 10),
              child: Text(
                description!,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          buttons
        ],
      ),
    );
  }
}
