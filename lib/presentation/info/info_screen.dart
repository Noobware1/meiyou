import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:meiyou/core/config/routes/routes.dart';

import 'package:meiyou/core/constants/font_size.dart';
import 'package:meiyou/core/constants/size_constants.dart';
import 'package:meiyou/core/utils/extensions/context.dart';
import 'package:meiyou/core/utils/resources/get_it/get_it.dart';
import 'package:meiyou/domain/library/models/library_item.dart';
import 'package:meiyou/domain/models/p.dart';
import 'package:meiyou/domain/models/progress.dart';
import 'package:meiyou/domain/library/library_repository.dart';
import 'package:meiyou/notifers/async_notifer.dart';
import 'package:meiyou/presentation/core/emoicon_widget.dart';
import 'package:meiyou/presentation/core/expandable_text.dart';
import 'package:meiyou/presentation/core/image_holder.dart';
import 'package:meiyou/presentation/core/getIt_widget.dart';
import 'package:meiyou/presentation/core/poster_holder.dart';
import 'package:meiyou/presentation/core/poster_view/poster_view.dart';
import 'package:meiyou/presentation/core/space.dart';
import 'package:meiyou/presentation/home/source_selector/selected_source.dart';
import 'package:meiyou/presentation/info/animated_sliver_header.dart';
import 'package:meiyou/presentation/info/content_widget/content_widget.dart';
import 'package:meiyou/presentation/info/services/info_screen_notifer.dart';
import 'package:meiyou/presentation/info/widgets/continue_from.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:nice_dart/nice_dart.dart';

class PresistentTabBar extends SliverPersistentHeaderDelegate {
  final TabController controller;

  PresistentTabBar(this.controller);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: context.theme.scaffoldBackgroundColor,
      child: TabBar(controller: controller, tabs: const [
        Tab(text: 'Watch'),
        Tab(text: 'Info'),
      ]),
    );
  }

  @override
  double get maxExtent => 48.0;

  @override
  double get minExtent => 48.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

class InfoScreen extends StatefulWidget {
  final ContentItem contentItem;
  final bool restore;

  const InfoScreen(
      {super.key, required this.contentItem, this.restore = false});

