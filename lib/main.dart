import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_kit/media_kit.dart';
import 'package:meiyou/core/plugin/base_plugin_api.dart';
import 'package:meiyou/core/resources/isar.dart';
import 'package:meiyou/core/resources/logger.dart';
import 'package:meiyou/core/resources/paths.dart';
import 'package:meiyou/core/resources/snackbar.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';
import 'package:meiyou/core/utils/extenstions/iterable.dart';
import 'package:meiyou/core/utils/network.dart';
import 'package:meiyou/data/data_source/local/dao/plugin_dao.dart';
import 'package:meiyou/data/models/plugin.dart';
import 'package:meiyou/data/models/plugin_list.dart';
import 'package:meiyou/data/repositories/plugin_manager_repository_impl.dart';
import 'package:meiyou/data/repositories/plugin_repository_impl.dart';
import 'package:meiyou/domain/entities/plugin.dart';
import 'package:meiyou/domain/repositories/plugin_manager_repository.dart';
import 'package:meiyou/domain/repositories/plugin_repository.dart';
import 'package:meiyou/domain/usecases/plugin_repository/get_installed_plugins_usecase.dart';
import 'package:meiyou/presentation/blocs/get_installed_plugins.dart';
import 'package:meiyou/presentation/pages/home_page.dart';
import 'package:meiyou/presentation/pages/plugins_page.dart';
import 'package:meiyou/presentation/widgets/installed_providers.dart';
import 'package:isar/isar.dart';

// late final Isar isar;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  MediaKit.ensureInitialized();

  // final appdirs = await AppDirectories.getInstance();

  // final theme_bloc.MeiyouThemeState? theme = await loadData(
  //     savePath: '${appdirs.settingsDirectory.path}/theme.json',
  //     transFormer: (json) =>
  //         theme_bloc.MeiyouThemeState.fromJson(json as Map<String, dynamic>),
  //     onError: print);
  final appDirs = await AppDirectories.getInstance();
  isar = Isar.openSync([PluginSchema, PluginListSchema],
      directory: appDirs.databaseDirectory.path);

  // final CacheRespository cacheRespository =
  //     CacheRepositoryImpl(appdirs.appCacheDirectory.path);

  // appdirs.appCacheDirectory.deleteAllEntries();

  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  runApp(
    MultiRepositoryProvider(providers: [
      RepositoryProvider.value(value: appDirs),
      RepositoryProvider<PluginRepository>(
          create: (context) =>
              PluginRepositoryImpl(appDirs.pluginDirectory.path))
      // RepositoryProvider(create: (context) => PluginManagerRepositoryUseCaseProvider(PluginManagerRepositoryImpl(api: )))
    ], child: const Meiyou()),
  );
}

class Meiyou extends StatefulWidget {
  const Meiyou({super.key});

  @override
  State<Meiyou> createState() => _MeiyouState();
}

class _MeiyouState extends State<Meiyou> {
  // StreamSubscription<PluginEntity>? _subscription;

  @override
  void initState() {
    // _subscription =
    // try {
    //   context.repository<PluginRepository>().installPlugin(Plugin.decode(r'''{
    //   "name": "GogoAnime",
    //   "source": "https://raw.githubusercontent.com/Noobware1/meiyou-extenstions/master/src/anime/gogo/gogo.dart",
    //   "version": "0+.0.1",
    //   "icon": "https://raw.githubusercontent.com/Noobware1/meiyou-extenstions/master/src/anime/gogo/icon.png",
    //   "info": "Watch free anime from Gogo Anime",
    //   "dependencies": [
    //     {
    //       "name": "gogo_cdn",
    //       "source": "https://raw.githubusercontent.com/Noobware1/meiyou-extenstions/master/extractors/gogo_cdn.dart",
    //       "version": "0.0.1"
    //     }
    //   ]
    // }''')).then((value) => log(value));
    // } catch (e, s) {
    //   log(e, s);
    // }
    super.initState();
  }

  // Future<ResponseState<PluginListEntity>> getInstalledPlugins(
  //     PluginRepository repository) async {
  //   return await GetInstalledPluginsUseCase(repository).call('anime');
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData.dark(),
        darkTheme: ThemeData.dark(),
        themeMode: ThemeMode.dark,
        home: PluginsPage());
  }
}

class _MainWidget extends StatefulWidget {
  const _MainWidget({super.key});

  @override
  State<_MainWidget> createState() => _MainWidgetState();
}

class _MainWidgetState extends State<_MainWidget> {
  PluginManagerRepository? _pluginManagerRepository;
  PluginEntity _selectedPlugin = PluginEntity.none;
  // final List<LoadedPluginEntity> loadedPlugins = [];

  @override
  void initState() {
    ;
    // widget.stream?.listen((plugin) {
    //   loadedPlugins.add(plugin);
    // });

    mabyeLoadPlugin().then((value) {
      createPluginManagerRepoistory(value);
    });
    super.initState();
  }

  // @override
  // void didUpdateWidget(covariant _MainWidget oldWidget) {
  //   if (widget.snapshot != oldWidget.snapshot) {
  //     setState(() {
  //       createPluginManagerRepoistory(mabyeLoadPlugin());
  //     });
  //   }
  //   super.didUpdateWidget(oldWidget);
  // }

  @override
  Widget build(BuildContext context) {
    print(_selectedPlugin);
    return StreamBuilder<List<PluginEntity>>(
        stream:
            GetInstalledPluginsUseCase(context.repository<PluginRepository>())
                .call(null),
        builder: (context, snapshot) {
          return Scaffold(
            body: _pluginManagerRepository == null
                ? const Center(child: Text('Nothing to See Here :('))
                : HomePage(pluginManager: _pluginManagerRepository!),
            // StreamBuilder(stream: widget.stream, builder: (context, snapshot) {}),
            floatingActionButton: SizedBox(
              height: 55,
              child: FloatingActionButton.extended(
                  elevation: 10.0,
                  icon: Icon(Icons.view_headline_rounded,
                      color: context.theme.colorScheme.brightness ==
                              Brightness.dark
                          ? Colors.white
                          : Colors.black),
                  extendedPadding: const EdgeInsets.fromLTRB(15, 50, 15, 50),
                  label: Text(_selectedPlugin.name,
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
                              setState(() {
                                _selectedPlugin = plugin;
                                mabyeLoadPlugin().then((value) {
                                  createPluginManagerRepoistory(value);
                                });
                              });
                              Navigator.pop(context);
                            },
                            plugin: snapshot.data
                                    ?.tryfirstWhere((e) => e.lastUsed) ??
                                _selectedPlugin,
                            pluginList: snapshot.data,
                          ));
                        });
                  }),
            ),
          );
        });
  }

  Future<BasePluginApi?> mabyeLoadPlugin() async {
    if (_selectedPlugin == PluginEntity.none) return null;
    try {
      return await context
          .repository<PluginRepository>()
          .loadPlugin(_selectedPlugin);
    } catch (e, s) {
      log(e, s);
      showSnackBar(context, text: e.toString());
    }
    return null;
  }

  void createPluginManagerRepoistory(BasePluginApi? api) {
    if (api != null) {
      setState(() {
        _pluginManagerRepository = PluginManagerRepositoryImpl(api: api);
      });
    } else {
      setState(() {
        _pluginManagerRepository = null;
      });
    }
  }
}
