import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meiyou/core/constants/assets.dart';
import 'package:meiyou/core/resources/snackbar.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';
import 'package:meiyou/presentation/blocs/plugin_selector_cubit.dart';
import 'package:meiyou/presentation/pages/info_page.dart';
import 'package:meiyou/presentation/widgets/add_space.dart';
import 'package:meiyou/presentation/widgets/banner_view/banner_image_holder.dart';
import 'package:meiyou/presentation/widgets/gradient.dart';
import 'package:meiyou/presentation/widgets/image_view/image_holder.dart';
import 'package:meiyou/presentation/widgets/resizeable_text.dart';
import 'package:meiyou_extenstions/models.dart';
import 'package:meiyou_extenstions/extenstions.dart';

class InfoPageDesktop extends StatelessWidget {
  const InfoPageDesktop({super.key});

  static const defaultPadding = EdgeInsets.only(left: 100, right: 100);

  @override
  Widget build(BuildContext context) {
    final data = context.repository<MediaDetails>();
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            BannerImageHolder(
              imageUrl: data.bannerImage ?? data.posterImage ?? '',
              height: 350,
            ),
            DrawGradient(
              height: 350,
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                context.theme.scaffoldBackgroundColor,
                context.theme.scaffoldBackgroundColor.withOpacity(0.8),
                Colors.transparent,
              ],
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: defaultPadding.left,
                  top: 280,
                  bottom: defaultPadding.bottom,
                  right: defaultPadding.right),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(children: [
                    ImageHolder(
                        imageUrl: data.posterImage ?? '',
                        height: 280,
                        width: 200),
                    addVerticalSpace(20),
                    ElevatedButton.icon(
                      style: const ButtonStyle(
                          fixedSize: MaterialStatePropertyAll(Size(200, 40))),
                      onPressed: () {
                        showSnackBar(context, text: 'Coming soon');
                      },
                      label: const Text('Add To List',
                          style: TextStyle(
                            fontSize: 17,
                          )),
                      icon: const Icon(Icons.add),
                    ),
                  ]),
                  addHorizontalSpace(30),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 80),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            data.name.trim(),
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                                fontSize: 30, fontWeight: FontWeight.w600),
                          ),
                          if (data.otherTitles.isNotNullAndEmpty)
                            _buildOtherTitles(data.otherTitles!),
                          addVerticalSpace(20),
                          if (data.genres.isNotNullAndEmpty)
                            _buildGenres(data.genres!),
                          if (data.description != null) ...[
                            addVerticalSpace(20),
                            ResizeableTextWidget(
                              text: data.description!,
                              maxLines: 5,
                              style: const TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w400),
                              showButtons: true,
                            )
                          ],
                          addVerticalSpace(10),
                          _OtherInfo(mediaDetails: data),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              right: 30,
              top: 30,
              child: GestureDetector(
                onTap: () => context.pop(context),
                child: Container(
                  //      color: Colors.red,
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: context.theme.colorScheme.secondary),
                  child: const Icon(
                    Icons.close,
                    size: 30,
                  ),
                ),
              ),
            ),
          ],
        ),
        if (data.actorData.isNotNullAndEmpty) ...[
          addVerticalSpace(30),
          _buildActors(data.actorData!),
        ],
        addVerticalSpace(40),
        if (isMediaItemIsNotNullOrEmpty(data.mediaItem)) ...[
          Padding(
            padding: defaultPadding,
            child: Text(
              'Watch on ${context.bloc<PluginSelectorCubit>().state.name}',
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
            ),
          ),
          addVerticalSpace(30),
          const Padding(padding: defaultPadding, child: WatchView()),
          addVerticalSpace(40),
        ],
      ],
    );
  }

  Widget _buildActors(List<ActorData> data) {
    return _BuildActors(
      data: data,
    );
  }

  Widget _buildGenres(List<String> genres) {
    return Wrap(
      // alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      // runSpacing: 10,
      spacing: 10,
      children: genres
          .mapWithIndex((index, genre) => [
                Text(
                  genre,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                if (index != genres.length - 1)
                  Container(
                    height: 5,
                    width: 5,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.grey),
                  ),
              ])
          .reduce((a, b) => [...a, ...b]),
    );
  }

  Widget _buildOtherTitles(List<String> otherTitles) {
    return Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 10,
        children: otherTitles.mapWithIndex((index, title) {
          return Padding(
            padding: const EdgeInsets.only(right: 10, top: 10),
            child: Text(
              (index == otherTitles.length - 1) ? title : '$title,',
              style: const TextStyle(
                  fontSize: 15,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w400),
            ),
          );
        }));
  }
}

