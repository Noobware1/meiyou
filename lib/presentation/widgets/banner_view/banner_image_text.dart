import 'package:flutter/material.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';
import 'package:meiyou/core/utils/extenstions/double.dart';
import 'package:meiyou/presentation/widgets/add_space.dart';
import 'package:meiyou/presentation/widgets/layout_builder.dart';

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
  final List<String> genres;
  final double averageScore;
  final String description;
  final Widget buttons;
  const _ForBiggerScreens(
      {required this.title,
      required this.genres,
      required this.buttons,
      required this.description,
      required this.averageScore});

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 70),
          child: Container(
              height: 300,
              // color: Colors.blue,
              width: context.screenWidth / 2,
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: DefaultTextStyle(
                  style: const TextStyle(),
                  child: Column(children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        title,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    addVerticalSpace(10),
                    Row(
                      children: [
                        _getSmilyFace(averageScore),
                        addHorizontalSpace(10),
                        Text(
                          '${averageScore.toPercentage()}%',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        addHorizontalSpace(10),
                        Expanded(
                          child: Wrap(
                            // alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            // runSpacing: 10,
                            spacing: 10,
                            children: List.generate(
                                genres.length,
                                (index) => [
                                      Text(
                                        genres[index],
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      if (index != genres.length - 1)
                                        Container(
                                          height: 5,
                                          width: 5,
                                          decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.grey),
                                        ),
                                    ]).reduce((a, b) => [...a, ...b]),
                          ),
                        ),
                      ],
                    ),
                    addVerticalSpace(10),
                    SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            description.isEmpty
                                ? 'No Description'
                                : description,
                            softWrap: true,
                            maxLines: 4,
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // addVerticalSpace(10),
                    Expanded(child: buttons)
                  ]))),
        ));
  }
}

class BannerImageText extends StatelessWidget {
  final String title;
  final List<String> genres;
  final Widget buttons;
  final String mediaType;
  final DateTime? releaseDate;
  final double averageScore;
  final String description;

  const BannerImageText(
      {super.key,
      required this.title,
      required this.mediaType,
      required this.genres,
      this.releaseDate,
      required this.buttons,
      required this.averageScore,
      required this.description});

  @override
  Widget build(BuildContext context) {
    // return ResponsiveBuilder(
    return _ForSmallScreens(
      genres: genres,
      title: title,
      releaseDate: releaseDate,
      mediaType: mediaType,
      score: averageScore,
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
  final List<String> genres;
  final String mediaType;
  final DateTime? releaseDate;
  final String description;
  final double score;
  final Widget buttons;
  const _ForSmallScreens(
      {required this.title,
      required this.mediaType,
      required this.genres,
      this.releaseDate,
      required this.score,
      required this.buttons,
      // required this.averageScore,
      required this.description});

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
              if (score < 0.0) ...[
                _getSmilyFace(score, 20),
                addHorizontalSpace(3)
              ],
              Text(
                score.toString(),
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              addHorizontalSpace(10),
              const Icon(
                Icons.tv_rounded,
                size: 20,
                color: Colors.grey,
              ),
              addHorizontalSpace(5),
              Text(
                mediaType.toUpperCase(),
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
              addHorizontalSpace(10),
              Text(
                releaseDate?.year.toString() ?? 'Unknown',
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          addVerticalSpace(10),
          Flexible(
            child: Wrap(
              // alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              // runSpacing: 10,
              spacing: 10,
              children: List.generate(
                  genres.length,
                  (index) => [
                        Text(
                          genres[index],
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        if (index != genres.length - 1)
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
          Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 10),
            child: Text(
              description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          buttons

          //   child: Align(
          //     alignment: Alignment.bottomCenter,
          //     child: SizedBox(
          //       height: 140,
          //       width: 300,
          //       child: Column(
          //         mainAxisAlignment: MainAxisAlignment.end,
          //         children: [
          //           DefaultTextStyle(
          //             style: const TextStyle(
          //               fontSize: 27,
          //             ),
          //             child: Text(
          //               title,
          //               style: const TextStyle(
          //                   fontSize: 20,
          //                   overflow: TextOverflow.ellipsis,
          //                   fontWeight: FontWeight.w700),
          //               textAlign: TextAlign.center,
          //               maxLines: 4,
          //             ),
          //           ),
          //           const SizedBox(
          //             height: 10,
          //           ),
          //           DefaultTextStyle(
          //             style: const TextStyle(
          //                 fontSize: 14, overflow: TextOverflow.ellipsis),
          //             child: Text(
          //               genres.join(' | '),
          //               style: const TextStyle(
          //                 fontSize: 14,
          //                 fontWeight: FontWeight.w400,
          //                 overflow: TextOverflow.ellipsis,
          //               ),
          //               textAlign: TextAlign.center,
          //               maxLines: 3,
          //             ),
          //           )
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          // buttons
        ],
      ),
    );
  }
}
