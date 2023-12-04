import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meiyou/core/constants/animation_duration.dart';
import 'package:meiyou/core/constants/assets.dart';
import 'package:meiyou/core/constants/default_widgets.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';
import 'package:meiyou/core/utils/extenstions/date_titme.dart';
import 'package:meiyou/core/utils/extenstions/iterable.dart';
import 'package:meiyou/core/utils/extenstions/list.dart';
import 'package:meiyou/core/utils/extenstions/string.dart';
import 'package:meiyou/data/models/media_item/anime.dart';
import 'package:meiyou/data/models/media_item/tv_series.dart';
import 'package:meiyou/domain/entities/actor_data.dart';
import 'package:meiyou/domain/entities/media_details.dart';
import 'package:meiyou/domain/entities/show_status.dart';
import 'package:meiyou/presentation/blocs/plugin_selector_cubit.dart';
import 'package:meiyou/presentation/pages/info_page.dart';
import 'package:meiyou/presentation/widgets/add_space.dart';
import 'package:meiyou/presentation/widgets/banner_view/banner_image_holder.dart';
import 'package:meiyou/presentation/widgets/custom_orientation_builder.dart';
import 'package:meiyou/presentation/widgets/gradient.dart';
import 'package:meiyou/presentation/widgets/image_view/image_holder.dart';
import 'package:meiyou/presentation/widgets/resizeable_text.dart';

class InfoPageMobile extends StatelessWidget {
  const InfoPageMobile({super.key});

  static const defaultPadding = EdgeInsets.only(right: 15, left: 15);