class _BuildActors extends StatefulWidget {
  final List<ActorData> data;
  const _BuildActors({
    // ignore: unused_element
    super.key,
    required this.data,
  });

  @override
  State<_BuildActors> createState() => _BuildActorsState();
}

class _BuildActorsState extends State<_BuildActors> {
  late final ScrollController controller;

  @override
  void initState() {
    controller = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  ImageProvider getImage(String? image) {
    if (image == null || image.isEmpty) {
      return const AssetImage(defaultposterImage);
    }
    return CachedNetworkImageProvider(
      image,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 100, left: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Cast',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
          ),
          addVerticalSpace(10),
          SizedBox(
            height: 200,
            child: Scrollbar(
              controller: controller,
              child: ListView.separated(
                  controller: controller,
                  // shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      width: 100,
                      child: Column(
                        children: [
                          CircleAvatar(
                              radius: 50,
                              backgroundImage:
                                  getImage(widget.data[index].image)),
                          Text(
                            widget.data[index].name,
                            textAlign: TextAlign.center,
                            maxLines: 3,
                          ),
                          if (widget.data[index].role != null)
                            Text(
                              widget.data[index].role!,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              style: const TextStyle(color: Colors.grey),
                            ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => addHorizontalSpace(20),
                  itemCount: widget.data.length),
            ),
          ),
        ],
      ),
    );
  }
}

class _OtherInfo extends StatelessWidget {
  final MediaDetails mediaDetails;
  const _OtherInfo({required this.mediaDetails});

  static const _titleTextStyle =
      TextStyle(color: Colors.grey, fontSize: 17, fontWeight: FontWeight.w700);

  static const _itemTextStyle =
      TextStyle(color: Colors.grey, fontSize: 17, fontWeight: FontWeight.w500);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      bool isSmall = constraints.maxWidth < 800;
      double defaultPadding = 50.0;
      double adjustedPadding = 20.0;

      final totalEpisodesOrSeasons = totalEpisodesORSeason(
          mediaDetails, isSmall ? adjustedPadding : defaultPadding);

      return Wrap(
        runSpacing: 10,
        children: [
          _build(
              space: isSmall ? adjustedPadding : defaultPadding,
              title: 'Mean Score',
              item: mediaDetails.rating?.toString() ?? '~'),
          _build(
              space: isSmall ? adjustedPadding : defaultPadding,
              title: 'Duration',
              item: mediaDetails.duration?.toString() ?? '~'),
          _build(
              space: isSmall ? adjustedPadding : defaultPadding,
              title: 'Status',
              item: (mediaDetails.status ?? ShowStatus.Unknown).toString()),
          _build(
              space: isSmall ? adjustedPadding : defaultPadding,
              title: 'Format',
              item: mediaDetails.type.toString()),
          if (totalEpisodesOrSeasons != null) totalEpisodesOrSeasons,
          if (mediaDetails.startDate != null)
            _build(
                space: isSmall ? adjustedPadding : defaultPadding,
                title: 'Start Date',
                item: mediaDetails.startDate!.toFormattedString()),
          if (mediaDetails.endDate != null)
            _build(
                space: isSmall ? adjustedPadding : defaultPadding,
                title: 'End Date',
                item: mediaDetails.endDate!.toFormattedString())
        ],
      );
    });
  }

  Widget? totalEpisodesORSeason(MediaDetails mediaDetails, double space) {
    final MapEntry<String, int>? entry;
    if (isAnime(mediaDetails)) {
      entry = MapEntry(
          'Total Episodes', (mediaDetails.mediaItem as Anime).episodes.length);
    } else if (isTv(mediaDetails)) {
      entry = MapEntry(
          'Total Season', (mediaDetails.mediaItem as TvSeries).data.length);
    } else {
      entry = null;
    }

    if (entry == null) return null;
    return _build(title: entry.key, item: entry.value.toString(), space: space);
  }

  Widget _build(
      {required String title, required String item, required double space}) {
    return Padding(
      padding: EdgeInsets.only(right: space),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: _titleTextStyle,
          ),
          addVerticalSpace(5),
          Text(
            item,
            style: _itemTextStyle,
          ),
        ],
      ),
    );
  }

  bool isAnime(MediaDetails mediaDetails) {
    if (mediaDetails.mediaItem != null && mediaDetails.mediaItem is Anime) {
      return true;
    }
    return false;
  }

  bool isTv(MediaDetails mediaDetails) {
    if (mediaDetails.mediaItem != null && mediaDetails.mediaItem is TvSeries) {
      return true;
    }
    return false;
  }
}
