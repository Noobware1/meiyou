import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meiyou/core/constants/height_and_width.dart';
import 'package:meiyou/core/resources/platform_check.dart';
import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/core/resources/snackbar.dart';
import 'package:meiyou/core/utils/extenstions/async_snapshot.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';
import 'package:meiyou/domain/entities/homepage.dart';
import 'package:meiyou/domain/entities/plugin.dart';
import 'package:meiyou/domain/entities/plugin_list.dart';
import 'package:meiyou/domain/repositories/plugin_manager_repository.dart';
import 'package:meiyou/domain/usecases/plugin_manager_usecases/load_full_home_page_usecase.dart';
import 'package:meiyou/presentation/blocs/async_cubit/async_cubit.dart';
import 'package:meiyou/presentation/blocs/load_home_page_cubit.dart';
import 'package:meiyou/presentation/blocs/selected_plugin_api/plugin_manager_bloc.dart';
import 'package:meiyou/presentation/blocs/selected_plugin_cubit.dart';
import 'package:meiyou/presentation/widgets/add_space.dart';
import 'package:meiyou/presentation/widgets/banner_view/banner_page_view.dart';
import 'package:meiyou/presentation/widgets/image_view/image_holder.dart';
import 'package:meiyou/presentation/widgets/image_view/image_list_view.dart';
import 'package:meiyou/presentation/widgets/installed_providers.dart';

class HomePage extends StatefulWidget {
  final PluginManagerRepository pluginManager;
  const HomePage({super.key, required this.pluginManager});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // late final LoadHomePageCubit _loadHomePageCubit;
  Future<ResponseState<List<HomePageEntity>>>? _futureHomePage;

  Future<ResponseState<List<HomePageEntity>>> loadHomePage() async {
    return await widget.pluginManager.loadFullHomePage();
  }

  @override
  void initState() {
    _futureHomePage = loadHomePage();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant HomePage oldWidget) {
    if (widget.pluginManager != oldWidget.pluginManager) {
      setState(() {
        _futureHomePage = loadHomePage();
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  Widget _forMobile(HomePageEntity homePage) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
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
          homePage: homePage,
          height: 240),
    );
  }

  Widget _forDesktop(HomePageEntity homePage) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: ImageHolderListViewBuilder(
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FutureBuilder<ResponseState<List<HomePageEntity>>>(
          future: _futureHomePage,
          builder: (context, snapshot) {
            return snapshot.when(
              data: (data) {
                return Column(children: [
                  BannerPageView(homePage: data[0]),
                  if (data.length > 1)
                    ...data.sublist(1).map((homePage) {
                      return isMobile
                          ? _forMobile(homePage)
                          : _forDesktop(homePage);
                    }),
                  addVerticalSpace(80)
                ]);
              },
              error: (e) {
                return Center(
                  child: Text(e.toString()),
                );
              },
              loading: () => CircularProgressIndicator(),
            );
          }),
    );
  }
}
