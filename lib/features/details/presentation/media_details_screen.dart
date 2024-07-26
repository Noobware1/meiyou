import 'package:flutter/material.dart';
import 'package:meiyou/details.dart';
import 'package:meiyou_extensions_lib/models.dart';

class MediaScreen extends StatefulWidget {
  final int mediaDetailsId;
  const MediaScreen({super.key, required this.mediaDetailsId});

  @override
  State<MediaScreen> createState() => _MediaScreenState();
}

class _MediaScreenState extends State<MediaScreen> {
  @override
  Widget build(BuildContext context) {
    final details = getDetails();

    return Container();
  }
}
