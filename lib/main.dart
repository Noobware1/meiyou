import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meiyou/config/routes/router_provider.dart';
import 'package:meiyou/core/constants/path.dart';
import 'package:meiyou/core/resources/paths.dart';
import 'package:meiyou/core/usecases_container/cache_repository_usecase_container.dart';
import 'package:meiyou/core/usecases_container/meta_provider_repository_container.dart';
import 'package:meiyou/core/usecases_container/provider_list_container.dart';
import 'package:meiyou/core/usecases_container/video_player_usecase_container.dart';
import 'package:meiyou/data/data_source/providers/meta_providers/anilist.dart';
import 'package:meiyou/data/data_source/providers/meta_providers/tmdb.dart';
import 'package:meiyou/data/repositories/cache_repository_impl.dart';
import 'package:meiyou/data/repositories/get_provider_list.dart';
import 'package:meiyou/data/repositories/meta_provider_repository_impl.dart';
import 'package:meiyou/data/repositories/video_player_repositoriy_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:meiyou/presentation/widgets/info.dart';
import 'package:media_kit/media_kit.dart';
import 'package:meiyou/domain/repositories/cache_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Necessary initialization for package:media_kit.
  MediaKit.ensureInitialized();
  final appdirs = await AppDirectories.getInstance();
  final CacheRespository cacheRespository =
      CacheRepositoryImpl(appdirs.appCacheDirectory.path);
  await cacheRespository.deleteIOCacheFromDir(responsesFolder);
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(
          value: appdirs,
        ),
        RepositoryProvider.value(
          value: cacheRespository,
        ),
        CacheRepositoryUseCaseContainer(cacheRespository).inject(),
      ],
      child: const Meiyou(),
    ),
  );
}

class Meiyou extends StatelessWidget {
  const Meiyou({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        MetaProviderRepositoryContainer(
                MetaProviderRepositoryImpl(TMDB(), Anilist()))
            .inject(),
        LoadProviderListRepositoryContainer(ProviderListRepositoryImpl())
            .inject(),
        VideoPlayerUseCaseContainer(VideoPlayerRepositoryImpl()).inject(),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: MeiyouRouterProvider().router(),
        theme: ThemeData(
            bottomSheetTheme: const BottomSheetThemeData(
                backgroundColor: Colors.black,
                dragHandleColor: Colors.grey,
                showDragHandle: true),
            primaryTextTheme: ThemeData.dark().textTheme,
            primaryColorDark: Colors.black,
            primarySwatch: Colors.pink,
            // dialogTheme: DialogTheme(),
            dropdownMenuTheme: const DropdownMenuThemeData(
                inputDecorationTheme:
                    InputDecorationTheme(fillColor: Colors.pink, filled: true),
                menuStyle: MenuStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.grey),
                ),
                textStyle: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600)),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                backgroundColor: Colors.black,
                showUnselectedLabels: true,
                selectedIconTheme: IconThemeData(color: Colors.pink),
                unselectedIconTheme: IconThemeData(color: Colors.grey)),
            iconTheme:
                const IconThemeData(color: Colors.white, size: 30, weight: 30)),
      ),
    );
  }
}
