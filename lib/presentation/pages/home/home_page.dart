import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meiyou/core/constants/plaform_check.dart';
// import 'package:meiyou/core/utils/extenstions/context.dart';
import 'package:meiyou/data/data_source/providers/meta_providers/anilist.dart';
import 'package:meiyou/data/data_source/providers/meta_providers/tmdb.dart';
import 'package:meiyou/domain/entities/results.dart';
import 'package:meiyou/presentation/pages/home/bloc/main_page_bloc.dart';
import 'package:meiyou/presentation/widgets/add_space.dart';
import 'package:meiyou/presentation/widgets/banner_view/banner_image_holder.dart';
import 'package:meiyou/presentation/widgets/banner_view/banner_page_view.dart';
import 'package:meiyou/presentation/widgets/gradient.dart';
import 'package:meiyou/presentation/widgets/image_view/image_holder.dart';
// import 'package:meiyou/presentation/widgets/banner_view/banner_page_view.dart';
import 'package:meiyou/presentation/widgets/image_view/image_list_view_with_controller.dart';
import 'package:meiyou/presentation/widgets/layout_builder.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<MetaResultsEntity>? future;

  @override
  void initState() {
    future = Anilist().fetchTrending();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: MainPageBloc(
            anilist: RepositoryProvider.of<Anilist>(context, listen: false),
            tmdb: RepositoryProvider.of<TMDB>(context, listen: false))
          ..add(const GetMainPage()),
        builder: (context, state) {
          if (state is MainPageLoading) {
            return const CircularProgressIndicator();
          } else if (state is MainPageWithError) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Text(
                  state.error!.toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            );
          } else {
            final data = (state as MainPageWithData).mainPageEntity!.rows;

            return ScrollbarTheme(
              data: const ScrollbarThemeData(
                  thumbColor: MaterialStatePropertyAll(Colors.grey)),
              child: SingleChildScrollView(
                child: Column(
                  // scrollDirection: Axis.vertical,
                  children: [
                    BannerPageView(
                      bannerRow: data[0],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    for (var i = 1; i < data.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: ResponsiveBuilder(
                          forLagerScreen: ImageViewWithScrollController(
                              type: ImageListViewType.withButtonAndLabel,
                              height: 250,
                              width: 150,
                              textStyle: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              data: data[i]),
                          forSmallScreen: ImageViewWithScrollController(
                            type: isMobile
                                ? ImageListViewType.withLabel
                                : ImageListViewType.withButtonAndLabel,
                            data: data[i],
                          ),
                        ),
                      )
                  ],
                ),
              ),
            );
          }
        });
  }
}