  const InfoScreen.autoRestore({super.key, required this.contentItem})
      : restore = true;

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen>
    with SingleTickerProviderStateMixin {
  late final ScrollController scrollController;
  late final TabController tabController;

  final defaultCornerPadding = const EdgeInsets.only(right: 15, left: 15);

  final bannerHeight = 300.0;

  final defaultTextStyle = const TextStyle(
    fontSize: MobileFontSize.normal,
    fontWeight: FontWeight.w500,
  );

  final defaultVerticalSpace = const VerticalSpace(10);

  @override
  void initState() {
    super.initState();
    getIt.registerSingleton(InfoScreenNotifer(widget.contentItem));
    scrollController = ScrollController();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    getIt.unregister<InfoScreenNotifer>();
    scrollController.dispose();
    tabController.dispose();
    if (widget.restore) {
      getIt.get<SelectedSource>().restore();
    }
    super.dispose();
  }

  void onSelected(Content? content, BuildContext context) {
    if (content == null) return;
    if (content.isAnime || content.isMovie || content.isSeries) {
      context.goToPlayerScreen();
    }
  }

  SelectedSource get selectedSource => getIt.get<SelectedSource>();
  @override
  Widget build(BuildContext context) {
    return GetItConsumer<InfoScreenNotifer, AsyncValue<InfoPage>>(
      listener: (context, state) {
        if (state.hasValue) {
          ContentWidget.registerWith(
              state.value!.content, state.value!.getContentProgress());
        }
      },
      builder: (context, state) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            forceMaterialTransparency: true,
          ),
          body: state.when(
            loading: whenLoading,
            error: (error, _) => whenError(error),
            data: whenData,
          ),
        );
      },
    );
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

  Widget whenData(InfoPage infoPage) {
    final width = context.width;

    final theme = context.theme;

    final safePadding = MediaQuery.of(context).padding;
    final safePaddingTop = safePadding.top;
    return NestedScrollView(
      controller: scrollController,
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          AnimatedSliverHeader(
              collaspeListener: (data) {},
              controller: scrollController,
              firstItem: SwitchableItem(
                height: bannerHeight,
                builder: (_) => bannerHeader(
                    width: width, theme: theme, infoPage: infoPage),
              ),
              safePadding: safePaddingTop,
              secondItem: SwitchableItem(
                height: kToolbarHeight,
                builder: (_) => titleHeader(
                    theme: theme, height: safePaddingTop, infoPage: infoPage),
              )),
          SliverToBoxAdapter(
            child: SafeArea(
                top: false,
                bottom: false,
                minimum: defaultCornerPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    defaultVerticalSpace,
                    bannerRowButton(infoPage, theme),
                    defaultVerticalSpace,
                    Row(
                      children: [
                        buildWithIcon(
                            icon: Icons.tv_rounded,
                            label: infoPage.category.toDisplayString()),
                        if (infoPage.startDate != null) ...[
                          const HorizontalSpace(10),
                          buildWithIcon(
                              icon: Icons.calendar_month_rounded,
                              label: infoPage.startDate!.toFormattedString())
                        ],
                        if (infoPage.rating != null) ...[
                          const HorizontalSpace(10),
                          buildWithIcon(
                              icon: Icons.star_rate_rounded,
                              label: infoPage.rating.toString()),
                        ]
                      ],
                    ),
                    defaultVerticalSpace,
                    description(
                      titleColor: surfaceColor,
                      textStyle: TextStyle(
                        color: surfaceColor,
                        fontSize: MobileFontSize.normal,
                        fontWeight: FontWeight.w400,
                      ),
                      description: buildString((it) {
                        it.writeln(
                          infoPage.description.isEmptyOrNull
                              ? 'No Synopsis.'
                              : infoPage.description!,
                        );
                        if (infoPage.otherTitles.isNotEmptyOrNull) {
                          it.writeln('');
                          it.write(
                              'Alternative names: ${infoPage.otherTitles}');
                        }
                      }),
                    ),
                    if (infoPage.genres.isNotEmptyOrNull) ...[
                      defaultVerticalSpace,
                      genres(
                          genres: infoPage.genres!,
                          colorScheme: context.theme.colorScheme),
                    ]
                  ],
                )),
          ),
          SliverPersistentHeader(
            delegate: PresistentTabBar(
              tabController,
            ),
            pinned: true,
          ),
          const SliverToBoxAdapter(
            child: VerticalSpace(20),
          ),
        ];
      },
      body: SafeArea(
        top: false,
        minimum: defaultCornerPadding,
        child: TabBarView(
          controller: tabController,
          children: [
            _Content(
              infoPage: infoPage,
              contentProgress: infoPage.getContentProgress(),
            ),
            _Info(
              infoPage: infoPage,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildWithIcon({required IconData icon, required String label}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: surfaceColor,
          size: 20,
        ),
        const HorizontalSpace(5),
        Text(
          label,
          style: TextStyle(
            fontSize: MobileFontSize.normal,
            fontWeight: FontWeight.w500,
            color: surfaceColor,
          ),
        ),
      ],
    );
  }

  Widget bannerRowButton(InfoPage infoPage, ThemeData theme) {
    final baseColor = surfaceColor;
    Widget _button(
        {required IconData icon,
        required String label,
        required VoidCallback onPressed}) {
      return ElevatedButton(
        style: ButtonStyle(
            iconColor: MaterialStateProperty.all(baseColor),
            alignment: Alignment.center,
            elevation: const MaterialStatePropertyAll(0.0),
            padding: MaterialStateProperty.all(const EdgeInsets.all(5)),
            backgroundColor: MaterialStateProperty.all(Colors.transparent),
            shape: MaterialStatePropertyAll(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ))),
        onPressed: onPressed,
        child: Column(
          children: [
            Icon(icon),
            const VerticalSpace(2),
            Text(label,
                style: TextStyle(
                  color: baseColor,
                  fontSize: MobileFontSize.small,
                  fontWeight: FontWeight.w400,
                )),
          ],
        ),
      );
    }

    return Container(
      color: theme.scaffoldBackgroundColor,
      padding: defaultCornerPadding,
      height: kToolbarHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _button(
              icon: Icons.add_outlined,
              label: 'Library',
              onPressed: () {
                onPressedLibrary(infoPage);
              }),
          _button(icon: Icons.sync, label: 'Tracking', onPressed: () {}),
          _button(icon: Icons.public, label: 'Webview', onPressed: () {}),
          _button(icon: Icons.share, label: 'Share', onPressed: () {}),
        ],
      ),
    );
  }

  void onPressedLibrary(InfoPage infoPage) {
    final selectedSource = getIt.get<SelectedSource>();
    final libraryItem = LibraryItem(
      sourceId: selectedSource.source!.id,
      type: selectedSource.type,
      title: infoPage.name,
      poster: infoPage.posterImage ?? infoPage.bannerImage,
      url: infoPage.url,
    );
    if (getIt.get<LibraryRepository>().getFromLibrary(
            selectedSource.source!, selectedSource.type, infoPage.name) ==
        null) {
      getIt.get<LibraryRepository>().addToLibary(libraryItem);
    }
  }

  Widget titleHeader({
    required ThemeData theme,
    required InfoPage infoPage,
    required double height,
  }) {
    return Container(
      padding: const EdgeInsets.only(left: 50, right: 15),
      height: kToolbarHeight,
      color: theme.scaffoldBackgroundColor,
      alignment: Alignment.centerLeft,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Text(
          infoPage.name,
          style: TextStyle(
            color: surfaceColor,
            fontSize: MobileFontSize.medium,
            fontWeight: FontWeight.w600,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget bannerHeader({
    required double width,
    required ThemeData theme,
    required InfoPage infoPage,
  }) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        bannerImage(
          width: width,
          theme: theme,
          bannerImage: infoPage.bannerImage,
          posterImage: infoPage.posterImage,
        ),
        SafeArea(
            top: false,
            bottom: false,
            child: posterHeader(
              width: width,
              theme: theme,
              infoPage: infoPage,
            )),
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

  Widget posterHeader({
    required double width,
    required ThemeData theme,
    required InfoPage infoPage,
  }) {
    return Container(
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
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
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
                    fontSize: MobileFontSize.large,
                    fontWeight: FontWeight.w600),
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
        ),
      );
    }
  }

  Widget genres(
      {required List<String> genres, required ColorScheme colorScheme}) {
    return wrapList(
      children: genres.mapList((element) {
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

  Widget description(
      {required Color titleColor,
      required TextStyle textStyle,
      required String description}) {
    return ExpandableText(
      text: description,
      style: textStyle,
      maxLines: 3,
    );
  }

  Widget wrapList({required List<Widget> children}) {
    return Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 10,
        runSpacing: 10,
        children: children);
  }

  Widget buildKeyAndValue({
    required String key,
    Widget? child,
    String? value,
    required Color keyColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const VerticalSpace(20),
        Text(
          key,
          style: TextStyle(
            color: keyColor,
            fontSize: MobileFontSize.normal,
            fontWeight: FontWeight.w500,
          ),
        ),
        const VerticalSpace(5),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: child ??
              Text(
                value!,
                style: const TextStyle(
                  fontSize: MobileFontSize.normal,
                  fontWeight: FontWeight.w600,
                ),
              ),
        ),
      ],
    );
  }

  Widget buildOtherTitles(Color titleColor, List<String> otherTitles) {
    return buildKeyAndValue(
      key: 'Alternative names',
      value: otherTitles.join(' , '),
      keyColor: titleColor,
    );
  }

  Color get surfaceColor =>
      context.theme.colorScheme.onSurface.withOpacity(0.8);

  Widget buildRow(String title, String value, {bool? usePrimary}) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            color: surfaceColor,
            fontSize: MobileFontSize.normal,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Text(value,
            style: TextStyle(
              color: usePrimary == true
                  ? context.theme.colorScheme.primary
                  : surfaceColor,
              fontSize: MobileFontSize.normal,
              fontWeight: FontWeight.w700,
            )),
      ],
    );
  }
}

