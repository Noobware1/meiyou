import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meiyou/core/resources/platform_check.dart';
import 'package:meiyou/core/resources/snackbar.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';
import 'package:meiyou/core/utils/try_catch.dart';
import 'package:meiyou/domain/entities/installed_plugin.dart';
import 'package:meiyou/domain/entities/plugin_list.dart';
import 'package:meiyou/domain/usecases/plugin_manager_repository_usecases/get_outdated_plugins_usecase.dart';
import 'package:meiyou/presentation/providers/plugin_manager_repository_usecase_provider.dart';
import 'package:meiyou/presentation/widgets/add_space.dart';
import 'package:meiyou/presentation/widgets/plugins_widgets/plugin_widget.dart';
import 'package:meiyou_extensions_lib/meiyou_extensions_lib.dart';

class SourcesTab<T extends StateStreamable<List<InstalledPluginEntity>>>
    extends StatelessWidget {
  final Stream<List<InstalledPluginEntity>> stream;
  final List<PluginListEntity> allPlugins;

  const SourcesTab({
    super.key,
    required this.stream,
    required this.allPlugins,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<T, List<InstalledPluginEntity>>(
        builder: (context, installedPlugins) {
      if (installedPlugins.isNotEmpty) {
        final outdated = context
            .repository<PluginManagerRepositoryUseCases>()
            .getOutDatedPluginsUseCase(GetOutDatedPluginsUseCaseParams(
                installedPlugins: installedPlugins, pluginList: allPlugins));

        final filtered = separateOutDatedPlugins(outdated, installedPlugins);
        return ListView.builder(
          itemBuilder: (context, index) {
            if (outdated != null &&
                outdated.isNotEmpty &&
                index <= outdated.length) {
              if (index == 0) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    addVerticalSpace(10),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 15),
                      child: Row(
                        children: [
                          Text(
                            'Update Pending',
                            style: TextStyle(
                                fontSize: isMobile ? 15 : 18,
                                fontWeight: FontWeight.w500),
                          ),
                          Expanded(
                              child: Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  alignment: Alignment.centerLeft,
                                  padding: const MaterialStatePropertyAll(
                                      EdgeInsets.all(15)),
                                  overlayColor: MaterialStatePropertyAll(context
                                      .theme.colorScheme.surface
                                      .withOpacity(0.2)),
                                  iconSize: const MaterialStatePropertyAll(30),
                                  shape: MaterialStatePropertyAll(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(45)))),
                              onPressed: () {
                                _onUpdateAll(outdated, context);
                              },
                              child: Text(
                                'Update all',
                                style: TextStyle(
                                  color: context.theme.colorScheme.onSurface,
                                ),
                              ),
                            ),
                          ))
                        ],
                      ),
                    ),
                    PluginWidget(
                        plugin: outdated.values.elementAt(index),
                        onTap: () async {
                          await _onUpdate(
                              outdated.values.elementAt(index), context);
                        },
                        version:
                            'New! v${outdated.values.elementAt(index).version}',
                        buttonText: 'Update'),
                  ],
                );
              }
              return PluginWidget(
                  plugin: outdated.values.elementAt(index),
                  onTap: () async {
                    await _onUpdate(outdated.values.elementAt(index), context);
                  },
                  buttonText: 'Update');
            } else {
              return PluginWidget(
                  showChanges: false,
                  plugin: filtered[index],
                  onTap: () async {
                    await _onUninstall(filtered[index], context);
                  },
                  buttonText: 'Uninstall');
            }
          },
          itemCount: (outdated?.length ?? 0) + filtered.length,
        );
      }
      return const Center(
        child: Text('Please install a plugin to enjoy :)'),
      );
    });
  }

  Future<void> _onUpdate(OnlinePlugin plugin, BuildContext context) async {
    await tryAsync(
        () => context
            .repository<PluginManagerRepositoryUseCases>()
            .updatePluginUseCase(plugin),
        onError: (e, s) => showSnackBar(context, text: e.toString()));
  }

  Future<void> _onUpdateAll(
      Map<InstalledPluginEntity, OnlinePlugin> outdatedPlugins,
      BuildContext context) async {
    for (var e in outdatedPlugins.values) {
      await tryAsync(
          () => context
              .repository<PluginManagerRepositoryUseCases>()
              .updatePluginUseCase(e),
          onError: (e, s) => showSnackBar(context, text: e.toString()));
    }
  }

  Future<void> _onUninstall(
      InstalledPluginEntity plugin, BuildContext context) async {
    await tryAsync(
        () => context
            .repository<PluginManagerRepositoryUseCases>()
            .uninstallPluginUseCase(plugin),
        onError: (e, s) => showSnackBar(context, text: e.toString()));
  }

  List<InstalledPluginEntity> separateOutDatedPlugins(
      Map<InstalledPluginEntity, OnlinePlugin>? outdated,
      List<InstalledPluginEntity> installed) {
    if (outdated == null) return installed;
    final filtered = <InstalledPluginEntity>[];
    for (var i = 0; i < outdated.keys.length; i++) {
      for (var l = 0; l < installed.length; l++) {
        if (outdated.keys.elementAt(i).id != installed[l].id) {
          filtered.add(installed[l]);
        }
      }
    }
    return filtered;
  }
}
