import 'package:flutter/material.dart';
import 'package:meiyou/presentation/widgets/add_space.dart';
import 'package:meiyou/presentation/widgets/season_selector/season_selector.dart';

class TvView extends StatefulWidget {
  const TvView({super.key});

  @override
  State<TvView> createState() => _TvViewState();
}

class _TvViewState extends State<TvView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SeasonSelector(),
        addVerticalSpace(10),
        
      ],
    );
  }
}