class _Content extends StatefulWidget {
  final InfoPage infoPage;
  final ContentProgress? contentProgress;
  const _Content({
    super.key,
    required this.infoPage,
    required this.contentProgress,
  });

  @override
  State<_Content> createState() => _ContentState();
}

class _ContentState extends State<_Content> {
  void onSelected(Content? content, BuildContext context) {
    if (content == null) return;
    if (content.isAnime || content.isMovie || content.isSeries) {
      context.goToPlayerScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: (widget.infoPage.content == null)
          ? const Center(
              child: EmoticonsWidget(
                text: 'No Content Available!',
              ),
            )
          : Column(
              children: [
                ContinueFrom(
                  infoPage: widget.infoPage,
                  progress: widget.contentProgress,
                  onPressed: () => onSelected(widget.infoPage.content, context),
                ),
                const VerticalSpace(20),
                ContentWidget(
                  content: widget.infoPage.content!,
                  onSelected: () =>
                      onSelected(widget.infoPage.content, context),
                  contentProgress: widget.contentProgress,
                ),
              ],
            ),
    );
  }
}

class _Info extends StatefulWidget {
  final InfoPage infoPage;
  const _Info({
    super.key,
    required this.infoPage,
  });

  static const defaultStr = 'N/A';

  @override
  State<_Info> createState() => _InfoState();
}

