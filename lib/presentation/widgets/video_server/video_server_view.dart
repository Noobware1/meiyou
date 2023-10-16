import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meiyou/config/routes/routes.dart';
import 'package:meiyou/core/constants/default_sized_box.dart';
import 'package:meiyou/core/resources/snackbar.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';
import 'package:meiyou/core/utils/player_utils.dart';
import 'package:meiyou/presentation/pages/info_watch/state/source_dropdown_bloc/bloc/source_drop_down_bloc.dart';
import 'package:meiyou/presentation/widgets/add_space.dart';
import 'package:meiyou/presentation/widgets/video_server/state/load_server_video_bloc/load_video_server_and_video_container_bloc_bloc.dart';
import 'video_server_holder.dart';
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

class VideoServerListView extends StatelessWidget {
  final PlayerDependendicesInjector injector;
  final OnVideoServerSelected? onSelected;
  final String url;
  const VideoServerListView(
      {super.key, this.onSelected, required this.injector, required this.url});

  static Future showSelectServerDialog(
      BuildContext context, Widget Function(Widget child) injector, String url,
      [OnVideoServerSelected? onSelected]) {
    final theme = context.theme;

    return showModalBottomSheet(
        backgroundColor: Colors.black,
        enableDrag: true,
        showDragHandle: false,
        context: context,
        builder: (context) {
          return Theme(
            data: theme,
            child: injector(VideoServerListView(
              onSelected: onSelected,
              injector: injector,
              url: url,
            )),
          );
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints(minHeight: 100, maxHeight: 800),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              addVerticalSpace(10),
              const Text(
                'Select Server',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              addVerticalSpace(20),
              BlocConsumer<LoadVideoServerAndVideoContainerBloc,
                      LoadVideoServerAndVideoContainerState>(
                
                  bloc: BlocProvider.of<LoadVideoServerAndVideoContainerBloc>(
                      context)
                    ..add(LoadVideoServerAndVideoContainer(
                        BlocProvider.of<SourceDropDownBloc>(context).provider,
                        url)),
                  builder: (context, state) {
                    if (state is LoadVideoServerAndVideoContainerLoading) {
                      return const CircularProgressIndicator();
                    } else if (state.data != null) {
                      return Expanded(
                        child: ListView(children: [
                          ...List.generate(
                              state.data!.length,
                              (index) => Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 20),
                                        child: Text(
                                          state.data!.keys.elementAt(index),
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700),
                                        ),
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
                                                    if (onSelected != null) {
                                                      onSelected?.call(SelectedServer(
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
                                                      context.pop();
                                                      context.push(
                                                          '${GoRouter.of(context).routeInformationProvider.value.location}$playerRoute',
                                                          extra: [
                                                            SelectedServer(
                                                              server: state
                                                                  .data!.keys
                                                                  .elementAt(
                                                                      index),
                                                              videoContainerEntity:
                                                                  state.data!
                                                                      .values
                                                                      .elementAt(
                                                                          index),
                                                              selectedVideoIndex:
                                                                  state.data!
                                                                      .values
                                                                      .elementAt(
                                                                          index)
                                                                      .videos
                                                                      .indexOf(
                                                                          video),
                                                            ),
                                                            injector,
                                                          ]);
                                                    }
                                                  },
                                                  video: state.data!.values
                                                      .elementAt(index)
                                                      .videos[i],
                                                )),
                                      ),
                                    ],
                                  )),
                          _buildLoadingIndicatorIfExtracting(state),
                        ]),
                      );
                    } else {
                      return defaultSizedBox;
                    }
                  },
                  listener: (context, state) {
                    if (state is LoadVideoServerAndVideoContainerFailed ||
                        state
                            is LoadVideoServerAndVideoContainerCompletedError) {
                      showSnackBAr(context, text: state.error.toString());
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicatorIfExtracting(
      LoadVideoServerAndVideoContainerState state) {
    if (state is LoadVideoServerAndVideoContainerCompletedSucess ||
        state is LoadVideoServerAndVideoContainerCompletedError) {
      return defaultSizedBox;
    }
    return const Padding(
      padding: EdgeInsets.only(top: 30, bottom: 30),
      child: Center(
          child: SizedBox(
              height: 40, width: 40, child: CircularProgressIndicator())),
    );
  }
}
