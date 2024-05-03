part of more;

class _MoreScreenDesktop extends _MoreScreenMobile {
  const _MoreScreenDesktop({super.key});

  @override
  double get minLeadingWidth => 40.0;

  @override
  EdgeInsets get contentPadding => const EdgeInsets.only(
        right: 20.0,
        left: 20.0,
      );

  @override
  TextStyle get titleTextStyle => const TextStyle(
        fontSize: DesktopFontSize.medium,
        fontWeight: FontWeight.w400,
      );

  @override
  TextStyle get subtitleTextStyle => const TextStyle(
        fontSize: DesktopFontSize.small,
        fontWeight: FontWeight.w400,
      );
}
