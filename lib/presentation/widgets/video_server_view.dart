import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meiyou/config/routes/routes.dart';
import 'package:meiyou/config/routes/routes_name.dart';
import 'package:meiyou/core/constants/default_sized_box.dart';
import 'package:meiyou/core/resources/snackbar.dart';
import 'package:meiyou/core/usecases_container/video_player_usecase_container.dart';
import 'package:meiyou/core/usecases_container/watch_provider_repository_container.dart';
import 'package:meiyou/core/utils/player_utils.dart';
import 'package:meiyou/data/repositories/video_player_repositoriy_impl.dart';
import 'package:meiyou/domain/repositories/cache_repository.dart';
import 'package:meiyou/domain/usecases/provider_use_cases/load_server_and_video_usecase.dart';
import 'package:meiyou/presentation/pages/info_watch/state/source_dropdown_bloc/bloc/source_drop_down_bloc.dart';
import 'package:meiyou/presentation/player/player.dart';
import 'package:meiyou/presentation/player/video_controls/cubits/selected_server_cubit.dart';
import 'package:meiyou/presentation/widgets/add_space.dart';
import 'package:meiyou/presentation/widgets/video_server/state/bloc/load_video_server_and_video_container_bloc_bloc.dart';
import 'package:meiyou/presentation/widgets/video_server_holder.dart';
import 'package:meiyou/domain/entities/video_container.dart';

final class SelectedServer {
  final String server;
  final VideoContainerEntity videoContainerEntity;
  final int selectedVideoIndex;

  const SelectedServer(
      {required this.server,
      required this.videoContainerEntity,
      required this.selectedVideoIndex});
}

typedef OnVideoServerSelected = void Function(SelectedServer selected);

typedef PlayerDependendicesInjector = Widget Function(Widget child);

class VideoServerListView extends StatefulWidget {
  final PlayerDependendicesInjector injector;
  final OnVideoServerSelected? onSelected;
  final String url;
  const VideoServerListView(
      {super.key, this.onSelected, required this.injector, required this.url});

  static Future showSelectServerDialog(
      BuildContext context, Widget Function(Widget child) injector, String url,
      [OnVideoServerSelected? onSelected]) {
    return showModalBottomSheet(
        backgroundColor: Colors.black,
        enableDrag: true,
        showDragHandle: true,
        context: context,
        builder: (context) {
          return injector(VideoServerListView(
            onSelected: onSelected,
            injector: injector,
            url: url,
          ));
        });
  }

  static Future showDialog(BuildContext context, String url,
          [OnVideoServerSelected? onSelected]) =>
      showSelectServerDialog(
          context,
          (child) => playerDependenciesInjector(context, child: child),
          url,
          onSelected);

  @override
  State<VideoServerListView> createState() => _VideoServerListViewState();
}

class _VideoServerListViewState extends State<VideoServerListView> {
  late final LoadVideoServerAndVideoContainerBloc bloc;

  @override
  void initState() {
    bloc = LoadVideoServerAndVideoContainerBloc(
        RepositoryProvider.of<WatchProviderRepositoryContainer>(context)
            .get<LoadServerAndVideoUseCase>(),
        RepositoryProvider.of<CacheRespository>(context))
      ..add(LoadVideoServerAndVideoContainer(
          BlocProvider.of<SourceDropDownBloc>(context).state.provider,
          widget.url));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      constraints: const BoxConstraints(minHeight: 100, maxHeight: 600),
      child: Column(
        children: [
          const Text(
            'Select Server',
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
          ),
          addVerticalSpace(20),
          BlocConsumer<LoadVideoServerAndVideoContainerBloc,
                  LoadVideoServerAndVideoContainerState>(
              bloc: bloc,
              builder: (context, state) {
                if (state is LoadVideoServerAndVideoContainerLoading) {
                  return const CircularProgressIndicator();
                } else if (state.data != null) {
                  return Expanded(
                    child: ListView(
                      children: List.generate(
                          state.data!.length,
                          (index) => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: DefaultTextStyle(
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700),
                                        child: Text(
                                            state.data!.keys.elementAt(index))),
                                  ),
                                  addVerticalSpace(5),
                                  Column(
                                    children: List.generate(
                                        state.data!.values
                                            .elementAt(index)
                                            .videos
                                            .length,
                                        (i) => VideoServerHolder(
                                              onTap: (video) {
                                                if (widget.onSelected != null) {
                                                  widget.onSelected?.call(
                                                      SelectedServer(
                                                          server: state
                                                              .data!.keys
                                                              .elementAt(index),
                                                          videoContainerEntity:
                                                              state.data!.values
                                                                  .elementAt(
                                                                      index),
                                                          selectedVideoIndex:
                                                              state.data!.values
                                                                  .elementAt(
                                                                      index)
                                                                  .videos
                                                                  .indexOf(
                                                                      video)));

                                                  Navigator.pop(context);
                                                } else {
                                                  context.push(
                                                      '${GoRouter.of(context).routeInformationProvider.value.location}$playerRoute',
                                                      extra: [
                                                        SelectedServer(
                                                          server: state
                                                              .data!.keys
                                                              .elementAt(index),
                                                          videoContainerEntity:
                                                              state.data!.values
                                                                  .elementAt(
                                                                      index),
                                                          selectedVideoIndex:
                                                              state.data!.values
                                                                  .elementAt(
                                                                      index)
                                                                  .videos
                                                                  .indexOf(
                                                                      video),
                                                        ),
                                                        widget.injector,
                                                      ]);
                                                }
                                              },
                                              video: state.data!.values
                                                  .elementAt(index)
                                                  .videos[i],
                                            )),
                                  )
                                ],
                              )),
                    ),
                  );
                } else {
                  return defaultSizedBox;
                }
              },
              listener: (context, state) {
                if (state is LoadVideoServerAndVideoContainerFailed) {
                  showSnackBAr(context, text: state.error.toString());
                }
              })
        ],
      ),
    );
  }

  @override
  void dispose() {
    bloc.close();
    super.dispose();
  }
}
