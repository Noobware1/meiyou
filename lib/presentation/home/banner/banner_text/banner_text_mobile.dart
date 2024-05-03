part of banner_text;

class _BannerTextMobile extends BannerText {
  _BannerTextMobile({super.key, required super.item});

  SizedBox get defaultSpace => const SizedBox(height: 5);

  TextStyle get commonTextStyle => const TextStyle(
      fontSize: MobileFontSize.normal, fontWeight: FontWeight.w500);

  TextStyle get descriptionTextStyle => const TextStyle(
      fontSize: MobileFontSize.semiMedium, fontWeight: FontWeight.w400);

  EdgeInsets get defaultPadding => const EdgeInsets.fromLTRB(20, 10, 20, 10);

  double get smileSize => 20.0;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: defaultPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildTitle(title),
          defaultSpace,
          Row(
            children: [
              if (rating != null) ...buildRating(rating!),
              ...buildType(type),
            ],
          ),
          if (genres != null) ...[defaultSpace, buildGenres(genres!)],
          defaultSpace,
          if (description != null) buildDescription(description!)
        ],
      ),
    );
  }

  @override
  Widget buildTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
          fontSize: MobileFontSize.large,
          overflow: TextOverflow.ellipsis,
          fontWeight: FontWeight.w700),
      textAlign: TextAlign.start,
      maxLines: 2,
    );
  }

  @override
  List<Widget> buildType(String type) {
    return [
      const Icon(
        Icons.tv_rounded,
        color: Colors.grey,
      ),
      const HorizontalSpace(5),
      Text(
        type,
        style: commonTextStyle,
      )
    ];
  }

  @override
  List<Widget> buildRating(double rating) {
    return [
      SmilyFace(score: rating, size: smileSize),
      const HorizontalSpace(3),
      Text(
        rating.toString(),
        style: commonTextStyle,
      ),
      const HorizontalSpace(10),
    ];
  }

  @override
  Widget buildDescription(String description) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Text(
        description,
        style: descriptionTextStyle,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  @override
  Widget buildGenres(List<String> genres) {
    return Flexible(
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 10,
        children: List.generate(
            genres.length,
            (index) => [
                  Text(
                    genres[index],
                    style: commonTextStyle,
                  ),
                  if (index < genres.lastIndex)
                    Container(
                      height: 4,
                      width: 4,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.grey),
                    ),
                ]).flatten(),
      ),
    );
  }
}
