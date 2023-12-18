import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meiyou/core/resources/platform_check.dart';
import 'package:meiyou/core/resources/snackbar.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';
import 'package:meiyou/core/utils/extenstions/list.dart';
import 'package:meiyou/core/utils/try_catch.dart';
import 'package:meiyou/domain/entities/installed_plugin.dart';
import 'package:meiyou/domain/entities/plugin_list.dart';
import 'package:meiyou/domain/usecases/plugin_manager_repository_usecases/get_outdated_plugins_usecase.dart';
import 'package:meiyou/presentation/blocs/async_cubit/async_cubit.dart';
import 'package:meiyou/presentation/blocs/plugin_page_cubit.dart';
import 'package:meiyou/presentation/emoticons_widget.dart';
import 'package:meiyou/presentation/providers/plugin_manager_repository_usecase_provider.dart';
import 'package:meiyou/presentation/widgets/add_space.dart';
import 'package:meiyou/presentation/widgets/error_widget.dart';
import 'package:meiyou_extensions_lib/extenstions.dart';
import 'package:meiyou_extensions_lib/meiyou_extensions_lib.dart';

const _defaultPadding = EdgeInsets.fromLTRB(20, 10, 20, 10);

class PluginWidget<P> extends StatefulWidget {
  final P plugin;
  final AsyncCallback onTap;
  final String? version;
  final String buttonText;
  final bool showChanges;
  final AsyncCallback? onCancel;
  const PluginWidget(
      {super.key,
      required this.plugin,
      required this.onTap,
      required this.buttonText,
      this.version,
      this.showChanges = true,
      this.onCancel});

  static const _textStyle =
      TextStyle(fontWeight: FontWeight.w600, fontSize: 18);

  static const _textStyleMobile =
      TextStyle(fontWeight: FontWeight.w600, fontSize: 15);

  @override
  State<PluginWidget> createState() => _PluginWidgetState();
}

class _PluginWidgetState extends State<PluginWidget> {
  Widget _defaultAssestImage() {
    return Image.asset(
      'assets/images/default-poster.jpg',
      height: 50,
      width: 50,
      fit: BoxFit.fill,
    );
  }

  Widget _buildImage(String? icon) {
    if (icon == null) return _defaultAssestImage();
    if (icon.startsWith('http')) {
      return CachedNetworkImage(
          imageUrl: icon,
          height: 50,
          width: 50,
          fit: BoxFit.fill,
          errorWidget: (context, e, s) {
            print('$e\n$s');
            return _defaultAssestImage();
          });
    } else {
      return Image.file(
        File(icon),
        height: 50,
        width: 50,
        fit: BoxFit.fill,
        errorBuilder: (context, error, stackTrace) => _defaultAssestImage(),
      );
    }
  }

  bool showChanges = false;

  @override
  Widget build(BuildContext context) {
    final textStyle =
        isMobile ? PluginWidget._textStyleMobile : PluginWidget._textStyle;
    return Padding(
      padding: _defaultPadding,
      child: Row(
        children: [
          _buildImage(widget.plugin is OnlinePlugin
              ? (widget.plugin as OnlinePlugin).iconUrl
              : (widget.plugin as InstalledPluginEntity).iconPath),
          addHorizontalSpace(20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.plugin.name,
                style: textStyle,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    (widget.plugin is OnlinePlugin
                            ? (widget.plugin as OnlinePlugin).lang
                            : (widget.plugin as InstalledPluginEntity).lang)
                        .toUpperCaseFirst(),
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w400),
                  ),
                  addHorizontalSpace(5),
                  Text(
                    widget.version ??
                        'v${widget.plugin is OnlinePlugin ? (widget.plugin as OnlinePlugin).version : (widget.plugin as InstalledPluginEntity).version}',
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ],
          ),
          Expanded(
              child: Align(
                  alignment: Alignment.centerRight,
                  child: widget.showChanges && showChanges
                      ? const Stack(alignment: Alignment.center, children: [
                          Icon(Icons.arrow_downward_rounded),
                          CircularProgressIndicator(),
                        ])
                      : InkWell(
                          borderRadius: BorderRadius.circular(15),
                          splashColor: context.theme.colorScheme.primary,
                          onTap: () {
                            if (widget.showChanges) {
                              setState(() => showChanges = true);
                              widget.onTap().then((value) =>
                                  setState(() => showChanges = false));
                            } else {
                              widget.onTap();
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(widget.buttonText,
                                style: textStyle.copyWith(
                                  color: context.theme.colorScheme.primary,
                                )),
                          ),
                        ))),
        ],
      ),
    );
  }
}

