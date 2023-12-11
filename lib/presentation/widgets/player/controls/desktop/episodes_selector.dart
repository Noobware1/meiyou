import 'package:flutter/material.dart';
import 'package:meiyou/presentation/pages/info_page.dart';
import 'package:meiyou/presentation/providers/player_dependencies.dart';
import 'package:meiyou/presentation/providers/player_providers.dart';
import 'package:meiyou/presentation/widgets/add_space.dart';

class EpisodeSelectorButton extends StatelessWidget {
  const EpisodeSelectorButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        EpisodeSelectorWidget.showBottomSheet(context);
      },
      icon: const Icon(Icons.video_library_sharp),
    );
  }
}

class EpisodeSelectorWidget extends StatelessWidget {
  const EpisodeSelectorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      addVerticalSpace(10),
      const Expanded(child: SingleChildScrollView(child: WatchView())),
    ]);
  }

  static Future<T?> showBottomSheet<T>(BuildContext context) {
    return showModalBottomSheet<T>(
        isScrollControlled: true,
        showDragHandle: true,
        isDismissible: true,
        useSafeArea: true,
        context: context,
        builder: (secondContext) => PlayerProviders.wrap(
              context,
              PlayerDependenciesProvider.getFromContext(context)
                  .injector(const EpisodeSelectorWidget()),
            ));
  }
}
