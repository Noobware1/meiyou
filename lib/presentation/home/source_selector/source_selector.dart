import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:meiyou/core/utils/extensions/context.dart';
import 'package:meiyou/core/utils/resources/get_it/get_it.dart';
import 'package:meiyou/core/utils/resources/screen_size.dart';
import 'package:meiyou/extension/models/entension_type.dart';
import 'package:meiyou/domain/models/source.dart' hide Source;
import 'package:meiyou/domain/source/source_preferences.dart';
import 'package:meiyou/presentation/home/source_selector/extensions/tabs/install_extension_tab.dart';
import 'package:meiyou/core/constants/font_size.dart';
import 'package:meiyou/core/utils/resources/platform.dart';
import 'package:meiyou/presentation/home/source_selector/extensions/tabs/available_extension_tab.dart';

typedef OnSourceSelected = void Function(
    ExtensionType type, InstalledSource source);

class SourceSelector extends StatelessWidget {
  final OnSourceSelected _onSourceSelected;
  const SourceSelector({super.key, required OnSourceSelected onSourceSelected})
      : _onSourceSelected = onSourceSelected;

  static Future showBottomSheet(
    BuildContext context,
    OnSourceSelected onSourceSelected,
  ) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      useSafeArea: true,
      builder: (context) {
        return SourceSelector(onSourceSelected: (type, source) {
          SourceSelector.onSourceSelected(context, type, source);
          onSourceSelected(type, source);
        });
      },
    );
  }

  static void onSourceSelected(
      BuildContext context, ExtensionType type, InstalledSource source) {
    final sourcePreferences = getIt.get<SourcePreferences>();
    if (sourcePreferences.lastUsedSourceByType(type).get() == source.id) {
      return;
    }
    sourcePreferences.lastUsedSourceByType(type).set(source.id);
    context.pop();
  }

  static const margin = EdgeInsets.only(top: 30);

  static const boderRadius = BorderRadius.only(
    topLeft: Radius.circular(25),
    topRight: Radius.circular(25),
  );

  static const tabBarSize = Size.fromHeight(50);

  static const tabBarPadding = EdgeInsets.only(top: 20);

  static const tabBarViewPadding = EdgeInsets.only(top: 20);

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final isMobile = context.screenSize.isMobile;
    final textTheme = theme.textTheme;

    // final titleTextStyle = textTheme.titleLarge;
    final textStyle = isMobile ? textTheme.titleMedium : textTheme.titleLarge;

    return DefaultTabController(
      length: 6,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          tabBar(context, textStyle: textStyle!),
          Expanded(
            child: Theme(
              data: theme.copyWith(
                listTileTheme: theme.listTileTheme.copyWith(
                  iconColor: theme.colorScheme.onSurface,
                ),
              ),
              child: Padding(
                padding: tabBarViewPadding,
                child: TabBarView(
                  children: tabViews(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget tabBar(
    BuildContext context, {
    required TextStyle textStyle,
  }) {
    return TabBar(
      tabAlignment: TabAlignment.start,
      indicatorColor: context.theme.colorScheme.primary,
      indicatorSize: TabBarIndicatorSize.label,
      indicatorWeight: 3,
      labelColor: context.theme.colorScheme.primary,
      unselectedLabelColor: Colors.grey,
      padding: tabBarPadding,
      dividerColor: Colors.grey,
      isScrollable: true,
      tabs: tabs(
        textStyle: textStyle,
      ),
    );
  }

  List<Tab> tabs({
    required TextStyle textStyle,
  }) {
    return [
      tab(
        'Video Sources',
        style: textStyle,
      ),
      tab(
        'Manga Sources',
        style: textStyle,
      ),
      tab(
        'Novel Sources',
        style: textStyle,
      ),
      tab(
        'Video Extensions',
        style: textStyle,
      ),
      tab(
        'Manga Extensions',
        style: textStyle,
      ),
      tab(
        'Novel Extensions',
        style: textStyle,
      ),
    ];
  }

  List<Widget> tabViews() {
    return [
      InstalledExtensionTab(
        type: ExtensionType.Video,
        onSourceSelected: (source) {
          _onSourceSelected(ExtensionType.Video, source);
        },
      ),
      InstalledExtensionTab(
        type: ExtensionType.Manga,
        onSourceSelected: (source) {
          _onSourceSelected(ExtensionType.Video, source);
        },
      ),
      InstalledExtensionTab(
        type: ExtensionType.Novel,
        onSourceSelected: (source) {
          _onSourceSelected(ExtensionType.Video, source);
        },
      ),
      const AvailableExtensionTab(
        type: ExtensionType.Video,
      ),
      const AvailableExtensionTab(
        type: ExtensionType.Manga,
      ),
      const AvailableExtensionTab(
        type: ExtensionType.Novel,
      ),
    ];
  }

  Tab tab(String name, {required TextStyle style}) {
    return Tab(
      child: Text(
        name,
        style: style,
      ),
    );
  }
}