class _InstalledPluginListView extends StatelessWidget {
  final AsyncSnapshot<List<InstalledPluginEntity>> snapshot;
  final List<PluginListEntity> allPlugins;

  const _InstalledPluginListView({
    required this.snapshot,
    required this.allPlugins,
  });

  @override
  Widget build(BuildContext context) {
    if (snapshot.hasData && snapshot.data!.isNotEmpty) {
      final outdated = context
          .repository<PluginManagerRepositoryUseCases>()
          .getOutDatedPluginsUseCase(GetOutDatedPluginsUseCaseParams(
              installedPlugins: snapshot.data!, pluginList: allPlugins));

      final filtered = separateOutDatedPlugins(outdated, snapshot.data!);
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
                    padding: _defaultPadding,
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

class _BuildPluginList extends StatelessWidget {
  final List<InstalledPluginEntity>? installed;
  final PluginListEntity pluginList;

  const _BuildPluginList({
    required this.installed,
    required this.pluginList,
  });

  @override
  Widget build(BuildContext context) {
    final filtered = removeInstalled(installed, pluginList.plugins);
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

class PluginsPage extends StatefulWidget {
  const PluginsPage({super.key});

  @override
  State<PluginsPage> createState() => _PluginsPageState();
}

class _PluginsPageState extends State<PluginsPage> {
  late final PluginPageCubit _pluginPageCubit;

  @override
  void initState() {
    _pluginPageCubit = PluginPageCubit(context
        .repository<PluginManagerRepositoryUseCases>()
        .getAllPluginsUseCase)
      ..getAllPlugins();

    super.initState();
  }

  static const _textStyle =
      TextStyle(fontWeight: FontWeight.w600, fontSize: 18);

  static const _textStyleMobile =
      TextStyle(fontWeight: FontWeight.w600, fontSize: 15);

  @override
  Widget build(BuildContext context) {
    final textStyle = isMobile ? _textStyleMobile : _textStyle;

    return StreamBuilder(
        stream: context
            .repository<PluginManagerRepositoryUseCases>()
            .getInstalledPluginsUseCase(null),
        builder: (context, snapshot) {
          return BlocConsumer<PluginPageCubit,
              AsyncState<List<PluginListEntity>>>(
            bloc: _pluginPageCubit,
            builder: (context, state) {
              return state.when(
                  data: (data) {
                    return DefaultTabController(
                      length: data.length + 1,
                      child: Scaffold(
                        appBar: AppBar(
                          title: const Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              'Extenstions',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                          ),
                          bottom: TabBar(isScrollable: true, tabs: [
                            Tab(
                              child: Text(
                                'Installed',
                                style: textStyle,
                              ),
                            ),
                            ...data.map((e) => Tab(
                                    child: Text(
                                  e.name.toUpperCaseFirst(),
                                  style: textStyle,
                                )))
                          ]),
                        ),
                        body: TabBarView(children: [
                          _InstalledPluginListView(
                            snapshot: snapshot,
                            allPlugins: data,
                          ),
                          ...data.map((e) => _BuildPluginList(
                                installed: snapshot.data,
                                pluginList: e,
                              ))
                        ]),
                      ),
                    );
                  },
                  error: (error) {
                    return CustomErrorWidget(
                      error: error.message,
                      onRetry: () => _pluginPageCubit.getAllPlugins(),
                    );
                  },
                  loading: () => const Center(
                        child: CircularProgressIndicator(),
                      ));
            },
            listener: (context, state) {
              if (state is AsyncStateFailed) {
                showSnackBar(context, text: state.error!.message);
              }
            },
          );
        });
  }

  @override
  void dispose() {
    _pluginPageCubit.close();
    super.dispose();
  }
}
