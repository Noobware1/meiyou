import 'package:flutter/material.dart' hide Gradient;
import 'package:injecktor/injecktor.dart';
import 'package:meiyou/core/constants/font_size.dart';
import 'package:meiyou/core/constants/size_constants.dart';
import 'package:meiyou/core/utils/extensions/context.dart';
import 'package:meiyou/core/utils/resources/async_cubit.dart';
import 'package:meiyou/presentation/core/injectktor_widget.dart';
import 'package:meiyou/presentation/core/image_holder.dart';
import 'package:meiyou/presentation/core/poster_holder.dart';
import 'package:meiyou/presentation/core/resizeable_text_widget.dart';
import 'package:meiyou/presentation/core/simily_face.dart';
import 'package:meiyou/presentation/core/space.dart';
import 'package:meiyou/presentation/info/content_widget/content_widget.dart';
import 'package:meiyou/presentation/info/services/info_screen_cubit.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:nice_dart/nice_dart.dart';

class InfoScreen extends InjecktorWidget {
  final ContentItem contentItem;
  const InfoScreen({
    super.key,
    required this.contentItem,
  });

  static const defaultCornerPadding = EdgeInsets.only(right: 15, left: 15);

  static const bannerHeight = 300.0;

  static const defaultTextStyle = TextStyle(
    fontSize: MobileFontSize.normal,
    fontWeight: FontWeight.w500,
  );

  static const defaultVerticalSpace = SizedBox(height: 10);