  @override
  Widget build(BuildContext context) {
    final data = context.repository<MediaDetailsEntity>();
    return SafeArea(
      left: true,
      right: true,
      top: false,
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // addVerticalSpace(280),
          Stack(
            children: [
              BannerImageHolder(
                imageUrl: data.bannerImage ?? data.posterImage ?? '',
                height: 300,
              ),
              DrawGradient(
                height: 300,
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
                    top: 150,
                    right: defaultPadding.right,
                    left: defaultPadding.left,
                    bottom: defaultPadding.bottom),
                child: SizedBox(
                  width: context.screenWidth,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Builder(builder: (context) {
                        if ((context.screenWidth - 30) <= 140) {
                          return Expanded(
                            child: ImageHolder(
                              imageUrl: data.posterImage ?? '',
                            ),
                          );
                        }
                        return ImageHolder(
                          imageUrl: data.posterImage ?? '',
                        );
                      }),
                      addHorizontalSpace(20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            addVerticalSpace(10),
                            Text(
                              data.name.trim(),
                              textAlign: TextAlign.left,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.w600),
                            ),
                            addVerticalSpace(10),
                            Text(
                              (data.status ?? ShowStatus.Unknown).toString(),
                              style: TextStyle(
                                  fontSize: 18,
                                  color: context.theme.colorScheme.primary,
                                  fontWeight: FontWeight.w600),
                            ),
                            addVerticalSpace(10),
                            CustomOrientationBuiler(
                                landscape: AddToListButton(
                                  onTap: () {},
                                ),
                                portrait: defaultSizedBox),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                right: 10,
                top: 50,
                child: GestureDetector(
                  onTap: () => context.pop(context),
                  child: Container(
                    //      color: Colors.red,
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: context.theme.colorScheme.secondary),
                    child: const Icon(
                      Icons.close,
                      size: 25,
                    ),
                  ),
                ),
              ),
            ],
          ),
          addVerticalSpace(10),
          Padding(
            padding: defaultPadding,
            child: CustomOrientationBuiler(
                landscape: defaultSizedBox,
                portrait: AddToListButton(onTap: () {})),
          ),
          addVerticalSpace(10),
          _buildInfo(data),
          addVerticalSpace(10),
          if (data.description != null)
            Padding(
              padding: defaultPadding,
              child: ResizeableTextWidget(
                  text: data.description!, maxLines: 3, showButtons: true),
            ),

          if (data.actorData.isNotNullAndEmpty) ...[
            addVerticalSpace(10),
            _buildActors(data.actorData!)
          ],
          if (data.genres.isNotNullAndEmpty) ...[
            addVerticalSpace(10),
            _buildGenres(data.genres!, context),
          ],
          if (data.otherTitles.isNotNullAndEmpty) ...[
            addVerticalSpace(10),
            _buildOtherTitles(data.otherTitles!, context)
          ],
          addVerticalSpace(10),

          const Divider(thickness: 2),
          addVerticalSpace(10),
          if (isMediaItemIsNotNullOrEmpty(data.mediaItem)) ...[
            Padding(
              padding: defaultPadding,
              child: Text(
                'Watch On ${context.bloc<PluginSelectorCubit>().state.name.toUpperCaseFirst()}',
                maxLines: 1,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ),
            addVerticalSpace(20),
            const Padding(padding: defaultPadding, child: WatchView()),
            addVerticalSpace(40),
          ]
        ],
      ),
    );
  }

  Widget _buildGenres(List<String> genres, BuildContext context) {
    return _wrap(genres, context);
  }

  Widget _wrap(List<String> list, BuildContext context) {
    return Padding(
      padding: defaultPadding,
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 10,
        children: list.mapAsList((element) {
          return Container(
            decoration: BoxDecoration(
              color: context.theme.colorScheme.tertiary,
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.all(6),
            child: Text(
              element,
              style: const TextStyle(fontSize: 13.5),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildInfo(MediaDetailsEntity data) {
    Widget row(String key, String value) {
      return Flexible(
        child: Row(
          // mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(key,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey)),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  value,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: defaultPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          row('Mean Score', '${data.rating?.toString() ?? '~'} / 10'),
          addVerticalSpace(5),
          row('Format', data.type.toString()),
          addVerticalSpace(5),
          row('Average Duration',
              data.duration != null ? '${data.duration!.inMinutes} min' : '??'),
          addVerticalSpace(5),
          row('Start Date', data.startDate?.toFormattedString() ?? '??'),
          addVerticalSpace(5),
          row('End Date', data.endDate?.toFormattedString() ?? '??'),
          if (data.mediaItem is Anime) ...[
            addVerticalSpace(5),
            row('Total Episodes',
                (data.mediaItem as Anime).episodes.length.toString()),
          ],
          if (data.mediaItem is TvSeries) ...[
            addVerticalSpace(5),
            row('Total Season',
                (data.mediaItem as TvSeries).data.length.toString()),
            addVerticalSpace(5),
            row(
                'Total Episodes',
                (data.mediaItem as TvSeries)
                    .data
                    .map((e) => e.episodes.length)
                    .fold(0, (a, b) => a + b)
                    .toString()),
          ]
        ],
      ),
    );
  }

  Widget _buildOtherTitles(List<String> otherTitles, BuildContext context) {
    return _wrap(otherTitles, context);
  }

  Widget _buildActors(List<ActorDataEntity> data) {
    ImageProvider getImage(String? image) {
      if (image == null || image.isEmpty) {
        return const AssetImage(defaultposterImage);
      }
      return CachedNetworkImageProvider(
        image,
      );
    }

    return Padding(
      padding: defaultPadding,
      child: SizedBox(
        height: 140,
        child: ListView.separated(
            // shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return SizedBox(
                width: 60,
                child: Column(
                  children: [
                    CircleAvatar(
                        radius: 30,
                        backgroundImage: getImage(data[index].image)),
                    Text(
                      data[index].name,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: const TextStyle(fontSize: 13),
                    ),
                    if (data[index].role != null)
                      Text(
                        data[index].role!,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style:
                            const TextStyle(fontSize: 13, color: Colors.grey),
                      )
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) => addHorizontalSpace(10),
            itemCount: data.length),
      ),
    );
  }
}

class AddToListButton extends StatelessWidget {
  final VoidCallback onTap;
  final double? width;
  const AddToListButton({super.key, required this.onTap, this.width});

  static const _borderRadius = BorderRadius.all(Radius.circular(15));

  @override
  Widget build(BuildContext context) {
    return Material(
      animationDuration: animationDuration,
      borderRadius: _borderRadius,
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        borderRadius: _borderRadius,
        splashColor: context.theme.colorScheme.primary,
        child: Container(
          alignment: Alignment.center,
          height: 50,
          width: width ?? context.screenWidth,
          decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: Colors.grey),
              borderRadius: _borderRadius),
          child: Text(
            'ADD TO LIST',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: context.theme.colorScheme.primary,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
