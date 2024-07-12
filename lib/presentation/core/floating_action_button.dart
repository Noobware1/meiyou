import 'package:flutter/material.dart';

import 'package:meiyou/core/utils/extensions/context.dart';
import 'package:meiyou/core/utils/resources/get_it/get_it.dart';
import 'package:meiyou/domain/source/source_manager.dart';
import 'package:meiyou/extension/models/entension_type.dart';
import 'package:meiyou/presentation/home/source_selector/source_selector.dart';
import 'package:meiyou_extensions_lib/models.dart';

class OkFloatActionButton extends StatelessWidget {
  final String title;
  final Object heroTag;
  final void Function() onTap;
  final IconData icon;

  const OkFloatActionButton({
    super.key,
    required this.title,
    required this.heroTag,
    required this.onTap,
    this.icon = Icons.view_headline_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      heroTag: heroTag,
      icon: Icon(icon),
      label: Text(title),
      onPressed: onTap,
    );
  }
}
