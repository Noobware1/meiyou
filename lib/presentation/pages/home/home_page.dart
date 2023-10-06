import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meiyou/config/routes/routes.dart';
import 'package:meiyou/config/routes/routes_name.dart';
import 'package:meiyou/core/constants/plaform_check.dart';
import 'package:meiyou/core/usecases_container/meta_provider_repository_container.dart';
import 'package:meiyou/domain/usecases/get_main_page_usecase.dart';
import 'package:meiyou/presentation/pages/home/bloc/main_page_bloc.dart';
import 'package:meiyou/presentation/widgets/add_space.dart';
import 'package:meiyou/presentation/widgets/banner_view/banner_page_view.dart';
import 'package:meiyou/presentation/widgets/image_view/image_list_view_with_controller.dart';
import 'package:meiyou/presentation/widgets/layout_builder.dart';
import 'package:meiyou/presentation/widgets/retry_connection.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final MainPageBloc mainPageBloc;

  @override
  void initState() {
    mainPageBloc = MainPageBloc(
        RepositoryProvider.of<MetaProviderRepositoryContainer>(context)
            .get<GetMainPageUseCase>())
      ..add(const GetMainPage());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainPageBloc, MainPageState>(
        bloc: mainPageBloc,
        buildWhen: (previous, current) {
          return previous.mainPageEntity == null ||
              current.mainPageEntity == null;
        },
        builder: (context, state) {
          if (state is MainPageLoading) {
            return const Center(
                child: SizedBox(
                    height: 50, width: 50, child: CircularProgressIndicator()));
          } else if (state is MainPageWithError) {
            return Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: RetryConnection(
                      onRetryConnection: () =>
                          mainPageBloc.add(const GetMainPage()),
                      retryReason: state.error!.toString()),
                ),
              ),
            );
          } else {
            // final data = (state as MainPageWithData).mainPageEntity!.rows;

            return ScrollbarTheme(
              data: const ScrollbarThemeData(
                  thumbColor: MaterialStatePropertyAll(Colors.grey)),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // scrollDirection: Axis.vertical,
                  children: [
                    BannerPageView(
                      bannerRow: state.mainPageEntity!.rows[0],
                    ),
                    addVerticalSpace(10),
                    for (var i = 1; i < state.mainPageEntity!.rows.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: ResponsiveBuilder(
                          forLagerScreen: ImageViewWithScrollController(
                              type: ImageListViewType.withButtonAndLabel,
                              onSelected: (selected) => context
                                  .go('$homeRoute/$watch', extra: selected),
                              height: 250,
                              width: 150,
                              textStyle: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              data: state.mainPageEntity!.rows[i]),
                          forSmallScreen: ImageViewWithScrollController(
                            onSelected: (selected) => context
                                .go('$homeRoute/$watch', extra: selected),
                            type: isMobile
                                ? ImageListViewType.withLabel
                                : ImageListViewType.withButtonAndLabel,
                            data: state.mainPageEntity!.rows[i],
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

  @override
  void dispose() {
    mainPageBloc.close();
    super.dispose();
  }
}
