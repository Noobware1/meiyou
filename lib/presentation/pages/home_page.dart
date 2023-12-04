import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meiyou/core/constants/height_and_width.dart';
import 'package:meiyou/core/resources/platform_check.dart';
import 'package:meiyou/core/resources/snackbar.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';
import 'package:meiyou/domain/entities/homepage.dart';
import 'package:meiyou/domain/entities/search_response.dart';
import 'package:meiyou/presentation/blocs/load_home_page_cubit.dart';
import 'package:meiyou/presentation/blocs/plugin_selector_cubit.dart';
import 'package:meiyou/presentation/blocs/pluign_manager_usecase_provider_cubit.dart';
import 'package:meiyou/presentation/no_plugin.dart';
import 'package:meiyou/presentation/widgets/add_space.dart';
import 'package:meiyou/presentation/widgets/banner_view/banner_page_view.dart';
import 'package:meiyou/presentation/widgets/error_widget.dart';
import 'package:meiyou/presentation/widgets/image_view/image_holder.dart';
import 'package:meiyou/presentation/widgets/image_view/image_list_view.dart';
import 'package:meiyou/presentation/widgets/plugin_selector_floating_action_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        extendBodyBehindAppBar: true,
        body: _HomePage(),
        floatingActionButton: PluginFloatingActionButton(
          heroTag: 'home',
        ));
  }
}

class _HomePage extends StatelessWidget {
  const _HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PluginManagerUseCaseProviderCubit,
        PluginManagerUseCaseProviderState>(
      listener: (context, providerState) {
        if (providerState.isCompletedWithError) {
          showSnackBar(context, text: providerState.error!.message);
        }
      },
      builder: (context, providerState) {
        return providerState.when(
            done: (repository) {
              return BlocConsumer<LoadHomePageCubit, LoadHomePageState>(
                builder: (context, homePageState) {
                  return homePageState.when(
                      success: (data) {
                        return SingleChildScrollView(
                            child: Column(children: [
                          BannerPageView(homePage: data[0]),
                          if (data.length > 1)
                            ...data.sublist(1).map((homePage) {
                              return isMobile
                                  ? _forMobile(homePage, context)
                                  : _forDesktop(context, homePage);
                            }),
                          addVerticalSpace(40)
                        ]));
                      },
                      failed: (error) => CustomErrorWidget(
                          error: error.message,
                          onRetry: () => context
                              .bloc<LoadHomePageCubit>()
                              .loadFullHomePage(providerState
                                  .provider!.loadFullHomePageUseCase)),
                      loading: () => const Center(
                            child: CircularProgressIndicator(),
                          ));
                },
                listener: (context, homePageState) {
                  if (homePageState is LoadHomePageFailed) {
                    showSnackBar(context, text: homePageState.error.message);
                  }
                },
              );
            },
            error: (error) => CustomErrorWidget(
                  error: error.message,
                  onRetry: () => context
                      .bloc<PluginManagerUseCaseProviderCubit>()
                      .initPluginMangerUseCaseProvider(
                          context.bloc<PluginSelectorCubit>().state),
                ),
            loading: () => const Center(child: CircularProgressIndicator()),
            noPlugin: () => const NoPlugin());
      },
    );
  }

  Widget _forMobile(HomePageEntity homePage, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: ImageHolderListViewBuilder(
          label: homePage.data.name,
          labelTextStyle:
              const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          labelPadding: const EdgeInsets.only(left: 10, bottom: 10),
          labelBoxHeight: 30,
          builder: (context, data) {
            return ImageHolder.withWatchData(
              height: defaultPosterHeight,
              textStyle: const TextStyle(fontSize: 15),

              watchDataTextStyle: const TextStyle(fontSize: 14),
              imageUrl: data.poster,
              text: data.title,
              current: data.current,
              total: data.total,
              // watched: 100,
            );
          },
          onSelected: (selected) => onSelected(context, selected),
          homePage: homePage,
          height: 240),
    );
  }

  Widget _forDesktop(BuildContext context, HomePageEntity homePage) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: ImageHolderListViewBuilder(
          onSelected: (selected) => onSelected(context, selected),
          label: homePage.data.name,
          labelTextStyle:
              const TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
          labelPadding: const EdgeInsets.only(left: 10, bottom: 10),
          labelBoxHeight: 40,
          builder: (context, data) {
            return ImageHolder.withWatchData(
              textStyle: const TextStyle(fontSize: 16),
              watchDataTextStyle: const TextStyle(fontSize: 14),
              imageUrl: data.poster,
              width: defaultPosterBoxWidthDesktop,
              height: defaultPosterBoxHeightDesktop,
              text: data.title,
              current: data.current,
              total: data.total,
              // watched: 100,
            );
          },
          homePage: homePage,
          height: 290),
    );
  }

  void onSelected(BuildContext context, SearchResponseEntity searchResponse) {
    context.push('/home/info', extra: searchResponse);
  }
}
