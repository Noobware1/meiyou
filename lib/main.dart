import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_kit/media_kit.dart';
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
            BlocProvider(
              create: (context) => InstalledPluginCubit(
                context
                    .repository<PluginManagerRepositoryUseCases>()
                    .getInstalledPluginsUseCase
                    .call(null),
              ),
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
                      .getInstalledPluginsUseCase(null),
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
    //   home: const TestWidget(),
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
