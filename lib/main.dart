import 'package:flutter/material.dart';
import 'package:meiyou/core/resources/meta_provider.dart';
import 'package:meiyou/data/data_source/providers/meta_providers/anilist.dart';
import 'package:meiyou/data/data_source/providers/meta_providers/tmdb.dart';
import 'package:meiyou/data/repositories/meta_provider_repository_impl.dart';
import 'package:meiyou/domain/entities/meta_response.dart';
import 'package:meiyou/presentation/pages/home/home_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meiyou/presentation/pages/info_watch/info_and_watch_page.dart';

void main() {
  runApp(const Meiyou());
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
          dropdownMenuTheme: DropdownMenuThemeData(
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
          RepositoryProvider(
        create: (context) => MetaProviderRepositoryImpl(TMDB(), Anilist()),
        child: const InfoAndWatchPage(
            response: MetaResponseEntity(
                id: 1, mediaProvider: MediaProvider.tmdb, genres: [''])),
      ),
    );
  }
}
