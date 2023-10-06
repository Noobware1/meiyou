import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meiyou/config/routes/router_provider.dart';
// import 'package:meiyou/config/themes/app_themes/app_theme.dart';
// import 'package:meiyou/config/themes/app_themes/app_theme_data.dart';
// import 'package:meiyou/config/themes/primary_colors/primary_color.dart';
import 'package:meiyou/core/resources/paths.dart';
import 'package:meiyou/core/resources/prefrences.dart';
import 'package:meiyou/core/usecases_container/cache_repository_usecase_container.dart';
import 'package:meiyou/core/usecases_container/meta_provider_repository_container.dart';
import 'package:meiyou/core/usecases_container/provider_list_container.dart';
import 'package:meiyou/core/usecases_container/video_player_usecase_container.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';
import 'package:meiyou/core/utils/extenstions/directory.dart';
import 'package:meiyou/core/utils/network.dart';
import 'package:meiyou/data/data_source/providers/meta_providers/anilist.dart';
import 'package:meiyou/data/data_source/providers/meta_providers/tmdb.dart';
import 'package:meiyou/data/repositories/cache_repository_impl.dart';
import 'package:meiyou/data/repositories/meta_provider_repository_impl.dart';
import 'package:meiyou/data/repositories/providers_repository_impl.dart';
import 'package:meiyou/data/repositories/video_player_repositoriy_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_kit/media_kit.dart';
import 'package:meiyou/domain/repositories/cache_repository.dart';

import 'presentation/widgets/theme/bloc/theme_bloc.dart' as theme_bloc;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  MediaKit.ensureInitialized();

  final appdirs = await AppDirectories.getInstance();

  // final ThemeRepositoryImpl themeRepo = await ThemeRepositoryImpl.getInstance(

  //     '${appdirs.appDocumentDirectory.path}\\meiyou_theme.json');

  final theme_bloc.MeiyouThemeState? theme = await loadData(
      savePath: '${appdirs.settingsDirectory.path}\\theme.json',
      transFormer: (json) =>
          theme_bloc.MeiyouThemeState.fromJson(json as Map<String, dynamic>),
      onError: print);

  final CacheRespository cacheRespository =
      CacheRepositoryImpl(appdirs.appCacheDirectory.path);

  await appdirs.appCacheDirectory.deleteAllEntries();
  // await cacheRespository.deleteIOCacheFromDir(responsesFolder);

  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  runApp(MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(
          value: appdirs,
        ),
        RepositoryProvider.value(
          value: cacheRespository,
        ),
        // RepositoryProvider.value(value: themeRepo),
        CacheRepositoryUseCaseContainer(cacheRespository).inject(),
      ],
      child: BlocProvider(
        create: (context) => theme_bloc.ThemeBloc(theme),
        child: const Meiyou(),
      )));
}

class Meiyou extends StatefulWidget {
  const Meiyou({super.key});

  @override
  State<Meiyou> createState() => _MeiyouState();
}

class _MeiyouState extends State<Meiyou> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // return MultiRepositoryProvider(
    //   providers: [
    //     ProvidersRepositoryContainer(ProvidersRepositoryImpl()).inject(),
    //   ],
    //   child: BlocProvider.value(
    //     value: themeBloc,
    //     child: MaterialApp(
    //         theme: themeBloc.state.theme.lightTheme,
    //         darkTheme: themeBloc.state.theme.darkTheme,
    //     )
    //   ),
    // );
    return MultiRepositoryProvider(
      providers: [
        MetaProviderRepositoryContainer(
                MetaProviderRepositoryImpl(TMDB(), Anilist()))
            .inject(),
        ProvidersRepositoryContainer(ProvidersRepositoryImpl()).inject(),
        VideoPlayerUseCaseContainer(VideoPlayerRepositoryImpl()).inject(),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: RouterProvider().router,
        themeMode: context.themeBloc.state.themeMode,
        theme: context.themeBloc.state.theme.lightTheme,
        darkTheme: context.themeBloc.state.theme.darkTheme,
      ),
    );
  }
}
