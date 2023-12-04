import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_kit/media_kit.dart';
import 'package:meiyou/core/constants/default_widgets.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';
import 'package:meiyou/data/models/media_item/movie.dart';
import 'package:meiyou/domain/entities/media_details.dart';
import 'package:meiyou/presentation/blocs/current_episode_cubit.dart';
import 'package:meiyou/presentation/blocs/player/selected_video_data.dart';
import 'package:meiyou/presentation/blocs/player/server_and_video_cubit.dart';
import 'package:meiyou/presentation/blocs/player/video_track_cubit.dart';
import 'package:meiyou/presentation/blocs/plugin_selector_cubit.dart';
import 'package:meiyou/presentation/providers/video_player_repository_usecases.dart';
import 'package:meiyou/presentation/widgets/add_space.dart';
import 'package:meiyou/presentation/widgets/player/controls/desktop/episodes_selector.dart';

class VideoPlayerTopRowMobile extends StatelessWidget {
  const VideoPlayerTopRowMobile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Row(children: [
              GestureDetector(
                child: const Icon(Icons.arrow_back_ios_new),
                onTap: () {
                  // context.pop();
                },
              ),
              addHorizontalSpace(20),
              _buildTitle(context),
              addHorizontalSpace(20),
            ]),
          ),
          Align(
              alignment: Alignment.centerRight,
              child: _buildVideoData(context)),
        ],
      );
    });
  }

  Widget _buildVideoData(BuildContext context) {
    return SizedBox(
      width: (context.screenWidth - (context.screenWidth * 0.6)) - 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                  onTap: () {
                    EpisodeSelectorWidget.showBottomSheet(context);
                  },
                  child: const Icon(Icons.video_library_sharp)),
              addHorizontalSpace(15),
              const Icon(Icons.lock_open),
            ],
          ),
          BlocBuilder<SelectedVideoDataCubit, SelectedVideoDataState>(
              builder: (context, selected) {
            if (selected is SelectedVideoDataStateInital) {
              return defaultSizedBox;
            }

            return Column(children: [
              addVerticalSpace(10),
              BlocBuilder<ExtractedVideoDataCubit, ExtractedVideoDataState>(
                builder: (context, state) {
                  return Text(
                    state.data[selected.serverIndex].link.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 14.5, fontWeight: FontWeight.w400),
                  );
                },
              ),
              addVerticalSpace(5),
              Text(context.bloc<PluginSelectorCubit>().state.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 14.5)),
              addVerticalSpace(5),
              BlocBuilder<VideoTrackCubit, VideoTrack>(
                  builder: (context, track) {
                return Text(
                  track == VideoTrack.auto()
                      ? 'Auto'
                      : '${track.w} x ${track.h}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 13.5, fontWeight: FontWeight.w400),
                );
              }),
            ]);
          })
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return SizedBox(
      width: context.screenWidth * 0.6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocBuilder<CurrentEpisodeCubit, int>(
            builder: (context, state) {
              return Text(
                context
                        .repository<VideoPlayerRepositoryUseCases>()
                        .getVideoTitleUseCase(context) ??
                    context.repository<MediaDetailsEntity>().name.trim(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                // videoTitle.trim(),
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                textAlign: TextAlign.left,
              );
            },
          ),
          if (context.repository<MediaDetailsEntity>().mediaItem is! Movie)
            Text(context.repository<MediaDetailsEntity>().name.trim(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.w400)),
        ],
      ),
    );
  }
}