  @override
  Widget build(BuildContext context) {
    addSingleton(context, () => InfoScreenCubit(InjectKtor.get(), contentItem));
    final width = context.width;
    final theme = context.theme;
    final onSurfaceColor = theme.colorScheme.onSurface.withOpacity(0.8);
    final baseTextStyle = defaultTextStyle.copyWith(
      color: onSurfaceColor,
    );
    return SafeArea(
      left: true,
      right: true,
      top: false,
      bottom: false,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
            elevation: 0.0,
            forceMaterialTransparency: true,
            leading: BackButton(
              onPressed: () => Navigator.pop(context),
            )
            // scrolledUnderElevation: 0.0,
            ),
        body: SingleChildScrollView(child:
            InjecktorBlocBuilder<InfoScreenCubit, AsyncValue<InfoPage>>(
                builder: (context, state) {
          return state.when(
            loading: whenLoading,
            error: (error, _) {
              return whenError(error);
            },
            data: (infoPage) => whenData(
              width: width,
              theme: theme,
              onSurfaceColor: onSurfaceColor,
              baseTextStyle: baseTextStyle,
              infoPage: infoPage,
              onSelected: () {
                onSelected(infoPage.content, context);
              },
            ),
          );
        })),
      ),
    );
  }

  void onSelected(Content? content, BuildContext context) {
    if (content == null) return;
    if (content.isAnime || content.isMovie || content.isSeries) {
      context.goToPlayerScreen();
    }
  }

  Widget whenError(Object error) {
    return Center(
      child: Text(error.toString()),
    );
  }

  Widget whenLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget whenData(
      {required double width,
      required ThemeData theme,
      required Color onSurfaceColor,
      required TextStyle baseTextStyle,
      required InfoPage infoPage,
      required void Function() onSelected}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        banner(
          width: width,
          theme: theme,
          infoPage: infoPage,
        ),
        defaultVerticalSpace,
        Container(
          padding: defaultCornerPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              bannerRowButton(theme),
              defaultVerticalSpace,
              details(
                textStyle: baseTextStyle,
                theme: theme,
                width: width,
                onSurfaceColor: onSurfaceColor,
                infoPage: infoPage,
              ),
              defaultVerticalSpace,
              description(
                textStyle: baseTextStyle,
                description: infoPage.displayDescription,
              ),
              defaultVerticalSpace,
              if (infoPage.genres.isNotEmptyOrNull) ...[
                wrapList(
                  list: infoPage.genres!,
                  colorScheme: theme.colorScheme,
                ),
                defaultVerticalSpace,
              ],
              if (infoPage.content != null)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: ContentWidget(
                    content: infoPage.content!,
                    onSelected: onSelected,
                  ),
                )
            ],
          ),
        ),
      ],
    );
  }

  Widget banner({
    required double width,
    required ThemeData theme,
    required InfoPage infoPage,
  }) {
    return SizedBox(
      height: bannerHeight,
      width: width,
      child: Stack(
        children: [
          bannerImage(
            width: width,
            theme: theme,
            bannerImage: infoPage.bannerImage,
            posterImage: infoPage.posterImage,
          ),
          Container(
            height: bannerHeight,
            width: width,
            padding: defaultCornerPadding,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                PosterHolder(
                  imageUrl: infoPage.posterImage,
                  height: defaultPosterHeightMobile,
                  width: defaultPosterWidthMobile,
                ),
                const HorizontalSpace(10),
                titleAndStatus(
                  width: width,
                  theme: theme,
                  title: infoPage.name,
                  status: infoPage.status,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget bannerRowButton(ThemeData theme) {
    return SizedBox(
      height: 40,
      child: Row(
        children: [
          ElevatedButton.icon(
            style: ButtonStyle(
              side: MaterialStatePropertyAll(
                  BorderSide(color: theme.colorScheme.primary)),
              elevation: const MaterialStatePropertyAll(0),
              iconSize: const MaterialStatePropertyAll(20),
            ),
            onPressed: () {},
            icon: const Icon(Icons.favorite_border),
            label: const Text('Add to Library'),
          ),
          const Spacer(),
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.sync),
              tooltip: 'Tracking'),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.public,
            ),
            tooltip: 'Webview',
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.share,
            ),
            tooltip: 'Share',
          )
        ],
      ),
    );
  }

  Widget details({
    required TextStyle textStyle,
    required ThemeData theme,
    required double width,
    required Color onSurfaceColor,
    required InfoPage infoPage,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (infoPage.rating != null) ...[
          buildWithIcon(
            icon: SmilyFace(score: infoPage.rating ?? 0.0, size: 20),
            label: RichText(
                text: TextSpan(children: [
              TextSpan(
                  text: (infoPage.rating ?? 0.0).toString(),
                  style: defaultTextStyle.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  )),
              TextSpan(
                text: ' / 10',
                style: textStyle,
              ),
            ])),
          ),
          const HorizontalSpace(10),
        ],
        buildWithIcon(
          icon: Icon(Icons.tv, size: 20, color: onSurfaceColor),
          label: Text(
            infoPage.category.toDisplayString(),
            style: textStyle,
          ),
        ),
        const HorizontalSpace(10),
        if (infoPage.startDate != null)
          buildWithIcon(
            icon:
                Icon(Icons.date_range_rounded, size: 20, color: onSurfaceColor),
            label: Text(
              width < 330
                  ? infoPage.startDate!.year.toString()
                  : infoPage.startDate!.toFormattedString(),
              style: textStyle,
            ),
          ),
      ],
    );
  }

  Widget bannerImage({
    required double width,
    required ThemeData theme,
    required String? bannerImage,
    required String? posterImage,
  }) {
    return DecoratedBox(
      position: DecorationPosition.foreground,
      decoration: BoxDecoration(
        border: Border.all(
            strokeAlign: -0.050, color: theme.scaffoldBackgroundColor),
        gradient: LinearGradient(
          begin: const Alignment(0.0, 1.0), // Adjust the begin point
          end: const Alignment(0.0, -1.0),
          colors: [theme.scaffoldBackgroundColor, Colors.transparent],
        ),
      ),
      child: ImageHolder(
        imageUrl: bannerImage ?? posterImage,
        height: bannerHeight,
        width: width,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget titleAndStatus({
    required double width,
    required ThemeData theme,
    required String title,
    required Status? status,
  }) {
    {
      return Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const VerticalSpace(10),
            Text(
              title.trim(),
              textAlign: TextAlign.left,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontSize: MobileFontSize.large, fontWeight: FontWeight.w600),
            ),
            Text(
              (status ?? Status.Unknown).toDisplayString(),
              style: TextStyle(
                fontSize: MobileFontSize.semiLarge,
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget description(
      {required TextStyle textStyle, required String description}) {
    return ResizableText(text: description, textStyle: textStyle);
  }

  Widget buildWithIcon({required Widget icon, required Widget label}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        icon,
        const HorizontalSpace(5),
        label,
      ],
    );
  }

  Widget wrapList(
      {required List<String> list, required ColorScheme colorScheme}) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 10,
      children: list.mapList((element) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: colorScheme.primary),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: Text(
            element,
            style: TextStyle(
              color: colorScheme.primary,
              fontSize: MobileFontSize.small,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      }),
    );
  }
}

extension on DateTime {
  String toFormattedString() {
    return '$day ${getMonthName(month)}, $year';
  }

  String getMonthName(int month) {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'Febuary';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return throw Exception('Invalid month');
    }
  }
}

extension on InfoPage {
  String get displayDescription {
    return buildString((it) {
      if (description.isEmptyOrNull) {
        it.write('No description');
      } else {
        it.write(description);
      }
      if (otherTitles.isNotEmptyOrNull) {
        it.writeln();

        it.writeln();
        it.write('Alternative names: ${otherTitles!.join(' , ')}');
      }
    });
  }
}
