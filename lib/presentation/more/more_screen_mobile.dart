part of more;

class _MoreScreenMobile extends MoreScreen {
  const _MoreScreenMobile({super.key});

  Divider get divider => const Divider(
        endIndent: 0,
        indent: 0,
      );

  SizedBox get verticalSpace => const SizedBox(height: 50.0);

  @override
  Widget build(BuildContext context) {
    // TabBar
    return Scaffold(
        body: ListView(
      children: [
        verticalSpace,
        const FlutterLogo(
          size: 100,
        ),
        verticalSpace,
        divider,
        buildListTitleWithSwitch(
            context: context,
            title: 'Downloaded only',
            icon: Icons.cloud_off_outlined,
            onChanged: (value) {},
            switchValue: false,
            subtitleText: 'Filters all entries in your library'),
        buildListTitleWithSwitch(
          context: context,
          title: 'Incognito only',
          icon: CupertinoIcons.eyeglasses,
          onChanged: (value) {},
          switchValue: false,
          subtitleText: 'Pauses watching/reading history',
        ),
        divider,
        buildListTitle(
          context: context,
          title: 'Download queue',
          icon: Icons.download_outlined,
          onTap: () {},
        ),
        buildListTitle(
          context: context,
          title: 'Categories',
          icon: Icons.install_desktop,
          onTap: () {},
        ),
        buildListTitle(
          context: context,
          title: 'Data and Storage',
          icon: Icons.data_usage,
          onTap: () {
            context.goToStorageScreen();
          },
        ),
        divider,
        buildListTitle(
          context: context,
          title: 'Settings',
          icon: Icons.settings_outlined,
          onTap: () {
            context.goToSettingsScreen();
          },
        ),
        buildListTitle(
          context: context,
          title: 'About',
          icon: Icons.info_outlined,
          onTap: () {},
        ),
        buildListTitle(
          context: context,
          title: 'Help',
          icon: Icons.help_outline,
          onTap: () {},
        ),
      ],
    ));
  }

  double get minLeadingWidth => 40.0;

  EdgeInsets get contentPadding => const EdgeInsets.only(
        right: 16.0,
        left: 16.0,
      );

  TextStyle get titleTextStyle => const TextStyle(
        fontSize: MobileFontSize.medium,
        fontWeight: FontWeight.w400,
      );

  TextStyle get subtitleTextStyle => const TextStyle(
        fontSize: MobileFontSize.small,
        fontWeight: FontWeight.w400,
      );

  Widget buildListTitleWithSwitch(
      {required BuildContext context,
      required String title,
      required IconData icon,
      String? subtitleText,
      required bool switchValue,
      required Function(bool) onChanged}) {
    return buildListTitle(
      context: context,
      title: title,
      icon: icon,
      onTap: () => onChanged(!switchValue),
      subtitleText: subtitleText,
      trailing: IgnorePointer(
        child: Switch.adaptive(
          value: switchValue,
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget buildListTitle({
    required BuildContext context,
    required String title,
    required IconData icon,
    Widget? trailing,
    String? subtitleText,
    required Function() onTap,
  }) {
    return ListTile(
      minLeadingWidth: minLeadingWidth,
      contentPadding: contentPadding,
      trailing: trailing,
      subtitle: subtitleText == null
          ? null
          : Text(subtitleText, style: subtitleTextStyle),
      title: Text(title, style: titleTextStyle),
      leading: Icon(icon),
      enabled: true,
      onTap: onTap,
    );
  }
}
