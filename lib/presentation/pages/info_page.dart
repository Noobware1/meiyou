import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meiyou/core/resources/snackbar.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';
import 'package:meiyou/presentation/blocs/async_cubit/async_cubit.dart';
import 'package:meiyou/presentation/blocs/info_page_cubit.dart';
import 'package:meiyou/presentation/blocs/pluign_manager_usecase_provider_cubit.dart';
import 'package:meiyou/presentation/widgets/error_widget.dart';
import 'package:meiyou/presentation/widgets/watch_views.dart';
import 'package:meiyou/presentation/providers/init_provider_info_page.dart';
import 'package:meiyou/presentation/widgets/info_page_desktop.dart';
import 'package:meiyou/presentation/widgets/info_page_mobile.dart';
import 'package:meiyou/presentation/widgets/responsive_layout.dart';
import 'package:meiyou_extensions_lib/models.dart';

class InfoPage extends StatelessWidget {
  final SearchResponse searchResponse;

  const InfoPage({super.key, required this.searchResponse});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => MediaDetailsCubit(searchResponse)
          ..loadMediaDetails(
              context.bloc<PluginRepositoryUseCaseProviderCubit>()),
        child: BlocConsumer<MediaDetailsCubit, AsyncState<MediaDetails>>(
            builder: (context, state) {
          return state.when(data: (data) {
            return RepositoryProvider.value(
              value: data,
              child: initProvidersForInfoPage(
                mediaDetails: data,
                child: const SingleChildScrollView(
                  child: ResponsiveLayout(
                      forBiggerScreen: InfoPageDesktop(),
                      forSmallScreen: InfoPageMobile()),
                ),
              ),
            );
          }, error: (error) {
            return CustomErrorWidget(
              error: error.message,
              onRetry: () => context.bloc<MediaDetailsCubit>().loadMediaDetails(
                  context.bloc<PluginRepositoryUseCaseProviderCubit>()),
            );
          }, loading: () {
            return const Center(
              child: CircularProgressIndicator(),
            );
          });
        }, listener: (context, state) {
          if (state is AsyncStateFailed) {
            showSnackBar(context, text: state.error!.message);
          }
        }),
      ),
    );
  }
}

bool isMediaItemIsNotNullOrEmpty(MediaItem? mediaItem) {
  if (mediaItem == null) return false;
  if (mediaItem is Anime && mediaItem.episodes.isEmpty) return false;
  if (mediaItem is TvSeries && mediaItem.data.isEmpty) return false;
  return true;
}

class WatchView extends StatelessWidget {
  const WatchView({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaItem = context.repository<MediaDetails>().mediaItem;
    if (mediaItem is TvSeries) {
      return const TvSeriesView();
    } else if (mediaItem is Anime) {
      return const AnimeView();
    } else {
      return const MovieView();
    }
  }
}
