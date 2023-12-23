import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meiyou/core/resources/snackbar.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';
import 'package:meiyou/core/utils/extenstions/list.dart';
import 'package:meiyou/core/utils/try_catch.dart';
import 'package:meiyou/domain/entities/installed_plugin.dart';
import 'package:meiyou/domain/entities/plugin_list.dart';
import 'package:meiyou/presentation/pages/plugins_page.dart';
import 'package:meiyou/presentation/providers/plugin_manager_repository_usecase_provider.dart';
import 'package:meiyou/presentation/widgets/emoticons_widget.dart';
import 'package:meiyou/presentation/widgets/plugins_widgets/plugin_widget.dart';
import 'package:meiyou_extensions_lib/models.dart';

class ExtensionsTab<T extends StateStreamable<List<InstalledPluginEntity>>>
    extends StatelessWidget {
  final PluginListEntity pluginList;

  const ExtensionsTab({
    super.key,
    required this.pluginList,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<T, List<InstalledPluginEntity>>(
        builder: (context, installedPlugins) {
      final filtered = removeInstalled(installedPlugins, pluginList.plugins);
      if (filtered.isEmpty) {
        return const Center(
            child: EmoticonsWidget(
          emoticon: '(◕︿◕✿)',
          text: 'Awww no plugins found :(',
        ));
      }
      return ListView.builder(
        itemBuilder: (context, index) {
          return PluginWidget(
              plugin: filtered[index],
              onTap: () async {
                await _onInstall(filtered[index], context);
              },
              buttonText: 'Install');
        },
        itemCount: filtered.length,
      );
    });
  }

  List<OnlinePlugin> removeInstalled(
      List<InstalledPluginEntity>? installed, List<OnlinePlugin> plugins) {
    if (installed == null || installed.isEmpty) return plugins;

    final ids = installed.map((e) => e.id);

    return plugins.whereAsList((e) => !ids.contains(e.id));
  }

  Future<void> _onInstall(OnlinePlugin plugin, BuildContext context) async {
    await tryAsync(
        () => context
            .repository<PluginManagerRepositoryUseCases>()
            .installPluginUseCase(plugin),
        onError: (e, s) => showSnackBar(context, text: e.toString()),
        log: true); //   .then((value) {
  }
}
