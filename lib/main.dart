import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:meiyou/config/routes/router_provider.dart';
import 'package:meiyou/config/themes/meiyou_theme.dart';
import 'package:meiyou/core/resources/isar.dart';
import 'package:meiyou/core/resources/paths.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';
import 'package:meiyou/data/models/installed_plugin.dart';
import 'package:meiyou/data/models/plugin_list.dart';
import 'package:meiyou/data/repositories/plugin_manager_repository_impl.dart';
import 'package:meiyou/presentation/blocs/get_installed_plugin_cubit.dart';
import 'package:meiyou/presentation/blocs/load_home_page_cubit.dart';
import 'package:meiyou/presentation/blocs/plugin_selector_cubit.dart';
import 'package:isar/isar.dart';
import 'package:meiyou/presentation/blocs/pluign_manager_usecase_provider_cubit.dart';
import 'package:meiyou/presentation/providers/plugin_manager_repository_usecase_provider.dart';
import 'package:meiyou/presentation/test.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  if (Platform.isWindows) {
    await windowManager.ensureInitialized();
  }

  final appDirs = await AppDirectories.getInstance();
  isar = Isar.openSync([InstalledPluginSchema, PluginListSchema],
      directory: appDirs.databaseDirectory.path);

  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  runApp(
    MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(value: appDirs),
          RepositoryProvider<PluginManagerRepositoryUseCases>(
              create: (context) => PluginManagerRepositoryUseCases(
                  PluginManagerRepositoryImpl(appDirs.pluginDirectory.path))
                ..deletePluginListsCache(null))
        ],
        child: MultiBlocProvider(
          providers: [
            // BlocProvider(
            //   create: (context) => InstalledPluginCubit(
            //     context
            //         .repository<PluginManagerRepositoryUseCases>()
            //         .getInstalledPluginsUseCase
            //         .call('Video'),
            //   ),
            // ),
            BlocProvider(
              create: (context) => InstalledVideoPluginCubit(context
                  .repository<PluginManagerRepositoryUseCases>()
                  .getInstalledPluginsUseCase),
            ),
            BlocProvider(
              create: (context) => InstalledMangaPluginCubit(context
                  .repository<PluginManagerRepositoryUseCases>()
                  .getInstalledPluginsUseCase),
            ),
            BlocProvider(
              create: (context) => InstalledNovelPluginCubit(context
                  .repository<PluginManagerRepositoryUseCases>()
                  .getInstalledPluginsUseCase),
            ),
            BlocProvider(
              create: (context) => LoadHomePageCubit(),
            ),
            BlocProvider(
              lazy: false,
              create: (context) => PluginRepositoryUseCaseProviderCubit(
                  context
                      .repository<PluginManagerRepositoryUseCases>()
                      .loadPluginUseCase,
                  context.bloc<LoadHomePageCubit>()),
            ),
            BlocProvider(
              lazy: false,
              create: (context) => PluginSelectorCubit(
                  context
                      .repository<PluginManagerRepositoryUseCases>()
                      .getInstalledPluginsUseCase('Video'),
                  context
                      .repository<PluginManagerRepositoryUseCases>()
                      .getLastedUsedPluginUseCase
                      .call(null),
                  context
                      .repository<PluginManagerRepositoryUseCases>()
                      .updateLastUsedPluginUseCase,
                  context.bloc<PluginRepositoryUseCaseProviderCubit>()),
            ),
          ],
          child: const Meiyou(),
        )),
  );
}

class Meiyou extends StatefulWidget {
  const Meiyou({super.key});

  @override
  State<Meiyou> createState() => _MeiyouState();
}

class _MeiyouState extends State<Meiyou> {
  // StreamSubscription<PluginEntity>? _subscription;
  late final RouterProvider routerProvider;

  @override
  void initState() {
    routerProvider = RouterProvider();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = MeiyouTheme.values[2];

    // return MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   theme: theme.lightTheme,
    //   darkTheme: theme.darkTheme,
    //   themeMode: ThemeMode.dark,
    //   home: (),
    // );
    return MaterialApp.router(
      routerConfig: routerProvider.router,
      theme: theme.lightTheme,
      darkTheme: theme.darkTheme,
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      title: 'Meiyou',
    );
  }
}

class TestWidget extends StatefulWidget {
  @override
  _TestWidgetState createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapSeek() {
    _controller.reset();
    _controller.forward();

    // TODO: Add your seek logic here
    // You can add the logic to seek forward or backward in your video player.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('YouTube Video Player'),
      ),
      body: Stack(
        children: [
          GestureDetector(
            onTap: _onTapSeek,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100.0,
                    height: 100.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.withOpacity(0.5),
                    ),
                    child: Icon(
                      Icons.forward,
                      size: 50.0,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    'Tap to Seek Forward',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ],
              ),
            ),
          ),
          MyArc(child: Container()),
          // Positioned(
          //   right: 0,
          //   child: AnimatedBuilder(
          //     animation: _animation,
          //     builder: (context, child) {
          //       return AnimatedOpacity(
          //         duration: Duration(milliseconds: 200),
          //         opacity: _animation.value,
          //         child: MyArc(
          //           // child: Transform.translate(
          //           //   offset: Offset(50.0 * _animation.value, 0),
          //           //   child: Icon(
          //           //     Icons.forward,
          //           //     size: 50.0,
          //           //     color: Colors.white,
          //           //   ),
          //           // ),
          //           child: Container(),
          //         ),
          //       );
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}
