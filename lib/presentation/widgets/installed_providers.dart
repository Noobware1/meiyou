import 'dart:io';
import 'package:flutter/material.dart';
import 'package:meiyou/core/resources/platform_check.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';
import 'package:meiyou/domain/entities/installed_plugin.dart';
import 'package:meiyou/presentation/blocs/plugin_selector_cubit.dart';
import 'package:meiyou/presentation/providers/plugin_manager_repository_usecase_provider.dart';
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
    final height = isMobile ? 50.0 : 50.0;
    final replacement = isMobile ? _replacementMobile : _replacement;
    final textStyle = isMobile ? _textStyleMobile : _textStyle;
    return SizedBox(
      height: context.screenHeight / 1.3,
      child: ListView(
        children: [
          Material(
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
                      style: textStyle,
                    ),
                  ])),
            ),
          ),
          if (pluginList != null)
            for (var i = 0; i < pluginList!.length; i++)
              Material(
                color: Colors.transparent,
                type: MaterialType.button,
                child: InkWell(
                  onTap: () => _onTap(context, i),
                  child: SizedBox(
                    height: height,
                    child: Row(
                      children: [
                        addHorizontalSpace(10),
                        if (pluginList![i].name == plugin.name)
                          icon
                        else
                          replacement,
                        addHorizontalSpace(10),
                        Image.file(File(pluginList![i].iconPath),
                            height: height,
                            width: height,
                            fit: BoxFit.fill, errorBuilder: (context, e, s) {
                          return Image.asset(
                            'assets/images/default-poster.jpg',
                            height: height,
                            width: height,
                            fit: BoxFit.fill,
                          );
                        }),
                        addHorizontalSpace(10),
                        Text(
                          pluginList![i].name,
                          style: textStyle,
                        )
                      ],
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
