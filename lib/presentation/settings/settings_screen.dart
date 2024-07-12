import 'package:flutter/material.dart';
import 'package:meiyou/core/config/routes/routes.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          tile(
            leading: Icons.color_lens_outlined,
            title: 'Appearance',
            subtitle: 'Theme, date & time, format',
            onTap: () => context.goToApperanceSettings(),
          ),
          tile(
            leading: Icons.collections_bookmark_outlined,
            title: 'Library',
            subtitle: 'Categories, global update, episode/chapter swipe',
            onTap: () {
              context.goToLibrarySettings();
            },
          ),
          tile(
            leading: Icons.play_circle_outline,
            title: 'Player',
            subtitle: 'Progress control, gestures,',
            onTap: () {},
          ),
          tile(
            leading: Icons.menu_book_outlined,
            title: 'Reader',
            subtitle: 'Reading mode, display, navigation',
            onTap: () {},
          ),
          tile(
            leading: Icons.explore_outlined,
            title: 'Browse',
            subtitle: 'Sources, extensions, global search',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget tile({
    required String title,
    required String subtitle,
    required IconData leading,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Icon(leading),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      onTap: onTap,
    );
  }
}
