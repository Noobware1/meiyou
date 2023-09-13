import 'package:flutter/material.dart';
import 'package:meiyou/presentation/widgets/video_server_view.dart';
import 'package:meiyou/presentation/widgets/watch/anime_view.dart';

class TvView extends StatelessWidget {
  final void Function(SelectedServer server)? onServerSelected;
  const TvView({
    super.key,
    this.onServerSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AnimeView(
      onServerSelected: onServerSelected,
    );
  }
}
