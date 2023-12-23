import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meiyou/core/resources/platform_check.dart';
import 'package:meiyou/core/resources/snackbar.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';
import 'package:meiyou/domain/entities/installed_plugin.dart';
import 'package:meiyou/domain/entities/plugin_list.dart';
import 'package:meiyou/presentation/blocs/async_cubit/async_cubit.dart';
import 'package:meiyou/presentation/blocs/get_installed_plugin_cubit.dart';
import 'package:meiyou/presentation/blocs/plugin_page_cubit.dart';
import 'package:meiyou/presentation/providers/plugin_manager_repository_usecase_provider.dart';
import 'package:meiyou/presentation/widgets/emoticons_widget.dart';
import 'package:meiyou/presentation/widgets/plugins_widgets/extensions_tab.dart';
import 'package:meiyou/presentation/widgets/plugins_widgets/sources_tab.dart';
import 'package:meiyou_extensions_lib/extenstions.dart';

class PluginsPage extends StatefulWidget {
  const PluginsPage({super.key});

  @override
  State<PluginsPage> createState() => _PluginsPageState();
}

class _PluginsPageState extends State<PluginsPage> {
  late final PluginPageCubit _pluginPageCubit;
  final List<Stream<List<InstalledPluginEntity>>> _installedPluginStreams = [];

  @override
  void initState() {
    _pluginPageCubit = PluginPageCubit(context
        .repository<PluginManagerRepositoryUseCases>()
        .getAllPluginsUseCase)
      ..getAllPlugins();

    _installedPluginStreams.addAll([
      context
          .repository<PluginManagerRepositoryUseCases>()
          .getInstalledPluginsUseCase('Video'),
    ]);

    super.initState();
  }

  static const _textStyle =
      TextStyle(fontWeight: FontWeight.w600, fontSize: 18);

  static const _textStyleMobile =
      TextStyle(fontWeight: FontWeight.w600, fontSize: 15);

  @override
  Widget build(BuildContext context) {
    final textStyle = isMobile ? _textStyleMobile : _textStyle;

    return BlocConsumer<PluginPageCubit, AsyncState<List<PluginListEntity>>>(
      bloc: _pluginPageCubit,
      builder: (context, state) {
        return DefaultTabController(
          length: 3 + 1,
          child: Scaffold(
            appBar: AppBar(
                title: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Extenstions',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ),
                bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(50),
                    child: Stack(alignment: Alignment.bottomCenter, children: [
                      const Divider(
                        height: 2,
                        thickness: 2,
                      ),
                      TabBar(
                          indicatorColor: context.theme.colorScheme.primary,
                          indicatorSize: TabBarIndicatorSize.label,
                          indicatorWeight: 3,
                          labelColor: context.theme.colorScheme.primary,
                          unselectedLabelColor: Colors.grey,
                          padding: const EdgeInsets.only(left: 20),
                          dividerColor: Colors.grey,
                          isScrollable: true,
                          tabs: [
                            Tab(
                              child: Text(
                                'Video Sources',
                                style: textStyle,
                              ),
                            ),
                            Tab(
                              child: Text(
                                'Video Extensions',
                                style: textStyle,
                              ),
                            ),
                            Tab(
                              child: Text(
                                'Manga Extensions',
                                style: textStyle,
                              ),
                            ),
                            Tab(
                              child: Text(
                                'Novel Extensions',
                                style: textStyle,
                              ),
                            ),
                          ]),
                    ]))),
            body: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: TabBarView(children: [
                SourcesTab<InstalledVideoPluginCubit>(
                  stream: _installedPluginStreams[0],
                  allPlugins: state.data ?? [],
                ),
                if (state.data.isNotNullAndEmpty) ...[
                  ExtensionsTab<InstalledVideoPluginCubit>(
                    pluginList: state.data![0],
                  ),
                  ExtensionsTab<InstalledVideoPluginCubit>(
                    pluginList: state.data![1],
                  ),
                  ExtensionsTab<InstalledVideoPluginCubit>(
                    pluginList: state.data![2],
                  )
                ] else
                  ...List.generate(
                      3,
                      (i) => const Center(
                              child: EmoticonsWidget(
                            emoticon: '(◕︿◕✿)',
                            text: 'Failed to load plugin list',
                          ))),
              ]),
            ),
          ),
        );
      },
      listener: (context, state) {
        if (state is AsyncStateFailed) {
          showSnackBar(context, text: state.error!.message);
        }
      },
    );
  }

  @override
  void dispose() {
    _pluginPageCubit.close();
    super.dispose();
  }
}
