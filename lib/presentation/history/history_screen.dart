import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:meiyou/core/constants/font_size.dart';
import 'package:meiyou/core/utils/extensions/context.dart';
import 'package:meiyou/core/utils/resources/get_it/get_it.dart';
import 'package:meiyou/core/utils/resources/toast.dart';
import 'package:meiyou/domain/models/history.dart';
import 'package:meiyou/domain/repositories/history_repository.dart';
import 'package:meiyou/extension/models/entension_type.dart';
import 'package:meiyou/notifers/async_notifer.dart';
import 'package:meiyou/presentation/core/dilog_box/alert_dialog_box.dart';
import 'package:meiyou/presentation/core/grouped_list_view.dart';
import 'package:meiyou/presentation/core/emoicon_widget.dart';
import 'package:meiyou/presentation/core/poster_holder.dart';
import 'package:meiyou/presentation/core/space.dart';
import 'package:meiyou/presentation/core/state_listenable_builder.dart';
import 'package:meiyou/presentation/history/notifers/history_notifer.dart';
import 'package:nice_dart/nice_dart.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {
  late final HistoryRepository historyRepository;
  late final TabController tabController;
  late final HistoryNotifer videoHistoryNotifer;
  late final HistoryNotifer mangaHistoryNotifer;
  late final HistoryNotifer novelHistoryNotifer;
  late ExtensionType selectedType;

  @override
  void initState() {
    super.initState();
    historyRepository = getIt.get<HistoryRepository>();
    tabController = TabController(length: 3, vsync: this);
    videoHistoryNotifer = HistoryNotifer(historyRepository.getVideoHistory);
    mangaHistoryNotifer = HistoryNotifer(historyRepository.getMangaHistory);
    novelHistoryNotifer = HistoryNotifer(historyRepository.getNovelHistory);
    selectedType = ExtensionType.Video;
    tabController.addListener(listener);
  }

  void listener() {
    if (tabController.index == 0) {
      selectedType = ExtensionType.Video;
    } else if (tabController.index == 1) {
      selectedType = ExtensionType.Manga;
    } else {
      selectedType = ExtensionType.Novel;
    }
  }

  @override
  void dispose() {
    tabController.removeListener(listener);
    tabController.dispose();
    videoHistoryNotifer.dispose();
    mangaHistoryNotifer.dispose();
    novelHistoryNotifer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.delete_sweep_outlined),
            onPressed: () {
              showAdaptiveDialog(
                context: context,
                builder: (context) => CustomAlertDialog(
                  title: 'Remove Everything',
                  content:
                      const Text('Are you sure? All history will be lost.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        historyRepository.deleteAll(selectedType);
                        context.pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('History cleared'),
                          ),
                        );
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
        bottom: TabBar(
          onTap: (value) {},
          controller: tabController,
          tabs: const [
            Tab(text: 'Video'),
            Tab(text: 'Manga'),
            Tab(text: 'Novel'),
          ],
        ),
      ),
      body: Column(
        children: [
          const VerticalSpace(30),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                StateListenableBuilder(
                    stateListenable: videoHistoryNotifer,
                    builder: (context, state, _) {
                      return body(state, isVideo: true);
                    }),
                StateListenableBuilder(
                    stateListenable: mangaHistoryNotifer,
                    builder: (context, state, _) {
                      return body(state);
                    }),
                StateListenableBuilder(
                    stateListenable: novelHistoryNotifer,
                    builder: (context, state, _) {
                      return body(state);
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget body(AsyncValue<Map<String, List<History>>> history,
      {bool isVideo = false}) {
    if (history.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (history.value.isNotEmptyOrNull &&
        history.value!.values.every((element) => element.isNotEmpty)) {
      return buildHistoryEntries(history.value!);
    }
    return ifEmpty(isVideo);
  }

  Widget ifEmpty(bool isVideo) {
    return Center(
      child: EmoticonsWidget(
          text: isVideo ? 'Nothing watched recently' : 'Nothing read recently'),
    );
  }

  Widget buildHistoryEntries(Map<String, List<History>> history) {
    return GroupedListView(
      group: history,
      groupHeaderBuilder: (context, date) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
          child: Text(
            date,
            style: const TextStyle(
              fontSize: MobileFontSize.semiMedium,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
      itemBuilder: (_, __, item) {
        return historyTile(item: item);
      },
      seperatorBuilder: (context) {
        return const VerticalSpace(8);
      },
    );
  }

  Widget historyTile({
    required History item,
  }) {
    return Material(
      type: MaterialType.button,
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          // Route.player.push(context, extra: item);
        },
        child: SizedBox(
          height: 105,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const HorizontalSpace(12),
              PosterHolder(
                imageUrl: item.poster,
                width: 60,
                height: 90,
              ),
              const HorizontalSpace(12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: MobileFontSize.normal,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const VerticalSpace(4),
                      Text(
                        item.progressString,
                        style: context.theme.listTileTheme.subtitleTextStyle,
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.delete_outline_rounded,
                  color: context.theme.colorScheme.onSurface,
                ),
                onPressed: () {
                  historyRepository.deleteHistory(item);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
