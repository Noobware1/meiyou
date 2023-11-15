import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';
import 'package:meiyou/core/utils/extenstions/iterable.dart';
import 'package:meiyou/domain/entities/plugin.dart';
import 'package:meiyou/domain/entities/plugin_list.dart';
import 'package:meiyou/presentation/blocs/get_installed_plugins.dart';
import 'package:meiyou/presentation/widgets/add_space.dart';

class ShowInstalledPlugins extends StatelessWidget {
  final PluginEntity plugin;
  final List<PluginEntity>? pluginList;
  final void Function(PluginEntity plugin) onSelected;
  const ShowInstalledPlugins({
    super.key,
    required this.plugin,
    this.pluginList,
    required this.onSelected,
  });

  static const _textStyle =
      TextStyle(fontWeight: FontWeight.w600, fontSize: 18);

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

  void _onTap(
    BuildContext context,
    int index,
  ) {
    if (index == -1) {
      onSelected(PluginEntity.none);
    } else if (pluginList != null &&
        pluginList!.length >= (index - 1) &&
        pluginList![index] != plugin) {
      onSelected(pluginList![index]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.screenHeight / 1.3,
      child: ListView(
        children: [
          Material(
            child: InkWell(
              onTap: () => _onTap(context, -1),
              child: SizedBox(
                  height: 50,
                  child: Row(children: [
                    if (plugin == PluginEntity.none)
                      _doneIcon
                    else
                      _replacement,
                    addHorizontalSpace(10),
                    const Text(
                      'None',
                      style: _textStyle,
                    ),
                  ])),
            ),
          ),
          if (pluginList != null)
            for (var i = 0; i < pluginList!.length; i++)
              Material(
                child: InkWell(
                  onTap: () => _onTap(context, i),
                  child: SizedBox(
                    height: 50,
                    child: Row(
                      children: [
                        if (pluginList![i].name == plugin.name)
                          _doneIcon
                        else
                          _replacement,
                        addHorizontalSpace(10),
                        Image.file(File(pluginList![i].icon ?? ''),
                            height: 50,
                            width: 50,
                            fit: BoxFit.fill, errorBuilder: (context, e, s) {
                          return Image.asset(
                            'assets/images/default-poster.jpg',
                            height: 50,
                            width: 50,
                            fit: BoxFit.fill,
                          );
                        }),
                        addHorizontalSpace(20),
                        Text(
                          pluginList![i].name,
                          style: _textStyle,
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
