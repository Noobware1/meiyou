import 'package:flutter/material.dart';
import 'package:meiyou/shared/domain/models/media.dart';

class HomePageRowData {
  final String title;
  final List<Media> mediaList;
  final ScrollController controller;

  HomePageRowData({
    required this.title,
    required this.mediaList,
    required this.controller,
  });
}
