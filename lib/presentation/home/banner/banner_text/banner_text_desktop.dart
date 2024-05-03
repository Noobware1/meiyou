part of banner_text;

class _BannerTextDesktop extends _BannerTextMobile {
  _BannerTextDesktop({super.key, required super.item});

  @override
  SizedBox get defaultSpace => const SizedBox(height: 10);

  @override
  TextStyle get commonTextStyle => super.commonTextStyle.copyWith(
        fontSize: DesktopFontSize.normal,
      );

  @override
  TextStyle get descriptionTextStyle => const TextStyle(
        fontSize: MobileFontSize.medium,
        fontWeight: FontWeight.w400,
      );

  @override
  EdgeInsets get defaultPadding => const EdgeInsets.fromLTRB(20, 10, 20, 20);

  @override
  double get smileSize => 25.0;

  @override
  Widget buildTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
          fontSize: DesktopFontSize.extraLarge,
          overflow: TextOverflow.ellipsis,
          fontWeight: FontWeight.w700),
      textAlign: TextAlign.start,
      maxLines: 4,
    );
  }
}
