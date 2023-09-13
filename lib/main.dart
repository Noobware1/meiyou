import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:meiyou/core/initialization_view/intialise_view_type.dart';
import 'package:meiyou/core/resources/meta_provider.dart';
import 'package:meiyou/core/resources/paths.dart';
import 'package:meiyou/core/usecases_container/meta_provider_repository_container.dart';
import 'package:meiyou/core/usecases_container/provider_list_container.dart';
import 'package:meiyou/core/usecases_container/video_player_usecase_container.dart';
import 'package:meiyou/core/utils/extenstions/iterable.dart';
import 'package:meiyou/core/utils/network.dart';
import 'package:meiyou/data/data_source/providers/meta_providers/anilist.dart';
import 'package:meiyou/data/data_source/providers/meta_providers/tmdb.dart';
import 'package:meiyou/data/models/episode.dart';
import 'package:meiyou/data/repositories/cache_repository_impl.dart';
import 'package:meiyou/data/repositories/get_provider_list.dart';
import 'package:meiyou/data/repositories/meta_provider_repository_impl.dart';
import 'package:meiyou/data/repositories/video_player_repositoriy_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:meiyou/presentation/widgets/info.dart';
import 'package:media_kit/media_kit.dart';
import 'package:meiyou/domain/entities/meta_response.dart';
import 'package:meiyou/presentation/widgets/fetch_info.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Necessary initialization for package:media_kit.
  MediaKit.ensureInitialized();
  final appdirs = await AppDirectories.getInstance();
  runApp(
    RepositoryProvider(
      create: (context) => appdirs,
      child: const Meiyou(),
    ),
  );
}

class Meiyou extends StatelessWidget {
  const Meiyou({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
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
              textStyle:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: Colors.black,
              showUnselectedLabels: true,
              selectedIconTheme: IconThemeData(color: Colors.pink),
              unselectedIconTheme: IconThemeData(color: Colors.grey)),
          iconTheme:
              const IconThemeData(color: Colors.white, size: 30, weight: 30)),
      home:
          // RepositoryProvider(
          //   create: (context) => Anilist(),
          // ),
          // RepositoryProvider(create: (context) => TMDB()),

          MultiRepositoryProvider(
              providers: [
            MetaProviderRepositoryContainer(
                    MetaProviderRepositoryImpl(TMDB(), Anilist()))
                .inject(),
            LoadProviderListRepositoryContainer(ProviderListRepositoryImpl())
                .inject(),
            VideoPlayerUseCaseContainer(VideoPlayerRepositoryImpl()).inject(),
          ],
              // child: Container(),
              child: const LoadInfo(
                  type: InitaliseViewType.watchview,
                  metaResponse: MetaResponseEntity(
                      //demon slayer
                      // id: 101922,
                      //anne with e
                      // id: 149883,

                      //wednesday
                      id: 70785,
                      mediaType: 'tv',
                      mediaProvider: MediaProvider.tmdb,
                      genres: ['']))),
    );
  }
}