class _InfoState extends State<_Info> {
  InfoPage get infoPage => widget.infoPage;

  @override
  Widget build(BuildContext context) {
    final titleColor = context.theme.colorScheme.onSurface.withOpacity(0.8);
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: SingleChildScrollView(
          // physics: physics,
          // controller: widget.controller,
          child: Column(
        children: [
          if (infoPage.characters.isEmptyOrNull &&
              infoPage.recommendations.isEmptyOrNull)
            const Center(
              child: EmoticonsWidget(
                text: 'Aww...So Empty!',
              ),
            )
          else if (infoPage.characters.isNotEmptyOrNull)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Characters',
                  style: TextStyle(
                    color: titleColor,
                    fontSize: MobileFontSize.medium,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const VerticalSpace(20),
                Expanded(
                    child: PosterView(
                        itemBuilder: (context, index) => PosterHolder(
                              imageUrl: infoPage.characters![index].image,
                              height: defaultPosterHeightMobile,
                              width: defaultPosterWidthMobile,
                            ),
                        itemCount: infoPage.characters!.length))
              ],
            )
          else if (infoPage.recommendations.isNotEmptyOrNull)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Recommendations',
                  style: TextStyle(
                    color: titleColor,
                    fontSize: MobileFontSize.medium,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const VerticalSpace(20),
                Expanded(
                    child: PosterView(
                        itemBuilder: (context, index) => PosterHolderWithTitle(
                              height: defaultPosterHeightMobile,
                              width: defaultPosterWidthMobile,
                              title: infoPage.recommendations![index].title,
                              textStyle: PosterHolder.titleTextStyleMobile,
                              // infoTextStyle: PosterHolder.infoTextStyleMobile,
                            ),
                        itemCount: infoPage.recommendations!.length))
              ],
            )
        ],
      )),
    );
  }

  Widget genres(
      {required List<String> genres, required ColorScheme colorScheme}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const VerticalSpace(20),
        Text(
          'Genres',
          style: TextStyle(
            color: colorScheme.onSurface.withOpacity(0.8),
            fontSize: MobileFontSize.normal,
            fontWeight: FontWeight.w500,
          ),
        ),
        const VerticalSpace(5),
        wrapList(list: genres, colorScheme: colorScheme),
      ],
    );
  }

  Widget description(
      {required Color titleColor,
      required TextStyle textStyle,
      required String description}) {
    return buildKeyAndValue(
      key: 'Synopsis',
      keyColor: titleColor,
      child: ExpandableText(
        text: description,
        style: textStyle,
        maxLines: 3,
      ),
    );
  }

  Widget wrapList(
      {required List<String> list, required ColorScheme colorScheme}) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 10,
      runSpacing: 10,
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

  Widget buildKeyAndValue({
    required String key,
    Widget? child,
    String? value,
    required Color keyColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const VerticalSpace(20),
        Text(
          key,
          style: TextStyle(
            color: keyColor,
            fontSize: MobileFontSize.normal,
            fontWeight: FontWeight.w500,
          ),
        ),
        const VerticalSpace(5),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: child ??
              Text(
                value!,
                style: const TextStyle(
                  fontSize: MobileFontSize.normal,
                  fontWeight: FontWeight.w600,
                ),
              ),
        ),
      ],
    );
  }

  Widget buildOtherTitles(Color titleColor, List<String> otherTitles) {
    return buildKeyAndValue(
      key: 'Alternative names',
      value: otherTitles.join(' , '),
      keyColor: titleColor,
    );
  }

  Widget buildRow(String title, String value,
      {required Color titleColor, Color? valueColor}) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            color: titleColor,
            fontSize: MobileFontSize.normal,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Text(value,
            style: TextStyle(
              color: valueColor,
              fontSize: MobileFontSize.normal,
              fontWeight: FontWeight.w700,
            )),
      ],
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
