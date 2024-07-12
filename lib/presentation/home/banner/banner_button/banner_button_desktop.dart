part of banner_button;

class _BannerButtonDesktop extends _BannerButtonMobile {
  const _BannerButtonDesktop(
      {super.key,
      required super.isInLibrary,
      required super.onItemSelected,
      required super.onAddToList});

  @override
  double get defaultSpace => 20.0;

  @override
  Size get mainButtonSize => const Size(150, 40);

  @override
  Size get addToListbuttonSize => const Size(130, 40);
}
