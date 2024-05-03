part of banner_button;

class _BannerButtonMobile extends BannerButton {
  const _BannerButtonMobile(
      {super.key, required super.onItemSelected, required super.onAddToList});

  double get defaultPadding => 20.0;
  double get iconSize => 25.0;

  double get defaultSpace => 10.0;

  Size get mainButtonSize => const Size(150, 30);

  Size get addToListbuttonSize => const Size(120, 30);

  static const borderRadius = BorderRadius.all(Radius.circular(45));

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: defaultPadding, right: defaultPadding),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          buildMainButton(context),
          SizedBox(width: defaultSpace),
          buildAddToListButton(context),
        ],
      ),
    );
  }

  ButtonStyle addToListButtonStyle(BuildContext context) {
    return ButtonStyle(
      fixedSize: MaterialStatePropertyAll(addToListbuttonSize),
      iconSize: MaterialStatePropertyAll(iconSize),
      backgroundColor: MaterialStatePropertyAll(backgroundColor(context)),
      overlayColor: MaterialStatePropertyAll(overlayColor(context)),
      shape: const MaterialStatePropertyAll(
        RoundedRectangleBorder(borderRadius: borderRadius),
      ),
    );
  }

  @override
  Widget buildAddToListButton(BuildContext context) {
    final baseColor = addToListTextIconColor(context);
    return Flexible(
      child: ElevatedButton.icon(
        onPressed: onAddToList,
        icon: addToListIcon(baseColor),
        label: addToListLabel(baseColor),
        style: addToListButtonStyle(context),
      ),
    );
  }

  ButtonStyle mainButtonStyle(BuildContext context) {
    return ButtonStyle(
        fixedSize: MaterialStatePropertyAll(mainButtonSize),
        alignment: Alignment.centerLeft,
        backgroundColor:
            MaterialStatePropertyAll(context.theme.colorScheme.primary),
        overlayColor: MaterialStatePropertyAll(overlayColor(context)),
        iconSize: MaterialStatePropertyAll(iconSize),
        shape: const MaterialStatePropertyAll(
            RoundedRectangleBorder(borderRadius: borderRadius)));
  }

  @override
  Widget buildMainButton(BuildContext context) {
    final baseColor = mainButtonTextIconColor(context);

    return Flexible(
      child: ElevatedButton.icon(
        style: mainButtonStyle(context),
        onPressed: onItemSelected,
        icon: mainButtonIcon(baseColor),
        label: mainButtonLabel(baseColor),
      ),
    );
  }
}
