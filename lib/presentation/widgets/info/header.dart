import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meiyou/core/constants/default_sized_box.dart';
import 'package:meiyou/core/resources/snackbar.dart';
import 'package:meiyou/core/utils/add_padding_onrientation_change.dart';
import 'package:meiyou/core/utils/extenstions/context.dart';
import 'package:meiyou/domain/entities/media_details.dart';
import 'package:meiyou/presentation/widgets/add_space.dart';
import 'package:meiyou/presentation/widgets/add_to_list.dart';
import 'package:meiyou/presentation/widgets/banner_view/banner_image_holder.dart';
import 'package:meiyou/presentation/widgets/custom_orientation_builder.dart';
import 'package:meiyou/presentation/widgets/gradient.dart';
import 'package:meiyou/presentation/widgets/image_view/image_holder.dart';
import 'package:meiyou/presentation/widgets/layout_builder.dart';

_copyToClipBoard(BuildContext context, MediaDetailsEntity data) {
  Clipboard.setData(ClipboardData(text: data.mediaTitle)).then(
      (value) => showSnackBAr(context, text: 'Copied ${data.mediaTitle}'));
}

class InfoHeader extends StatelessWidget {
  const InfoHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const ResponsiveBuilder(
        forSmallScreen: _ForSmallerScreens(),
        forLagerScreen: _ForBiggerScreens());
  }
}

class _ForSmallerScreens extends StatelessWidget {
  const _ForSmallerScreens();

  @override
  Widget build(BuildContext context) {
    final width = context.screenWidth;
    final data = RepositoryProvider.of<MediaDetailsEntity>(context);

    return Stack(
      children: [
        BannerImageHolder(
          imageUrl: data.bannerImage ?? data.poster ?? '',
          height: 400,
        ),
        const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: DrawGradient(
                height: 350,
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter)),
        Positioned(
            left: addPaddingOnOrientation(context).left,
            right: 0,
            // right: addPaddingOnOrientation(context).rights,
            bottom: 0,
            child: SizedBox(
              width: width,
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (width >= 205)
                        ImageHolder(
                          imageUrl: data.poster ?? '',
                        ),
                      addHorizontalSpace(10),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 30, top: 30),
                          // color: Colors.red,

                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onLongPress: () {
                                  _copyToClipBoard(context, data);
                                },
                                child: Text(
                                  data.mediaTitle,
                                  maxLines: 5,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              addVerticalSpace(10),
                              Text(
                                data.status,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: context.theme.colorScheme.primary),
                              ),
                              addVerticalSpace(10),
                              CustomOrientationBuiler(
                                portrait: defaultSizedBox,
                                landscape: _addToListButton(context),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  addVerticalSpace(10),
                  CustomOrientationBuiler(
                      landscape: defaultSizedBox,
                      portrait: _addToListButton(context))
                ],
              ),
            ))
      ],
    );
  }

  Widget _addToListButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 30),
      child: AddToListButton(onTap: () {
        showSnackBAr(context, text: 'Coming soon', width: 150);
      }),
    );
  }
}

class _ForBiggerScreens extends StatelessWidget {
  const _ForBiggerScreens();

  @override
  Widget build(BuildContext context) {
    final width = context.screenWidth / 2;
    final primaryColor = context.theme.colorScheme.primary;
    final data = RepositoryProvider.of<MediaDetailsEntity>(context);
    return Stack(
      children: [
        Container(
          height: 350,
        ),
        BannerImageHolder(
          imageUrl: data.bannerImage ?? data.poster ?? '',
          height: 300,
        ),
        const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: DrawGradient(
                height: 350,
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter)),
        Positioned(
            left: 50,
            bottom: 0,
            child: SizedBox(
              width: width,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ImageHolder(
                    imageUrl: data.poster ?? '',
                    height: 280,
                    width: 200,
                  ),
                  Expanded(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 60, top: 30),
                      // color: Colors.red,

                      child: DefaultTextStyle(
                        style: const TextStyle(),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onLongPress: () {
                                _copyToClipBoard(context, data);
                              },
                              child: Text(
                                data.mediaTitle,
                                maxLines: 5,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            addVerticalSpace(10),
                            Text(
                              data.status,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: primaryColor),
                            ),
                            addVerticalSpace(10),
                            ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: width),
                              child: AddToListButton(onTap: () {
                                showSnackBAr(context, text: 'Coming soon');
                              }),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ))
      ],
    );
  }
}
