import 'dart:io';
import 'package:flutter/material.dart';
import 'package:meiyou/core/constants/assets.dart';
import 'package:meiyou/core/resources/platform_check.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';
import 'package:meiyou/domain/entities/installed_plugin.dart';
import 'package:meiyou/presentation/widgets/add_space.dart';

class ShowInstalledPlugins extends StatelessWidget {
  final InstalledPluginEntity plugin;
  final List<InstalledPluginEntity>? pluginList;
  final void Function(InstalledPluginEntity plugin) onSelected;
  const ShowInstalledPlugins({
    super.key,
    required this.plugin,
    this.pluginList,
    required this.onSelected,
  });

  static const _textStyle =
      TextStyle(fontWeight: FontWeight.w600, fontSize: 18);

  static const _textStyleMobile =
      TextStyle(fontWeight: FontWeight.w600, fontSize: 16.5);

  static const _doneIcon = SizedBox(
    width: 50,
    child: Icon(
      Icons.done,
      size: 35,
    ),
  );
  static const _replacement = SizedBox(
    width: 50,
  );

  static const _doneIconMobile = SizedBox(
    width: 35,
    child: Icon(
      Icons.done,
      size: 30,
    ),
  );
  static const _replacementMobile = SizedBox(
    width: 30,
  );
  void _onTap(
    BuildContext context,
    int index,
  ) {
    if (index == -1) {
      onSelected(InstalledPluginEntity.none);
    } else if (pluginList != null &&
        pluginList!.length >= (index - 1) &&
        pluginList![index] != plugin) {
      onSelected(pluginList![index]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final icon = isMobile ? _doneIconMobile : _doneIcon;
    const height = 50.0;
    final replacement = isMobile ? _replacementMobile : _replacement;
    final textStyle = isMobile ? _textStyleMobile : _textStyle;
    final unselectedTextStyle = textStyle.copyWith(
      color: context.theme.colorScheme.onSurface.withOpacity(0.7),
    );
    return SizedBox(
      height: context.screenHeight / 1.3,
      child: ListView.separated(
          separatorBuilder: (context, index) => addVerticalSpace(8),
          itemCount: pluginList!.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Material(
                color: Colors.transparent,
                type: MaterialType.button,
                child: InkWell(
                  onTap: () => _onTap(context, -1),
                  child: SizedBox(
                      height: height,
                      child: Row(children: [
                        addHorizontalSpace(10),
                        if (plugin == InstalledPluginEntity.none)
                          icon
                        else
                          replacement,
                        addHorizontalSpace(10),
                        Text(
                          'None',
                          style: plugin == InstalledPluginEntity.none
                              ? textStyle
                              : unselectedTextStyle,
                        ),
                      ])),
                ),
              );
            }
            final i = index - 1;

            return Material(
              color: Colors.transparent,
              type: MaterialType.button,
              child: InkWell(
                onTap: () => _onTap(context, i),
                child: SizedBox(
                  height: height,
                  child: Row(
                    children: [
                      addHorizontalSpace(10),
                      if (pluginList![i].id == plugin.id) icon else replacement,
                      addHorizontalSpace(10),
                      Image.file(File(pluginList![i].iconPath),
                          height: 40,
                          width: 40,
                          fit: BoxFit.fill, errorBuilder: (context, e, s) {
                        return Image.asset(
                          defaultposterImage,
                          height: height,
                          width: height,
                          fit: BoxFit.fill,
                        );
                      }),
                      addHorizontalSpace(10),
                      Text(
                        pluginList![i].name,
                        style: pluginList![i].id == plugin.id
                            ? textStyle
                            : unselectedTextStyle,
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
