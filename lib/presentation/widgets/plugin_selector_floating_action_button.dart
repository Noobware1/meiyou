import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';
import 'package:meiyou/domain/entities/installed_plugin.dart';
import 'package:meiyou/presentation/blocs/get_installed_plugin_cubit.dart';
import 'package:meiyou/presentation/blocs/plugin_selector_cubit.dart';
import 'package:meiyou/presentation/widgets/installed_providers.dart';

class PluginFloatingActionButton extends StatelessWidget {
  final String heroTag;
  const PluginFloatingActionButton({super.key, required this.heroTag});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InstalledPluginCubit, List<InstalledPluginEntity>>(
        builder: (context, state) {
      return SizedBox(
        height: 55,
        child: BlocBuilder<PluginSelectorCubit, InstalledPluginEntity>(
          builder: (context, selectedPlugin) {
            return FloatingActionButton.extended(
                heroTag: heroTag,
                elevation: 10.0,
                icon: Icon(Icons.view_headline_rounded,
                    color:
                        context.theme.colorScheme.brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black),
                extendedPadding: const EdgeInsets.fromLTRB(15, 50, 15, 50),
                label: Text(selectedPlugin.name,
                    style: TextStyle(
                        color: context.theme.colorScheme.brightness ==
                                Brightness.dark
                            ? Colors.white
                            : Colors.black)),
                backgroundColor: context.theme.scaffoldBackgroundColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Scaffold(
                          body: ShowInstalledPlugins(
                        onSelected: (plugin) {
                          context
                              .bloc<PluginSelectorCubit>()
                              .selectPlugin(plugin);

                          context.pop(context);
                        },
                        plugin: selectedPlugin,
                        pluginList: state,
                      ));
                    },
                  );
                });
          },
        ),
      );
    });
  }
}
