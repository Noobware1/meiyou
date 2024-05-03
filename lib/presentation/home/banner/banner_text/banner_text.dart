// ignore_for_file: unused_element
library banner_text;

import 'package:flutter/material.dart';
import 'package:meiyou/presentation/core/simily_face.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:meiyou/core/constants/font_size.dart';
import 'package:meiyou/core/utils/resources/screen_size.dart';
import 'package:meiyou/presentation/core/space.dart';
import 'package:nice_dart/nice_dart.dart';

part 'banner_text_mobile.dart';
part 'banner_text_desktop.dart';

abstract class BannerText extends StatelessWidget {
  BannerText({super.key, required ContentItem item}) {
    title = item.title.trim().isNotEmpty ? item.title : 'No title';

    rating = item.rating != null && item.rating! > 0.0 ? item.rating : null;

    type = item.category.toDisplayString().toUpperCase();

    genres =
        item.generes == null || item.generes!.isEmpty ? null : item.generes;

    description = item.description == null || item.description!.trim().isEmpty
        ? null
        : item.description;
  }

  factory BannerText.forScreenSize({
    required ScreenSize screenSize,
    Key? key,
    required ContentItem item,
  }) {
    switch (screenSize) {
      case ScreenSize.Mobile:
        return BannerText.mobile(key: key, item: item);
      case ScreenSize.Desktop:
        return BannerText.desktop(key: key, item: item);
      default:
        throw Exception('Invalid screen type');
    }
  }

  factory BannerText.mobile({Key? key, required ContentItem item}) =>
      _BannerTextMobile(key: key, item: item);

  factory BannerText.desktop({Key? key, required ContentItem item}) =>
      _BannerTextDesktop(key: key, item: item);

  late final String title;

  late final double? rating;

  late final String type;

  late final List<String>? genres;

  late final String? description;

  Widget buildTitle(String title);

  List<Widget> buildType(String type);

  List<Widget> buildRating(double rating);

  Widget buildDescription(String description);

  Widget buildGenres(List<String> genres);
}

